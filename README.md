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

> 量測來源:2026-08-21 以 `ollama run --verbose` 與 `ollama ps` 手動量測(session 紀錄,原始輸出未落地成檔——補正式量測腳本列於路線圖);`results/speed_profile.json` 為另一組聚合吞吐量測,判準不同、不可與本表互換。

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

> ⚠️ 子集揭露(稽核輪一 V3 發現):**按檔名排序的前 20 題全為組合邏輯題**(0 題含 clk/posedge),而全集 156 題中約 47%(73/156,以參考解含 posedge/negedge 判定)為時序題。本節與下節所有觀察僅適用組合邏輯類,不可外推;分層抽樣與全集實驗列於路線圖。

| 組別 | pass@1 | 失敗碼 | 解讀 |
|---|---|---|---|
| 黃金對照(官方參考解) | 20/20 | `....................` | harness 有效性驗證 |
| qwen2.5-coder:3b,0-shot | 8/20 (40%) | `wwnS.S..C..R..CRwSS.` | 失敗主力是**宣告/語法類**(w/S/C) |
| qwen2.5-coder:7b,0-shot | 6/10 (60%) | `....SS.S.S` | 失敗全為語法類 |
| qwen2.5-coder:3b,**1-shot** | **15/20 (75%)** | `...R.R.....R...C..R.` | **ICL 幾乎消滅宣告/語法錯**,殘餘失敗為行為不符(R) |

初步觀察(單樣本 temp 0,樣本數小,僅供方向判讀):

1. 官方 1-shot 範例前綴讓 3B 從 40% 跳到 75%——小模型的主要死因(介面宣告慣例)是**格式知識問題**,一個範例即可在單次量測下大幅改善;此結果與 VerilogEval v2 論文「ICL 對小模型增益最大」的結論一致。
2. ICL 之後殘存的失敗集中在 **R(行為不符)**——這正是需要「模擬回饋閉環修復」才能解的錯誤類別,亦即本專案 agent 主線要攻的靶。
3. 對照文獻:RTL-Coder 6.7B 在 spec-to-rtl 為 34%、GPT-4o 約 63%——注意文獻數字來自**全 156 題 + 官方 n=20 取樣**,本表為**最易 20 題組合邏輯子集 + 單樣本**,差兩個軸,嚴禁直接對比,僅作量級感。
4. 7B 基線 n=10(與 3B 的 n=20 分母不同);同前 10 題對比為 7B 6/10 vs 3B 4/10。

## 修復迴圈三臂消融(2026-08-22,同前 20 題組合邏輯子集,seed=42)

**設計**:生成失敗後最多修 3 輪(修復輪 temp 0.4),三臂只差修復提示內容——
`full`(規格+舊碼+工具錯誤摘要)/ `code-only`(規格+舊碼)/ `resample`(僅規格)。
洩漏防線:錯誤摘要經路徑消毒(無題名、無路徑);R 類的行為回饋僅 mismatch 總數(修復提示另含前次編譯的警告行,均僅涉候選碼自身,無黃金解資訊)。
全軌跡(每輪 prompt/程式碼/判定)落地於 `results/repair_*/`,最終樣本經 `evaluate.py` 獨立重評,與軌跡內判定 100% 一致。
命名註記:`results/repair_3b_1shot/`(下稱 legacy)為三臂協定定稿前的完整回饋試跑(harness 較早版、無 seed 控制),`repair_3b_1shot_blind/` 為預試性盲重試(10 題);兩者保留供比對、不入正表。擷取註記:`[BEGIN]/[DONE]` 標記不齊時退用 ``` 圍欄擷取(每臂 2–3/20 樣本,計數見 `repair_analysis.json`)——此為對官方擷取協定的已知偏離。

| 臂(3B,1-shot) | attempt0 | 最終 | 淨增 | 失敗轉移 |
|---|---|---|---|---|
| full | 16/20 | **17/20** | **+1** | C→**.**(兩段:C→R→.)、R→R ×3 |
| code-only | 16/20 | 16/20 | 0 | C→C(卡死)、R→R ×3 |
| resample | 16/20 | 16/20 | 0 | **C→S、R→S(退化)**、R→R ×2 |
| 7B full(n=10) | 9/10 | 9/10 | 0 | R→S(退化) |

**觀察(單次執行,效應量小,定性解讀)**:

1. **三臂 attempt0 完全一致(16/20)**——同 seed 同條件,消融的可比性成立。
2. **log 回饋的作用有單例最小對照演示(存在性,非穩定因果)**:Prob016(FSM 題,C 類編譯錯)在 full 臂 C→R→. 兩段修復成功;code-only 臂同題同 seed 四輪全卡 C,兩臂輸入唯一差異是錯誤訊息摘要。**反方事實並列**:legacy 完整回饋執行在同題亦四輪卡 C——此對照演示的是「回饋在該次執行中促成修復」,不能推論回饋⇒修復的穩定效應。
3. **無回饋的重試在本次執行中出現退化**:resample 臂把 C 改成 S、R 改成 S(盲改把接近正確的程式碼改壞);同執行中回饋臂未出現退化,預試 blind 輪亦見同型退化(R→w)。
4. **R 類(行為錯)是全臂共同的天花板**:表列四臂共 10 個 R-初始案例(含 7B)全數未修復;另 legacy 執行曾修復其 3 例中的 1 例(Prob012)。弱回饋(mismatch 總數)不足以定位行為錯——這指向時序行為回饋(cf. SeqFeed, arXiv 2608.16934)為下一個機制。
5. 成本:full 臂 20 題共 12,686 tokens(含 prompt 與生成)/ 495 秒(3B,含修復輪)。

**限制(誠實聲明)**:單次執行(seed 42)、效應量 +1 題屬 anecdotal;修復輪的執行間變異已在 legacy vs v2 的不同修復目標(Prob012 vs Prob016)中實際顯現(注意兩輪 harness 版本亦不同,不能單獨歸因於溫度隨機性)。三臂 attempt0(16/20)與 baseline 1-shot(15/20)差一題(Prob004)——兩者為獨立執行,Ollama 的 temp 0 生成跨執行不保證逐位元重現(修復臂帶 seed=42,baseline 當時未設 seed)。結論等級:「機制演示」而非「統計效應」。重複實驗(≥5 seeds)、時序題分層、全集規模列於路線圖。

## 全集 156 題結果(2026-08-22,3B 1-shot,單樣本 temp 0,seed 42)

**先做的效度工作**:全 156 題黃金對照(官方參考解跑本管線)= **152/156**。4 題連黃金解都無法通過,經逐題解剖確認為 benchmark 自身缺陷,列入除外清單(證據見 `results/benchmark_exclusions.json`):

- 3 題(lfsr32、count_clock、fancytimer)的測試台看門狗於**模擬時間** 1e6 ps 必然觸發並印出 TIMEOUT,官方分類器對 TIMEOUT 立即判 T——即黃金解在官方 iverilog 協定下永遠不通過,與機器速度無關(手動重跑 0.9–1.3s 完成且 Mismatches: 0)。
- Prob099_m2014_q6c:官方參考解埠為 (Y1, Y3),測試台卻連接 .Y2/.Y4——黃金解自身編譯失敗,任何符合 ref 介面的實作皆不可能通過。

有效可評分集 = **152 題**。以下數字均以此為分母、分層依「參考解含 posedge/negedge」:

| 層 | n | pass@1 | 失敗碼分布 |
|---|---|---|---|
| 組合邏輯 | 82 | **41.5%**(34) | R×42、C×3、S×2、p×1 |
| 時序 | 70 | **8.6%**(6) | R×27、**r×27**、C×6、S×3、T×1 |
| 全集 | 152 | **26.3%**(40) | |

**觀察(單樣本,方向性解讀)**:

1. **前 20 題子集(75%)嚴重不具代表性**——完整組合邏輯層僅 41.5%,時序層近乎崩潰(8.6%)。本 README 較早章節的子集數字仍然為真,但其外推已由本節取代。
2. **時序 runtime 行為錯中恰半數為 `r` 類**(reset 處理類錯誤——官方判準為原始碼含邊緣觸發 reset 型態,同步/非同步誤用皆屬之;27 r vs 27 R,佔全部時序失敗 27/64 ≈ 42%)——此類別由稽核輪一補上的官方分類器修正才得以顯形,否則會全部誤併入 R。撰寫本節時曾推測 r 類因語法特徵明確而較易修復——**此假說已被下方時序探針駁回(0/12)**,保留原推測與駁回紀錄以示修正過程。
3. 內部一致性:本輪前 20 題 = 16/20,與三臂消融的 attempt0(同 seed)逐題一致。
4. 對照文獻量級:RTL-Coder 6.7B 全集 34%(官方 n=20 取樣)vs 本輪 3B 全集 26.3%(n=1)——參數量減半、取樣少 20 倍下的合理量級,不作優劣宣稱。

## 時序域修復探針(2026-08-22,前 30 道時序題,full 臂,最多修 2 輪,seed 42)

選題規則:時序題(參考解含 posedge/negedge、排除 benchmark 缺陷題)按檔名排序取前 30——確定性、可重現;時序題全清單(70 題)存 `results/sequential_problems.txt`,本探針取其前 30。

| 指標 | 數值 |
|---|---|
| attempt0 | 6/30 |
| 最終 | 7/30(淨增 +1,一例 R→. 於第 1 修復輪) |
| 失敗轉移 | **r→r ×12(全數未修復)**、R→R ×7、C→C ×2、C→R ×1、T→R ×1 |
| 成本 | 39,581 tokens(含 prompt 與生成)/ 510 秒 |
| 標記 fallback | 15 次(組合臂僅 2–3;時序修復提示更常誘發非標記回覆,擷取後備接住) |

**觀察(單次執行,定性)**:

1. **修復效率在時序域大幅走低**:組合域 4 個失敗修復 1;時序域 24 個失敗僅修復 1,其中 r 類 0/12。兩比率在此樣本數下不可統計區分(Fisher 雙尾 p≈0.27),對比僅為描述性;逐題全滅(r→r 12/12、R→R 7/8)是更實在的證據。
2. **r 類假說被駁回**:曾推測 reset 處理錯因語法特徵明確而較易修——實測 0/12。可驗證的機制陳述是:**回饋通道未傳遞分類器的診斷**——r 與 R 在工具回饋中同貌(僅 mismatch 計數),而區分兩者所需的資訊(規格+舊碼)其實都在模型的提示裡,分類器正是只用這些就判得出 r;0/12 顯示 3B 在此回饋下自行推不出「reset 處理錯誤」這一步。下一機制實驗因此被指定:回饋通道需傳遞「行為錯誤的種類」而不只是「錯了幾次」(波形級/規則級回饋,cf. SeqFeed)。
3. 兩例「部分推進」(C→R、T→R)顯示迴圈在時序域仍有微弱定向性,但不足以到達通過;注意「編譯通過不必然更接近功能正確」——resample 臂曾出現 R→S 反向,失敗型態之間並無單調序。
4. 獨立重評(`repair_3b_1shot_seq30_final_eval.json`)與軌跡內判定一致:7/30。
5. **跨執行差異揭露**:本探針 attempt0 與全集 baseline 在同 30 題上差一題(Prob047_dff8ar:全集判 C、本輪通過)——同為已揭露的 Ollama temp-0 跨執行不重現;故本節 attempt0 的 6/30 與全集時序層的 6/70 並非同一組題目,不可互相換算。

## 授權

Apache License 2.0(與 LibreLane / OpenLane 生態一致)。
