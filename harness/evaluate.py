#!/usr/bin/env python3
# =========================================================================
# evaluate.py — VerilogEval v2 spec-to-rtl 評測器(WSL / 容器內執行)
# =========================================================================
# 判定邏輯忠實復刻官方 scripts/sv-iv-analyze 與 Makefile.in:
#   編譯:iverilog -Wall -Winfloop -Wno-timescale -g2012 -s tb -o BIN sample.sv test.sv ref.sv
#   執行:timeout 30 ./BIN
#   分類碼:'.'=pass  S=語法錯  e=需顯式轉型  0=零位寬常數  n=無敏感列表
#           w=wire 誤用  m=模組名錯(非 TopModule) c=clk 未繫結  p=埠未繫結
#           T=逾時  R=行為不符(Mismatches>0) C=其他編譯錯  ?=未知
#
# 設計為在 LibreLane 容器內執行(容器已含 iverilog 與 python3,免 sudo):
#   docker run --rm -v $HOME:$HOME -w $HOME/edge-rtl-agent \
#     ghcr.io/librelane/librelane:3.0.10 \
#     python3 harness/evaluate.py --completions results/completions_3b \
#       --dataset ../verilog-eval/dataset_spec-to-rtl --out results/baseline_3b.json
# =========================================================================
import argparse
import json
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

MISMATCH_RE = re.compile(r"^Mismatches: (\d+) in \d+ samples$", re.M)


def classify(log_text):
    """照官方 sv-iv-analyze 的順序與字串規則分類單一結果。"""
    error_c = False
    error_p = False
    timeout = False
    mismatches = None

    for line in log_text.splitlines():
        if "syntax error" in line:
            return "S", None
        if "error: This assignment requires an explicit cast" in line:
            return "e", None
        if "error: Sized numeric constant must have a size greater than zero" in line:
            return "0", None
        if ("warning: always_comb process has no sensitivities" in line
                or "found no sensitivities so it will never trigger" in line):
            return "n", None
        if "is declared here as wire" in line:
            return "w", None
        if "Unknown module type" in line:
            return "m", None
        if "Unable to bind wire/reg/memory `clk'" in line:
            return "c", None
        if "Unable to bind wire/reg" in line:
            error_p = True
        if "TIMEOUT" in line:
            timeout = True
        if "error" in line:
            error_c = True
        match = MISMATCH_RE.match(line.strip())
        if match:
            mismatches = int(match.group(1))

    if timeout:
        return "T", mismatches
    if mismatches is not None:
        return (".", 0) if mismatches == 0 else ("R", mismatches)
    if error_p:
        return "p", None
    if error_c:
        return "C", None
    return "?", None


def run_one(sample_sv, test_sv, ref_sv):
    """編譯+執行一題,回傳合併 log(編譯與模擬輸出都進分類器)。"""
    with tempfile.TemporaryDirectory() as tmp:
        binary = os.path.join(tmp, "tb_bin")
        compile_cmd = [
            "iverilog", "-Wall", "-Winfloop", "-Wno-timescale",
            "-g2012", "-s", "tb", "-o", binary,
            sample_sv, test_sv, ref_sv,
        ]
        proc = subprocess.run(compile_cmd, capture_output=True, text=True)
        log = proc.stdout + proc.stderr
        if proc.returncode != 0 or not os.path.exists(binary):
            return log
        try:
            sim = subprocess.run([binary], capture_output=True, text=True, timeout=30)
            log += sim.stdout + sim.stderr
        except subprocess.TimeoutExpired:
            log += "\nTIMEOUT\n"
        return log


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--completions", required=True)
    ap.add_argument("--dataset", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    results = {}
    code_string = ""
    prob_dirs = sorted(
        d for d in os.listdir(args.completions)
        if os.path.isdir(os.path.join(args.completions, d))
    )
    for prob in prob_dirs:
        sample = os.path.join(args.completions, prob, "sample01.sv")
        test = os.path.join(args.dataset, prob + "_test.sv")
        ref = os.path.join(args.dataset, prob + "_ref.sv")
        if not (os.path.exists(sample) and os.path.exists(test) and os.path.exists(ref)):
            continue
        log = run_one(sample, test, ref)
        code, mism = classify(log)
        results[prob] = {"code": code, "mismatches": mism}
        code_string += code
        print(f"{prob:40s} {code}" + (f"  (mismatches={mism})" if mism else ""), flush=True)

    n = len(results)
    npass = sum(1 for r in results.values() if r["code"] == ".")
    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "task": "spec-to-rtl",
        "n_problems": n,
        "n_pass": npass,
        "pass_at_1": round(npass / n, 4) if n else 0.0,
        "code_string": code_string,
        "per_problem": results,
    }
    # 帶上生成端 metadata(若存在),讓單一結果檔自我完備
    meta_path = os.path.join(args.completions, "run_metadata.json")
    if os.path.exists(meta_path):
        with open(meta_path) as f:
            summary["generation"] = json.load(f)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    print(f"\npass@1 = {npass}/{n} = {summary['pass_at_1']}")
    print(f"codes  = {code_string}")
    print(f"寫入 {args.out}")


if __name__ == "__main__":
    main()
