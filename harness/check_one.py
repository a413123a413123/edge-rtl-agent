#!/usr/bin/env python3
# =========================================================================
# check_one.py — 單題評測(修復迴圈的「裁判」端)
# =========================================================================
# 與 evaluate.py 共用同一套編譯/執行/分類邏輯(直接 import,單一真相來源),
# 額外輸出「錯誤 log 摘要」供修復提示使用。
#
# 洩漏防線(2026-08-21 稽核輪一 V2 發現後強化):
#  1. 路徑消毒:iverilog 錯誤行會帶出完整檔案路徑,其中含 VerilogEval 刻意
#     匿名化的 HDLBits 原題名(如 Prob144_conwaylife)——題名是模型訓練語料
#     的記憶檢索鍵。sample/testbench/reference 路徑一律替換為中性檔名,
#     並以 Prob\d+ 掃除任何殘留題名。
#  2. Hint 行剔除:官方測試台的 Hint 行可能並排印出 dut 與 ref 值(黃金行為),
#     一律不進摘要。
#  3. fallback 不再傾印原始 log:無關鍵字命中時回傳固定訊息。
# 行為錯誤(R)因此僅回饋「Mismatches: N in M samples」總數。
# =========================================================================
import argparse
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from evaluate import run_one, classify  # noqa: E402


def sanitize(line):
    """清除可能構成記憶檢索鍵的路徑與題名。"""
    line = re.sub(r"\S*sample01\.sv", "sample.sv", line)
    line = re.sub(r"\S*_test\.sv", "testbench.sv", line)
    line = re.sub(r"\S*test_patched\.sv", "testbench.sv", line)
    line = re.sub(r"\S*_ref\.sv", "reference.sv", line)
    line = re.sub(r"Prob\d+\w*", "", line)
    return line


def make_excerpt(log, limit=1500):
    """抽錯誤優先的 log 摘要:error/Mismatches/TIMEOUT/warning 行 + 各自下一行。

    保留下一行是煙霧測試的教訓:iverilog 的關鍵說明常在續行
    (如「'zero' is declared here as a wire.」不含 error 字樣)。
    """
    lines = log.splitlines()
    keep = set()
    for i, l in enumerate(lines):
        low = l.lower()
        if ("error" in low or "Mismatches" in l
                or "TIMEOUT" in l or "warning" in low):
            keep.add(i)
            if i + 1 < len(lines):
                keep.add(i + 1)
    if not keep:
        return "simulation terminated without diagnostic output"
    out = []
    for i in sorted(keep):
        l = lines[i]
        if l.lstrip().startswith("Hint:"):
            continue
        out.append(sanitize(l))
    if not out:
        return "tool reported issues; no shareable diagnostic lines"
    return "\n".join(out)[:limit]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sample", required=True)
    ap.add_argument("--test", required=True)
    ap.add_argument("--ref", required=True)
    args = ap.parse_args()

    log = run_one(args.sample, args.test, args.ref)
    code, mism = classify(log, sample_path=args.sample)
    print(json.dumps({
        "code": code,
        "mismatches": mism,
        "log_excerpt": make_excerpt(log),
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
