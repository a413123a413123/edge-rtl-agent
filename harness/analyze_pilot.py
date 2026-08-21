#!/usr/bin/env python3
# =========================================================================
# analyze_pilot.py — pilot 閘門分析:量化階梯的差距是否存在
# =========================================================================
# 決策依據(見總體規劃 §3.1):
#   FP16 vs Q4 的 pass@1 差距 >= 5pp → 主軸 A(量化邊界 × 閉環補償)
#   差距 < 5pp                       → 主軸 B(Q3/Q2 極端量化 + 解集位移)
#
# 統計:題目層級 bootstrap CI(26 題重抽,不把 130 樣本當獨立)+
#       配對 permutation test(同一組題目,天然配對)。
# 另輸出解集位移(Jaccard):即使聚合分數持平,量化是否改變「哪些題會錯」
# ——這是主軸 B 的核心量測,借 arXiv 2606.27205 的 JCR 概念。
#
# 用法:
#   python3 harness/analyze_pilot.py results/pilot_3b_fp16.json \
#       results/pilot_3b_q8.json results/pilot_3b_q4.json --out results/pilot_report.json
import argparse
import json
import random
import statistics


def load(path):
    with open(path) as f:
        d = json.load(f)
    label = (d.get("generation") or {}).get("model") or path
    per = {k: v["c"] / v["n"] for k, v in d["per_problem"].items()}
    solved = {k for k, v in d["per_problem"].items() if v["c"] > 0}
    return {"path": path, "label": label, "per": per, "solved": solved, "raw": d}


def mean(xs):
    return sum(xs) / len(xs) if xs else 0.0


def bootstrap_ci(values, n_boot=10000, alpha=0.05, seed=42):
    """題目層級 bootstrap:對題目重抽,捕捉題間變異(題目難度差異 >> 題內抽樣變異)。"""
    rng = random.Random(seed)
    n = len(values)
    means = []
    for _ in range(n_boot):
        means.append(mean([values[rng.randrange(n)] for _ in range(n)]))
    means.sort()
    lo = means[int(n_boot * alpha / 2)]
    hi = means[int(n_boot * (1 - alpha / 2))]
    return lo, hi


def paired_permutation(a, b, n_perm=10000, seed=42):
    """配對 permutation:對每題的差值隨機翻轉符號,無分布假設。"""
    rng = random.Random(seed)
    diffs = [x - y for x, y in zip(a, b)]
    obs = mean(diffs)
    count = 0
    for _ in range(n_perm):
        perm = [d if rng.random() < 0.5 else -d for d in diffs]
        if abs(mean(perm)) >= abs(obs):
            count += 1
    return obs, (count + 1) / (n_perm + 1)


def jaccard(s1, s2):
    if not (s1 | s2):
        return 1.0
    return len(s1 & s2) / len(s1 | s2)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("results", nargs="+", help="由高精度到低精度排序,如 fp16 q8 q4")
    ap.add_argument("--out", required=True)
    ap.add_argument("--threshold-pp", type=float, default=5.0)
    args = ap.parse_args()

    runs = [load(p) for p in args.results]
    probs = sorted(set.intersection(*[set(r["per"].keys()) for r in runs]))
    print(f"共同題目:{len(probs)} 題\n")

    report = {"n_problems": len(probs), "threshold_pp": args.threshold_pp, "arms": [], "comparisons": []}

    for r in runs:
        vals = [r["per"][p] for p in probs]
        lo, hi = bootstrap_ci(vals)
        arm = {
            "label": r["label"],
            "path": r["path"],
            "pass_at_1": round(mean(vals), 4),
            "ci95": [round(lo, 4), round(hi, 4)],
            "n_solved_any": len(r["solved"] & set(probs)),
        }
        report["arms"].append(arm)
        print(f"{arm['label']:45s} pass@1={arm['pass_at_1']:.3f} "
              f"CI95=[{lo:.3f},{hi:.3f}] solved_any={arm['n_solved_any']}/{len(probs)}")

    print()
    # 兩兩比較(以第一個 arm 為基準,通常是 FP16)
    base = runs[0]
    for r in runs[1:]:
        a = [base["per"][p] for p in probs]
        b = [r["per"][p] for p in probs]
        obs, pval = paired_permutation(a, b)
        diff_pp = obs * 100
        dlo, dhi = bootstrap_ci([x - y for x, y in zip(a, b)])
        js = jaccard(base["solved"] & set(probs), r["solved"] & set(probs))
        only_base = sorted((base["solved"] - r["solved"]) & set(probs))
        only_other = sorted((r["solved"] - base["solved"]) & set(probs))
        comp = {
            "baseline": base["label"],
            "compare": r["label"],
            "diff_pp": round(diff_pp, 2),
            "diff_ci95_pp": [round(dlo * 100, 2), round(dhi * 100, 2)],
            "p_value": round(pval, 4),
            "solved_set_jaccard": round(js, 4),
            "solved_only_by_baseline": only_base,
            "solved_only_by_compare": only_other,
        }
        report["comparisons"].append(comp)
        print(f"{base['label']} vs {r['label']}:")
        print(f"  差距 = {diff_pp:+.2f} pp  CI95=[{dlo*100:+.2f},{dhi*100:+.2f}]  p={pval:.4f}")
        print(f"  解集 Jaccard = {js:.3f}  (只有基準解出 {len(only_base)} 題 / 只有對照解出 {len(only_other)} 題)")

    # 閘門判定:以最低精度 arm 對基準的差距為準
    final = report["comparisons"][-1] if report["comparisons"] else None
    if final:
        gap = abs(final["diff_pp"])
        ci_hi = max(abs(x) for x in final["diff_ci95_pp"])
        if gap >= args.threshold_pp:
            verdict = "MAIN_TRACK_A"
            reason = (f"{final['baseline']} 與 {final['compare']} 差距 {gap:.2f}pp "
                      f"≥ {args.threshold_pp}pp 門檻 → 量化損失存在,走主軸 A(量化邊界 × 閉環補償)")
        elif ci_hi < args.threshold_pp:
            verdict = "MAIN_TRACK_B"
            reason = (f"差距 {gap:.2f}pp 且 CI 上界 {ci_hi:.2f}pp < {args.threshold_pp}pp "
                      f"→ 等效性成立,Q4 無實質損失,轉主軸 B(Q3/Q2 極端量化 + 解集位移)")
        else:
            verdict = "UNDERPOWERED"
            reason = (f"差距 {gap:.2f}pp 但 CI 跨越門檻(上界 {ci_hi:.2f}pp)"
                      f"→ dev 26 題檢定力不足以判定,需擴大 n 或加測 Q3/Q2 探邊界")
        report["verdict"] = verdict
        report["verdict_reason"] = reason
        report["solved_set_shift_note"] = (
            f"解集 Jaccard {final['solved_set_jaccard']:.3f}:即使聚合分數接近,"
            f"量化仍改變了哪些題會解——這是主軸 B 的核心量測(參 arXiv 2606.27205 JCR)"
        )
        print(f"\n{'='*70}\n閘門判定:{verdict}\n{reason}\n{report['solved_set_shift_note']}\n{'='*70}")

    with open(args.out, "w") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    print(f"\n寫入 {args.out}")


if __name__ == "__main__":
    main()
