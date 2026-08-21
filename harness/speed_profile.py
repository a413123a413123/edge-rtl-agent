#!/usr/bin/env python3
# =========================================================================
# speed_profile.py — 量化階梯的吞吐剖析(6GB VRAM 邊界的系統證據)
# =========================================================================
# 從各 run 的 metadata.jsonl 算出生成吞吐,並以最快者為基準算相對倍率。
# 這張表是「等壁鐘預算比較」(總體規劃 H4')與 ESL 系統短文的核心數據:
# 在固定時間內,低精度模型能跑多少倍的樣本數。
import argparse
import json
import os

# 各量化等級的權重檔大小(GB,取自 ollama list),用於對照 6GB VRAM 邊界
WEIGHTS_GB = {
    "qwen2.5-coder:3b": 1.9,
    "qwen2.5-coder:3b-instruct-q8_0": 3.3,
    "qwen2.5-coder:3b-instruct-fp16": 6.2,
    "qwen2.5-coder:7b": 4.7,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dirs", nargs="+", help="completions_* 目錄")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    rows = []
    for d in args.dirs:
        path = os.path.join(d, "metadata.jsonl")
        if not os.path.exists(path):
            print(f"跳過(無 metadata):{d}")
            continue
        with open(path, encoding="utf-8-sig") as f:
            metas = [json.loads(l) for l in f if l.strip()]
        if not metas:
            continue
        model = metas[0]["model"]
        tot_s = sum(m["gen_seconds"] for m in metas)
        tot_out = sum(m["out_tok"] for m in metas)
        tot_prompt = sum(m.get("prompt_tok") or 0 for m in metas)
        rows.append({
            "model": model,
            "weights_gb": WEIGHTS_GB.get(model),
            "n_samples": len(metas),
            "mean_gen_seconds": round(tot_s / len(metas), 1),
            "mean_out_tok": round(tot_out / len(metas), 1),
            "mean_prompt_tok": round(tot_prompt / len(metas), 1),
            # 聚合吞吐:總輸出 token / 總牆鐘秒(含 prefill,即使用者實際感受的速度)
            "gen_tok_per_s": round(tot_out / tot_s, 2) if tot_s else 0.0,
            "samples_per_hour": round(3600 / (tot_s / len(metas)), 1) if tot_s else 0.0,
        })

    if not rows:
        print("無資料")
        return
    fastest = max(r["gen_tok_per_s"] for r in rows)
    for r in rows:
        r["relative_speed"] = round(r["gen_tok_per_s"] / fastest, 3)

    hdr = f"{'模型':38s} {'權重GB':>6s} {'樣本':>4s} {'秒/樣本':>7s} {'tok/s':>7s} {'樣本/時':>7s} {'相對速度':>7s}"
    print(hdr)
    print("-" * len(hdr))
    for r in sorted(rows, key=lambda x: -(x["weights_gb"] or 0)):
        print(f"{r['model']:38s} {str(r['weights_gb'] or '?'):>6s} {r['n_samples']:>4d} "
              f"{r['mean_gen_seconds']:>7.1f} {r['gen_tok_per_s']:>7.2f} "
              f"{r['samples_per_hour']:>7.1f} {r['relative_speed']:>7.3f}x")

    print("\n等壁鐘意涵:同樣一小時內,各配置可產出的樣本數見「樣本/時」欄。")
    print("6GB VRAM 邊界:權重 > 約 5.5GB 即大量溢出至 CPU,吞吐斷崖式下降。")

    if args.out:
        with open(args.out, "w") as f:
            json.dump({"rows": rows, "note": "gen_tok_per_s 為含 prefill 的聚合吞吐"},
                      f, indent=2, ensure_ascii=False)
        print(f"\n寫入 {args.out}")


if __name__ == "__main__":
    main()
