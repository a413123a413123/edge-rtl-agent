#!/usr/bin/env python3
# =========================================================================
# stratify.py — 全集結果的分層分析(組合 vs 時序 × 失敗碼分布)
# =========================================================================
# 分層判準:參考解含 posedge/negedge → 時序題(與 README 揭露的 47% 判準一致)
# 除外處理:benchmark_exclusions.json 中的題目「另行報告、不入分母」
# 用法:
#   python3 harness/stratify.py --eval results/baseline_3b_1shot_full156.json \
#       --dataset ~/verilog-eval/dataset_spec-to-rtl \
#       --exclusions results/benchmark_exclusions.json \
#       --out results/baseline_3b_1shot_full156_stratified.json
# =========================================================================
import argparse
import json
import os
from collections import Counter
from datetime import datetime, timezone


def is_sequential(dataset, prob):
    ref = os.path.join(dataset, prob + "_ref.sv")
    try:
        with open(ref) as f:
            src = f.read()
    except OSError:
        return None
    return ("posedge" in src) or ("negedge" in src)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--eval", required=True)
    ap.add_argument("--dataset", required=True)
    ap.add_argument("--exclusions", default=None)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    with open(args.eval) as f:
        ev = json.load(f)
    excluded = set()
    if args.exclusions and os.path.exists(args.exclusions):
        with open(args.exclusions) as f:
            excluded = {e["problem"] for e in json.load(f)["exclusions"]}

    strata = {
        "combinational": {"codes": Counter(), "n": 0, "pass": 0, "problems_failed": []},
        "sequential":    {"codes": Counter(), "n": 0, "pass": 0, "problems_failed": []},
    }
    excluded_report = {}
    for prob, r in ev["per_problem"].items():
        code = r["code"]
        if prob in excluded:
            excluded_report[prob] = code
            continue
        seq = is_sequential(args.dataset, prob)
        key = "sequential" if seq else "combinational"
        s = strata[key]
        s["n"] += 1
        s["codes"][code] += 1
        if code == ".":
            s["pass"] += 1
        else:
            s["problems_failed"].append(f"{prob}:{code}")

    out = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source_eval": args.eval,
        "criterion": "sequential = 參考解含 posedge/negedge",
        "excluded": excluded_report,
        "strata": {},
    }
    total_n = 0
    total_pass = 0
    for key, s in strata.items():
        total_n += s["n"]
        total_pass += s["pass"]
        out["strata"][key] = {
            "n": s["n"],
            "pass": s["pass"],
            "pass_rate": round(s["pass"] / s["n"], 4) if s["n"] else None,
            "code_distribution": dict(s["codes"].most_common()),
            "failed": s["problems_failed"],
        }
    out["overall_scoreable"] = {
        "n": total_n,
        "pass": total_pass,
        "pass_rate": round(total_pass / total_n, 4) if total_n else None,
    }

    with open(args.out, "w") as f:
        json.dump(out, f, indent=2, ensure_ascii=False)

    print(f"{'層':16s} {'n':>4s} {'pass':>5s} {'rate':>7s}  失敗碼分布")
    for key, s in out["strata"].items():
        print(f"{key:16s} {s['n']:4d} {s['pass']:5d} {s['pass_rate']:7.1%}  {s['code_distribution']}")
    o = out["overall_scoreable"]
    print(f"{'overall':16s} {o['n']:4d} {o['pass']:5d} {o['pass_rate']:7.1%}")
    print(f"除外({len(excluded_report)}):{excluded_report}")
    print(f"寫入 {args.out}")


if __name__ == "__main__":
    main()
