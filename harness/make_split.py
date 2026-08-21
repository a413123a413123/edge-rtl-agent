#!/usr/bin/env python3
# =========================================================================
# make_split.py — 產生固定 seed 的 dev/test 切分
# =========================================================================
# 26 題 dev:pilot 閘門、溫度預掃、prompt 調整專用
# 130 題 test:只做假設檢定,防止在測試集上調參(見總體規劃 §3)
# seed 固定 42,切分結果 commit 進 repo,一次產生永不再動。
import json
import os
import random

dataset = os.path.expanduser("~/verilog-eval/dataset_spec-to-rtl")
probs = sorted(
    p[: -len("_prompt.txt")]
    for p in os.listdir(dataset)
    if p.endswith("_prompt.txt")
)
assert len(probs) == 156, f"預期 156 題,實得 {len(probs)}"

rng = random.Random(42)
dev = sorted(rng.sample(probs, 26))
test = sorted(p for p in probs if p not in set(dev))

out = {"seed": 42, "n_dev": len(dev), "n_test": len(test), "dev": dev, "test": test}
path = os.path.expanduser("~/edge-rtl-agent/data/split_v1.json")
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w") as f:
    json.dump(out, f, indent=2)
print(f"dev={len(dev)} test={len(test)} → {path}")
