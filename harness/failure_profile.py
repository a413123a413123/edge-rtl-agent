#!/usr/bin/env python3
# =========================================================================
# failure_profile.py — 失敗模式剖析:閉環修復該優先攻什麼
# =========================================================================
# 把評測結果的分類碼統計成分佈,並區分三種題目狀態:
#   全通過 / 部分通過(抽樣運氣)/ 五樣本全滅(能力缺口)
# 這張表決定修復迴圈的優先序:語法類錯誤靠 lint 回饋就能修,
# 行為類錯誤(R)才需要模擬回饋 + log-grounded 診斷。
import argparse
import collections
import json

NAMES = {
    ".": "通過",
    "R": "行為不符(模擬 mismatch)",
    "S": "語法錯",
    "C": "其他編譯錯",
    "w": "wire 誤用",
    "p": "埠未繫結",
    "m": "模組名錯(非 TopModule)",
    "n": "無敏感列表",
    "T": "逾時",
    "e": "需顯式轉型",
    "0": "零位寬常數",
    "c": "clk 未繫結",
    "?": "未知",
}
# 修復迴圈的訊號來源分類
SIGNAL = {
    "S": "編譯器", "C": "編譯器", "w": "編譯器", "p": "編譯器",
    "m": "編譯器", "n": "編譯器/lint", "e": "編譯器", "0": "編譯器", "c": "編譯器",
    "R": "模擬器", "T": "模擬器",
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("results", nargs="+")
    args = ap.parse_args()

    for path in args.results:
        with open(path) as f:
            d = json.load(f)
        per = d["per_problem"]
        cnt = collections.Counter()
        for p in per.values():
            cnt.update(p["codes"])
        total = sum(cnt.values())
        label = (d.get("generation") or {}).get("model", path)

        print(f"\n{'='*72}\n{label}   pass@1={d['pass_at_1']:.3f}"
              + (f"  pass@5={d['pass_at_5']:.3f}" if "pass_at_5" in d else "")
              + f"   ({total} 樣本)\n{'='*72}")
        print("分類碼分佈:")
        for code, n in cnt.most_common():
            src = SIGNAL.get(code, "—" if code == "." else "?")
            print(f"  {code}  {n:3d}  {n/total*100:5.1f}%  {NAMES.get(code, code):24s} 訊號源:{src}")

        # 修復可及性:非通過樣本中,編譯器可見 vs 只有模擬器可見
        fail_codes = [c for c in cnt.elements() if c != "."]
        compiler_visible = sum(1 for c in fail_codes if SIGNAL.get(c) in ("編譯器", "編譯器/lint"))
        sim_visible = sum(1 for c in fail_codes if SIGNAL.get(c) == "模擬器")
        if fail_codes:
            print(f"\n失敗樣本 {len(fail_codes)}:編譯器可見 {compiler_visible} "
                  f"({compiler_visible/len(fail_codes)*100:.1f}%)、"
                  f"僅模擬器可見 {sim_visible} ({sim_visible/len(fail_codes)*100:.1f}%)")

        allpass = [k for k, v in per.items() if v["c"] == v["n"]]
        partial = [k for k, v in per.items() if 0 < v["c"] < v["n"]]
        never = [k for k, v in per.items() if v["c"] == 0]
        print(f"\n題目狀態:全通過 {len(allpass)} / 部分通過 {len(partial)} / 全滅 {len(never)}"
              f"  (共 {len(per)} 題)")
        print(f"  部分通過(抽樣運氣,閉環最容易搶救):{', '.join(partial) if partial else '無'}")
        print(f"  全滅(能力缺口):")
        for k in never:
            print(f"    {per[k]['codes']}  {k}")


if __name__ == "__main__":
    main()
