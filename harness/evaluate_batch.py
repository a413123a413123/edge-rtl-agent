#!/usr/bin/env python3
# =========================================================================
# evaluate_batch.py — 多樣本評測器(pilot 與 pass@k 用,WSL / 容器內執行)
# =========================================================================
# 判定邏輯直接沿用 evaluate.py 的 classify/run_one(單一事實來源,不複製);
# 差異:每題評 sample*.sv 全部樣本,輸出 per-problem 通過數 c/n 與
# HumanEval 無偏 pass@k 估計。
# 用法(容器內):
#   docker run --rm -v $HOME:$HOME -w $HOME/edge-rtl-agent \
#     ghcr.io/librelane/librelane:3.0.10 \
#     python3 harness/evaluate_batch.py --completions results/completions_pilot_3b_q4 \
#       --dataset ../verilog-eval/dataset_spec-to-rtl --out results/pilot_3b_q4.json
import argparse
import glob
import json
import math
import os
from datetime import datetime, timezone

from evaluate import classify, run_one


def pass_at_k(n, c, k):
    """HumanEval 無偏估計:1 - C(n-c,k)/C(n,k),數值穩定連乘形式。"""
    if n - c < k:
        return 1.0
    prod = 1.0
    for i in range(k):
        prod *= (n - c - i) / (n - i)
    return 1.0 - prod


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--completions", required=True)
    ap.add_argument("--dataset", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    per_problem = {}
    prob_dirs = sorted(
        d for d in os.listdir(args.completions)
        if os.path.isdir(os.path.join(args.completions, d))
    )
    for prob in prob_dirs:
        samples = sorted(glob.glob(os.path.join(args.completions, prob, "sample*.sv")))
        test = os.path.join(args.dataset, prob + "_test.sv")
        ref = os.path.join(args.dataset, prob + "_ref.sv")
        if not (samples and os.path.exists(test) and os.path.exists(ref)):
            continue
        codes = ""
        for s in samples:
            log = run_one(s, test, ref)
            code, _ = classify(log)
            codes += code
        c = codes.count(".")
        per_problem[prob] = {"codes": codes, "n": len(codes), "c": c}
        print(f"{prob:40s} {codes}  ({c}/{len(codes)})", flush=True)

    n_list = {p["n"] for p in per_problem.values()}
    n_common = min(n_list) if n_list else 0
    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "task": "spec-to-rtl",
        "n_problems": len(per_problem),
        "n_samples_per_problem": sorted(n_list),
        # pass@1 = 各題 c/n 的平均(等同無偏 pass@1)
        "pass_at_1": round(
            sum(p["c"] / p["n"] for p in per_problem.values()) / len(per_problem), 4
        ) if per_problem else 0.0,
        "per_problem": per_problem,
    }
    if n_common >= 5:
        summary["pass_at_5"] = round(
            sum(pass_at_k(p["n"], p["c"], 5) for p in per_problem.values())
            / len(per_problem), 4
        )
    meta_path = os.path.join(args.completions, "metadata.jsonl")
    if os.path.exists(meta_path):
        # utf-8-sig:PowerShell 5.1 的 Add-Content -Encoding UTF8 會在首行寫入 BOM
        with open(meta_path, encoding="utf-8-sig") as f:
            metas = [json.loads(l) for l in f if l.strip()]
        if metas:
            summary["generation"] = {
                "model": metas[0].get("model"),
                "shots": metas[0].get("shots"),
                "temperature": metas[0].get("temperature"),
                "n_calls": len(metas),
                "mean_gen_seconds": round(
                    sum((m["gen_seconds"] or 0) for m in metas) / len(metas), 1
                ),
                "mean_out_tok": round(
                    sum((m["out_tok"] or 0) for m in metas) / len(metas), 1
                ),
                "fallback_rate": round(
                    sum(1 for m in metas if m.get("fallback")) / len(metas), 4
                ),
            }

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    print(f"\npass@1 = {summary['pass_at_1']}"
          + (f"  pass@5 = {summary['pass_at_5']}" if "pass_at_5" in summary else ""))
    print(f"寫入 {args.out}")


if __name__ == "__main__":
    main()
