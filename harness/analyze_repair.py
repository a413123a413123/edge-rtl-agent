#!/usr/bin/env python3
# =========================================================================
# analyze_repair.py — 修復迴圈實驗的彙總分析(稽核輪一 V3 指定的報告層)
# =========================================================================
# 從各臂的 trajectory.jsonl 離線計算:
#   (a) attempt0 通過率 vs 最終通過率(迴圈淨貢獻)
#   (b) 各輪修復成功數分布(第 k 輪修好幾題)
#   (c) 初始失敗碼 × 最終結果的轉移統計(R 類 vs 宣告/語法類的可修性)
#   (d) 每臂累計 token 與秒數(與 pass@k 重抽成本可正規化對比)
#   (e) marker_fallback 次數(擷取失敗不可誤計為能力失敗)
# 用法:
#   python3 harness/analyze_repair.py --arms results/repair_3b_1shot_v2 \
#       results/repair_3b_1shot_codeonly results/repair_3b_1shot_resample \
#       --out results/repair_analysis.json
# =========================================================================
import argparse
import json
import os
from collections import defaultdict
from datetime import datetime, timezone


def load_arm(arm_dir):
    path = os.path.join(arm_dir, "trajectory.jsonl")
    records = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line:
                records.append(json.loads(line))
    # 同題重跑時以最後一筆為準(依 JSONL 順序)
    dedup = {}
    for r in records:
        dedup[r["problem"]] = r
    return list(dedup.values())


def analyze(records):
    n = len(records)
    a0_pass = sum(1 for r in records if r["trajectory"][0] == ".")
    final_pass = sum(1 for r in records if r["final"] == ".")
    fixed_at = defaultdict(int)      # 第 k 輪(attempt k)修好題數
    transition = defaultdict(int)    # 初始碼 -> 最終碼
    tok_total = 0
    sec_total = 0.0
    fallback_n = 0
    for r in records:
        traj = r["trajectory"]
        init, final = traj[0], r["final"]
        if init != ".":
            transition[f"{init}->{final}"] += 1
            if final == ".":
                fixed_at[len(traj) - 1] += 1
        for a in r["attempts"]:
            tok_total += (a.get("eval_count") or 0) + (a.get("prompt_eval") or 0)
            sec_total += a.get("gen_seconds") or 0
            if a.get("marker_fallback"):
                fallback_n += 1
    meta = records[0] if records else {}
    return {
        "mode": meta.get("mode", "unknown"),
        "model": meta.get("model", "?"),
        "shots": meta.get("shots"),
        "seed": meta.get("seed"),
        "n_problems": n,
        "attempt0_pass": a0_pass,
        "final_pass": final_pass,
        "loop_net_gain": final_pass - a0_pass,
        "fixed_at_attempt": dict(sorted(fixed_at.items())),
        "transitions": dict(sorted(transition.items())),
        "total_tokens": tok_total,
        "total_gen_seconds": round(sec_total, 1),
        "marker_fallback_count": fallback_n,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arms", nargs="+", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    report = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "arms": {},
    }
    for arm in args.arms:
        name = os.path.basename(arm.rstrip("/"))
        report["arms"][name] = analyze(load_arm(arm))

    with open(args.out, "w") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)

    # 終端摘要表
    print(f"{'臂':32s} {'n':>3s} {'a0過':>5s} {'最終':>5s} {'淨增':>5s} {'tokens':>8s} {'秒':>7s}")
    for name, a in report["arms"].items():
        print(f"{name:32s} {a['n_problems']:3d} {a['attempt0_pass']:5d} "
              f"{a['final_pass']:5d} {a['loop_net_gain']:+5d} "
              f"{a['total_tokens']:8d} {a['total_gen_seconds']:7.0f}")
        print(f"  轉移: {a['transitions']}  各輪修復: {a['fixed_at_attempt']}  fallback: {a['marker_fallback_count']}")
    print(f"\n寫入 {args.out}")


if __name__ == "__main__":
    main()
