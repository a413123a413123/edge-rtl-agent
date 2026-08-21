# IC 設計 Agent — Solo 實作藍圖

> 查證日期:2026-08-10,關鍵事實均經即時網查,非訓練記憶。
> 定位:solo 研究生、邊緣 AI + XAI 背景、目標 = 作品集 + 提案型比賽 + ITMA 2027 開源貢獻獎鋪路。

---

## 一、現況校準:哪些已被做掉、哪些還空著

### 已被做掉的(不要當成你的賣點)

| 東西 | 現況 |
|---|---|
| 自然語言操控 RTL→GDSII 全流程 | **AutoEDA**(MCP 微服務架構)、**MCP4EDA**(MCP 包開源 EDA 工具)、**NL2GDS**——「用 MCP 包 EDA 工具」本身已不新 |
| EDA 流程 agent 學術原型 | **ChatEDA**(TCAD'24/NAACL'25,附 ChatEDA-Bench 50 題)、**ORFS-agent**(工具使用型最佳化) |
| OpenROAD 問答助手 | **ORAssistant**(RAG,開源,整合 OpenROAD/Yosys/OpenSTA/KLayout)——是 PR 目標不是競品 |
| 企業級域內模型 | NVIDIA ChipNeMo、HORIZON(自演化 agent)、AlphaRoute(LLM 進 routing 迴圈)——這個量級不要碰瓷 |
| Spec→RTL benchmark | VerilogEval v2(156 題,GPT-4o pass@1 約 56.5%/63%)、RTLLM v2、2026 新出:ChipVerilog(OpenCores 衍生)、ArchXBench(複雜系統)、PostEDA-Bench(PPA 收斂+DRC 修復)、TuRTLe(統一評測) |

### 基礎設施現況(2026-08 查證)

- **流程工具**:OpenLane 2 已更名 **LibreLane**(v3.0,FOSSi Foundation 維護,Efabless 倒閉後由原開發者接手;Windows 走 WSL2)
- **開源 PDK**:sky130A、IHP sg13g2、GF 180MCU 三套可用
- **真實投片**:**Tiny Tapeout 活著**——TTSKY26c 收件至 **2026-09-07**、TTIHP26b 至 **2026-09-21**,一片 tile 約 **€70**(devkit 約 €300),晶片 2027 年中交付;ChipFoundry(Efabless 後繼者)sky130 shuttle 已確認
- **評測基礎**:VerilogEval v2 自帶 spec-to-RTL 模式、ICL prompt、**細粒度失敗分類**與 Makefile 評測架構——直接站上去,不要自己造輪子

### 還空著的四個縫隙(你的定位)

1. **地端軸**:上述論文清一色用 GPT-4o 級雲端模型。但半導體業的真剛需是 **RTL/IP 不出門**——design house 不可能把 RTL 丟給雲端 API。「本地模型(Qwen2.5-Coder 7B/14B)+ 閉環修復能追回多少雲端差距」沒有人系統性量測過。這正好是你邊緣 AI 的主場。
2. **繁中軸**:已有論文證實 LLM 生成 Verilog 存在多語言偏差,但**繁中 spec→RTL 評測集不存在**。自建 50–100 題、CC 授權開源——延續你「自建繁中評測集」的一貫打法,別人抄不走。
3. **證據紀律軸**:現有 agent 修 code 靠「再試一次」。你的 XAI 背景可以做 **log-grounded 修復**——每個修復決策必須引用工具 log 的具體行,修復報告可稽核。這與 VerilogEval v2 的失敗分類架構天然銜接。
4. **實體矽軸**:所有論文都停在模擬/合成。**沒有學生等級的專案把 agent 設計的 block 真的投片**。Tiny Tapeout €70 就能做到,demo 敘事直接封頂。

---

## 二、三種切入型態(選主幹)

| 型態 | 內容 | 優點 | 缺點 |
|---|---|---|---|
| **A. RTL 生成閉環 agent** | spec → RTL → lint → 模擬 → 修復迴圈 | benchmark 現成(數字最快出來)、無 EDA 深水區、雲端/地端對照實驗乾淨 | 賽道最擁擠,單做 A 難差異化 |
| **B. 全流程編排 agent** | NL → 合成 → STA → PnR → DRC/LVS → PPA 報告 | demo 最炫(GDS 版圖圖)、工程完整度高 | AutoEDA/MCP4EDA 已做過類似;EDA 工具鏈除錯是工時黑洞 |
| **C. 驗證特化 agent** | testbench/assertion 生成、覆蓋率導向 | 學術縫隙最大(驗證占業界 60-70% 工時) | 難度最高、評測基準最不成熟,solo 風險大 |

**推薦:A 為主幹,B 的前半段(合成+STA)作為第二階段的「下游閉環」。** A 和 B 本來就是同一條 pipeline 的前後段——先在 A 站穩數字,再把迴圈往下游延伸到 PPA,C 只挑 testbench 生成一小塊併入 A 的迴圈。不要三個都做,那是排程自殺(教訓來自你維修助手案的對抗檢驗)。

---

## 三、系統架構

```
使用者 spec(英文/繁中)
        │
        ▼
┌─ Agent 主迴圈(LangGraph 狀態機)────────────────────┐
│  規劃 → RTL 生成 → Verilator lint ─┐                │
│    ▲                               ▼                │
│    │                    testbench 生成(cocotb)     │
│    │                               ▼                │
│    │                        Icarus/Verilator 模擬   │
│    │                               ▼                │
│    └── log-grounded 修復 ◄── 失敗解析(引用 log 行) │
│        (上限 N 輪,超限誠實報失敗)                  │
└──────────────────┬──────────────────────────────────┘
                   ▼ 通過
┌─ 下游閉環(Phase 2)────────────────────────────────┐
│  Yosys 合成 → OpenSTA 時序 → LibreLane PnR          │
│  → KLayout DRC / netgen LVS → PPA 報告              │
│  → 參數 DSE(agent 讀報告調 flow 參數)             │
└──────────────────┬──────────────────────────────────┘
                   ▼
      評測 harness(VerilogEval v2 / RTLLM v2 / 自建繁中集)
      指標:pass@1/pass@5、修復輪數分布、失敗分類、
            雲端 vs 地端差距、token 成本/題
```

**工具接口層**:每個 EDA 工具包成 function calling 或 MCP server(verilator、iverilog+cocotb、yosys、OpenSTA、LibreLane、KLayout、netgen)。注意:接口層是工程必需品,但**不是你的賣點**(AutoEDA/MCP4EDA 已做),賣點在迴圈的證據紀律與地端對照。

**模型策略(雙軌)**:
- 雲端軌:Claude/GPT 級 API——當性能上界與 baseline
- 地端軌:Qwen2.5-Coder 7B/14B 量化跑 Ollama(單卡可跑,你的硬體就夠)——**論文主軸**
- 主實驗敘事:「閉環修復把地端模型從 X% 拉到 Y%,追回雲端差距的 Z%」——這一句話就是整個專案的 headline
- 選配(Phase 3 之後才考慮):LoRA 微調地端模型,非必需

---

## 四、技術棧清單

| 層 | 工具 | 備註 |
|---|---|---|
| OS 環境 | WSL2 + Docker(你在 Windows 11) | 第 0 週先裝,EDA 工具鏈全在 Linux 側 |
| 模擬/lint | Verilator、Icarus Verilog、cocotb | cocotb 用 Python 寫 testbench,LLM 生成友善 |
| 合成/時序 | Yosys、OpenSTA | |
| PnR/實體 | LibreLane(classic flow)、sky130A PDK | 不要碰自訂 flow,用預設走到底 |
| 版圖檢查 | KLayout(DRC)、netgen(LVS) | LibreLane 內建呼叫 |
| Agent | LangGraph(狀態機)+ function calling/MCP | 與你候選 1–3 技能樹共用 |
| 地端推理 | Ollama + Qwen2.5-Coder 7B/14B(Q4/Q5 量化) | |
| 評測 | VerilogEval v2 官方 harness、RTLLM v2、自建繁中集 | v2 的失敗分類直接沿用 |
| 可觀測 | Langfuse 或自建 trace | 修復迴圈全程留痕,支撐 log-grounded 主張 |

---

## 五、評測設計(整個專案的靈魂)

1. **標準 benchmark**:VerilogEval v2(156 題,spec-to-RTL 模式)+ RTLLM v2。報 pass@1/pass@5、語法通過率、修復輪數分布、每題 token 成本。
2. **對照組設計**(單變數紀律):
   - 裸 LLM(無迴圈)vs +lint 迴圈 vs +模擬迴圈 vs 完整閉環——每加一層量一次,證明每個組件都有貢獻
   - 雲端模型 vs 地端模型 × 上述每個配置——2×4 矩陣
3. **污染防線**:VerilogEval/RTLLM 可能已進訓練資料——用 2026 新基準(ChipVerilog、ArchXBench)抽樣交叉驗證,並在自建繁中集用全新題目;報告裡誠實標註污染風險。
4. **自建繁中 spec→RTL 評測集**:50–100 題(UART、SPI、FIFO、timer、FSM、簡單 DSP),繁中規格書寫,附 golden testbench,CC 授權開源。這是可引用的獨立貢獻。
5. **下游指標**(Phase 2 後):合成通過率、時序收斂率、面積/功耗數字,在 sky130 上可完全重現。

---

## 六、時程(兩種排法,你選)

### 排法甲:不衝今年投片(穩健,5 個月)

| 月 | 里程碑 | go/no-go |
|---|---|---|
| 0.5 | WSL2+Docker+LibreLane 環境、手動跑通一個 UART 的 spec→GDS | 環境跑不通就先解決,別帶病開工 |
| 1–2 | A 主幹 MVP:閉環 agent + VerilogEval v2 harness 接通,出第一版 2×4 矩陣數字 | pass@1 對裸 LLM 無提升 → 迴圈設計要重想 |
| 3 | 下游閉環(合成+STA+LibreLane)、失敗分類報告、log-grounded 修復落地 | |
| 4 | 自建繁中評測集 50 題 + 評測報告 v1;ORAssistant/LibreLane 上游 PR | |
| 5 | 打磨開源 release(README、重現腳本、demo 影片)、寫 technical report | |

### 排法乙:衝 TTIHP26b 投片(9/21 截止,壓縮但敘事封頂)

- 週 1–2:環境 + 手動跑通 TT template
- 週 3–5:A 主幹最小迴圈(不接完整 benchmark),讓 agent 設計一個小 block(如可配置 PWM/UART 週邊),人工複核後投 TTIHP26b(€70)
- 週 6 起:回到排法甲的 benchmark 主線
- 代價:MVP 期被壓縮約一個月;收益:「agent 設計的晶片正在製造中」從 10 月起就是你所有簡報的第一張圖(晶片 2027 年中到手,但 shuttle 收錄本身即公開可查證紀錄)
- 風險控制:投片 block 必須極簡且人工全查——投片是敘事資產,不是實驗數據,別讓它反過來綁架主線

---

## 七、對抗檢驗(先自我拆台)

| 攻擊 | 回應 |
|---|---|
| 「MCP 包 EDA 工具 AutoEDA 做過了」 | 承認,接口層不當賣點。差異化在:地端對照矩陣、log-grounded 修復、繁中集、實體投片——四個都是他們沒有的 |
| 「benchmark 已被雲端大模型打到 60%+,你地端 7B 會很難看」 | 難看正是研究發現——量化差距、用閉環追回,那條「追回曲線」就是主結果,不是遮羞布 |
| 「VerilogEval 有污染疑慮」 | 用 2026 新基準交叉驗證 + 自建全新題;報告誠實標註 |
| 「EDA 工具鏈是工時黑洞」 | 只用 LibreLane classic flow + sky130,不碰自訂;第 0 週先手動全流程驗證環境;PnR 問題超過兩天就降級(合成+STA 為底線,PnR 選配) |
| 「你沒有半導體業 domain 資料」 | 不裝有。定位就是開源 PDK + 公開 benchmark 上的方法研究,宣稱範圍嚴格對齊實作(honestcode 紀律) |
| 「agent 設計 CPU?」 | 不。範圍鎖死小型週邊 block(UART/SPI/FIFO/PWM/FSM),宣稱與範圍一致 |

---

## 八、比賽與產出對應

| 出口 | 對應物 | 時點 |
|---|---|---|
| GenAI Stars 下一屆 | 提案賽,半導體×AI 是台灣主場密集賽道(本屆 5 隊) | 追蹤下屆公告 |
| ITMA 2027 開源貢獻獎 | ORAssistant/LibreLane/EDA Corpus 上游 PR + 自建繁中集開源 + TT 投片公開紀錄 | 全年累積,報名前須有可查證紀錄 |
| ICCAD CAD Contest | 學術 EDA 競賽、研究生常規戰場(台灣深度參與) | 需查下一屆題目與時程 |
| lablab.ai / Devpost | agent 原型拿去打線上黑客松練手 | 隨時 |
| 論文/技術報告 | 地端 vs 雲端閉環對照 + 繁中 benchmark | 月 5 |
| 學位論文素材 | 邊緣 AI × agent 的交叉正好是你的主線 | — |

---

## 九、第 0 週行動清單

1. 裝 WSL2 + Docker Desktop,拉 LibreLane image,跑官方 smoke test
2. 手動(不用 agent)把一個現成 UART 從 RTL 走到 GDS——確認工具鏈可用,順便理解 agent 之後要自動化的每一步
3. Clone VerilogEval v2,跑通官方 harness(先用任一雲端 API 測 10 題)
4. Ollama 拉 Qwen2.5-Coder 7B,同樣 10 題,拿到第一組地端 baseline
5. 決定排法甲/乙——乙的話,同步研究 TT template 與 TTIHP26b 規則
6. 建 repo(公開),第一天就開源——開源貢獻獎的紀錄從 commit 1 開始算

---

## 來源

- [LibreLane 發布公告 — FOSSI Foundation](https://fossi-foundation.org/blog/2025-08-17-librelane)
- [librelane/librelane — GitHub](https://github.com/librelane/librelane)
- [Tiny Tapeout Chips(shuttle 時程與價格)](https://tinytapeout.com/chips/)
- [ChipFoundry Sky130 Shuttle Confirmed — Tiny Tapeout](https://tinytapeout.com/news/sky130-confirmed/)
- [Tiny Tapeout 從 Efabless 倒閉中恢復 — eeNews Europe](https://www.eenewseurope.com/en/tiny-tapeout-sees-industrial-boost-as-it-recovers-from-efabless-closure/)
- [Revisiting VerilogEval — ACM TODAES](https://dl.acm.org/doi/10.1145/3718088)
- [ChipVerilog benchmark — arXiv](https://arxiv.org/html/2607.13079v2)
- [ArchXBench — arXiv](https://arxiv.org/pdf/2508.06047)
- [PostEDA-Bench — arXiv](https://arxiv.org/pdf/2605.06936)
- [TuRTLe 統一評測 — arXiv](https://arxiv.org/pdf/2504.01986)
- [AutoEDA(MCP 微服務 EDA agent)— arXiv](https://arxiv.org/abs/2508.01012)
- [ChatEDA — GitHub](https://github.com/wuhy68/ChatEDA)
- [ORAssistant — arXiv](https://arxiv.org/pdf/2410.03845)
- [ORFS-agent — arXiv](https://arxiv.org/pdf/2506.08332)
- [NL2GDS — arXiv](https://arxiv.org/pdf/2603.05489)
- [EDA Corpus(OpenROAD 互動資料集)— arXiv](https://arxiv.org/pdf/2405.06676)
- [Verilog 多語言偏差研究 — Electronics](https://doi.org/10.3390/electronics15112275)
- [Agentic AI for Physical Design — ISPD 2026](https://dl.acm.org/doi/10.1145/3764386.3779612)
