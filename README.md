# edge-rtl-agent

**消費級 6GB GPU 上的地端 RTL 生成閉環 agent 研究**
Local-first closed-loop RTL generation on a consumer 6GB GPU — measuring how far small local LLMs can go on hardware design tasks when wrapped in verification-grounded repair loops, on a fully open toolchain (Icarus Verilog / Yosys / OpenSTA / LibreLane / sky130).

> 研究命題:NVIDIA HORIZON(arXiv 2606.28279)已用 GPT-5.3 把「雲端旗艦 + 閉環」在標準 RTL benchmark 打到 100%,但半導體業的現實是 **RTL/IP 不能上雲**。本專案量測光譜另一端:量化後的小模型(3B/7B)在單張消費級 GPU 上,閉環修復能追回多少差距——以及在哪裡撞牆。

## 為什麼是地端(Why local-first)

- **IP 機密**:design house 不會把 RTL 送進雲端 API,地端是剛需不是偏好
- **可重現**:全開源工具鏈 + 固定模型量化版本,任何人可在同級硬體複現
- **邊界研究**:6GB VRAM 是消費級的真實約束——7B Q4 已溢出(見下方實測),量化損耗 × 閉環補償的交互是未被系統研究的空白

## 硬體邊界實測(RTX 3050 6GB,Ollama,context 4096)

| 模型 | 佔用 | 處理器分配 | Prompt 吞吐 | 生成速度 |
|---|---|---|---|---|
| qwen2.5-coder:3b | 2.2GB | 100% GPU | 231 tok/s | 39.8 tok/s |
| qwen2.5-coder:7b | 5.2GB | 82% GPU / 18% CPU | 4.7 tok/s | 7.6 tok/s |

7B 溢出到 CPU 後 prompt 吞吐掉 50 倍——閉環 agent 每輪都要餵長上下文(錯誤 log、程式碼),故本專案採「3B 主力、7B 品質對照」的 escalation 策略(cf. HDLFORGE, arXiv 2603.04646)。

## 倉庫結構

```
designs/uart_demo/   手動走通的第一個設計:8N1 UART(TX/RX),iverilog 模擬 PASS,
                     LibreLane 80 階段流程 DRC/LVS/Antenna 全零(sky130,10,625 µm²)
harness/             VerilogEval v2 spec-to-rtl 評測管線
  generate.ps1         生成側(Windows,localhost 直達 Ollama)
  evaluate.py          評測側(WSL,容器內 iverilog,判定邏輯復刻官方 sv-iv-analyze)
results/             completions 與 baseline JSON(證據落地,全部入庫)
env/setup.sh         從零重現環境的完整腳本
docs/                藍圖與設計文件
```

## 環境重現(Windows 11 + WSL2)

前置:WSL2 + Ubuntu、NVIDIA 驅動(WSL CUDA)、[Ollama for Windows](https://ollama.com)。

```bash
# WSL 內
bash env/setup.sh          # docker-ce、Python venv、LibreLane、sky130 PDK、verilog-eval
# Windows 側
ollama pull qwen2.5-coder:3b
ollama pull qwen2.5-coder:7b
```

### 已知環境陷阱(踩過的坑,依日期)

1. **WSL2 NAT 模式下 Ollama 不可從 WSL 直達**——Windows Ollama 綁 127.0.0.1,`localhost`、gateway IP、resolv.conf nameserver 從 WSL 一律連不到。本倉庫的解法是生成/評測分側執行(`generate.ps1` 在 Windows、`evaluate.py` 在 WSL),以檔案交接,**不動防火牆、不改 Ollama 綁定**。
2. **非互動 shell 跑 `librelane --dockerized` 會因 TTY 掛掉**,且 exit code 可能被管線洗成 0。解法:`script -qec '...' /dev/null` 包偽終端,並以輸出中的 `Flow complete.` / `Smoke test passed.` 字樣為準,永遠不要只信 exit code。
3. **Ubuntu 26.04 的 venv 需另裝 `python3-venv`**(ensurepip 被拆出),`pip install librelane` 前先 `apt-get install python3-venv`。
4. **iverilog 不吃 UTF-8 BOM**——PowerShell 5.1 的 `Out-File -Encoding utf8` 會寫 BOM,生成側一律用 `[System.IO.File]::WriteAllText`(無 BOM)。
5. **容器版 iverilog(s20250103 開發快照)對 `$dumpvars` 內前向引用的識別符會誤報 `Unable to bind wire/reg`**——症狀是所有題目(含官方黃金解)系統性拿 `p`,首輪評測因此得到假的 0%。診斷方法:把官方參考解餵進同一條管線當對照組;修補:`evaluate.py` 於編譯前剝除 `$dumpfile/$dumpvars` 行(僅關閉波形輸出,判分語義不變),修補後黃金對照 20/20 全過(`results/control_golden.json`)。教訓:**任何評測管線上線前,先讓已知正確的答案跑一遍。**

## Baseline 方法論

- 任務:VerilogEval v2 `spec-to-rtl`(NVlabs/verilog-eval),題目/測試台/參考解均為官方原檔
- Prompt:官方 sv-generate 的 system 訊息與 `[BEGIN]/[DONE]` 指示,0-shot
- 取樣:**每題 1 個樣本、temperature 0**(單樣本 pass@1)。註:官方標準為 n=20、temp 0.8 的 pass@k 估計——本倉庫初期以確定性單樣本換取快速迭代,數字不可與官方報表直接對比,後續會補標準取樣
- 判定:iverilog `-g2012` 編譯(生成碼+官方測試台+官方參考)→ 30s 逾時執行 → 官方 sv-iv-analyze 的字串規則分類(見 `harness/evaluate.py` 檔頭)

## 首批 Baseline 結果(2026-08-21,前 20 題子集)

| 組別 | pass@1 | 失敗碼 | 解讀 |
|---|---|---|---|
| 黃金對照(官方參考解) | 20/20 | `....................` | harness 有效性驗證 |
| qwen2.5-coder:3b,0-shot | 8/20 (40%) | `wwnS.S..C..R..CRwSS.` | 失敗主力是**宣告/語法類**(w/S/C) |
| qwen2.5-coder:7b,0-shot | 6/10 (60%) | `....SS.S.S` | 失敗全為語法類 |
| qwen2.5-coder:3b,**1-shot** | **15/20 (75%)** | `...R.R.....R...C..R.` | **ICL 幾乎消滅宣告/語法錯**,殘餘失敗為行為不符(R) |

初步觀察(單樣本 temp 0,樣本數小,僅供方向判讀):

1. 官方 1-shot 範例前綴讓 3B 從 40% 跳到 75%——小模型的主要死因(介面宣告慣例)是**格式知識問題**,一個範例就能大幅治癒;此結果與 VerilogEval v2 論文「ICL 對小模型增益最大」的結論一致。
2. ICL 之後殘存的失敗集中在 **R(行為不符)**——這正是需要「模擬回饋閉環修復」才能解的錯誤類別,亦即本專案 agent 主線要攻的靶。
3. 對照文獻:RTL-Coder 6.7B 在 spec-to-rtl 為 34%、GPT-4o 約 63%(官方 n=20 取樣,不能直接對比,僅作量級參照)。

## 授權

Apache License 2.0(與 LibreLane / OpenLane 生態一致)。
