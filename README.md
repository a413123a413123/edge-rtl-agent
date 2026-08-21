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

## Baseline 方法論

- 任務:VerilogEval v2 `spec-to-rtl`(NVlabs/verilog-eval),題目/測試台/參考解均為官方原檔
- Prompt:官方 sv-generate 的 system 訊息與 `[BEGIN]/[DONE]` 指示,0-shot
- 取樣:**每題 1 個樣本、temperature 0**(單樣本 pass@1)。註:官方標準為 n=20、temp 0.8 的 pass@k 估計——本倉庫初期以確定性單樣本換取快速迭代,數字不可與官方報表直接對比,後續會補標準取樣
- 判定:iverilog `-g2012` 編譯(生成碼+官方測試台+官方參考)→ 30s 逾時執行 → 官方 sv-iv-analyze 的字串規則分類(見 `harness/evaluate.py` 檔頭)

## 授權

Apache License 2.0(與 LibreLane / OpenLane 生態一致)。
