# =========================================================================
# generate.ps1 — VerilogEval v2 spec-to-rtl 生成器(Windows 側)
# =========================================================================
# 為什麼在 Windows 跑:WSL2 NAT 模式下 Ollama(綁 127.0.0.1)無法從 WSL 直達,
# 而 Windows 側 localhost 直通。生成與評測因此拆成兩段,以檔案交接:
#   [Windows] generate.ps1 → completions/ → [WSL] evaluate.py
#
# Prompt 組裝忠實復刻官方 scripts/sv-generate(spec-to-rtl task):
#   system: "You are a Verilog RTL designer that only writes code using correct Verilog syntax."
#   user  : (N-shot 前綴 +) 題目 + "[BEGIN]/[DONE]" 包覆指示
# 代碼擷取同官方:逐行掃 [BEGIN]/[DONE] 標記。
#
# 用法範例:
#   powershell -File generate.ps1 -Model qwen2.5-coder:3b -NumProblems 20 -Tag 3b
# =========================================================================
param(
    [string]$Model       = "qwen2.5-coder:3b",
    [int]   $NumProblems = 20,
    [int]   $SkipProblems = 0,
    [int]   $Shots       = 0,
    [double]$Temperature = 0.0,
    [double]$TopP        = 0.95,
    [int]   $MaxTokens   = 1024,
    [int]   $NumCtx      = 8192,
    [int]   $Seed        = 42,
    [string]$Tag         = "run",
    [string]$WslUser     = "a413123a413123",
    [string]$OllamaUrl   = "http://localhost:11434"
)

$ErrorActionPreference = "Stop"

$wslBase   = "\\wsl.localhost\Ubuntu\home\$WslUser"
$datasetDir = "$wslBase\verilog-eval\dataset_spec-to-rtl"
$scriptsDir = "$wslBase\verilog-eval\scripts"
$outDir     = "$wslBase\edge-rtl-agent\results\completions_$Tag"

# 官方 spec-to-rtl 的 system 與結尾指示(逐字取自 sv-generate)
$systemMsg = "You are a Verilog RTL designer that only writes code using correct Verilog syntax."
$noExplain = "Enclose your code with [BEGIN] and [DONE]. Only output the code snippet`nand do NOT output anything else."

# few-shot 前綴(官方 1–4 shot 檔)
$shotPrefix = ""
if ($Shots -gt 0) {
    $shotFile = "$scriptsDir\verilog-example-prefix_spec-to-rtl_$Shots-shot.txt"
    $shotPrefix = [System.IO.File]::ReadAllText($shotFile)
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$problems = Get-ChildItem $datasetDir -Filter *_prompt.txt | Sort-Object Name | Select-Object -Skip $SkipProblems -First $NumProblems
Write-Host ("模型 {0} | 題數 {1} | {2}-shot | temp {3}" -f $Model, $problems.Count, $Shots, $Temperature)

$runMeta = @()
$idx = 0
foreach ($p in $problems) {
    $idx++
    $probName = $p.Name -replace '_prompt\.txt$', ''
    $promptText = [System.IO.File]::ReadAllText($p.FullName)

    # 組裝 user 訊息(0-shot:題目+指示;N-shot:前綴+Question/Answer 框架)
    if ($Shots -gt 0) {
        $userMsg = $shotPrefix + "`nQuestion:`n" + $promptText + "`n" + $noExplain + "`n`nAnswer:`n"
    } else {
        $userMsg = $promptText + "`n" + $noExplain
    }

    $body = @{
        model    = $Model
        stream   = $false
        messages = @(
            @{ role = "system"; content = $systemMsg },
            @{ role = "user";   content = $userMsg }
        )
        options  = @{
            temperature = $Temperature
            top_p       = $TopP
            num_predict = $MaxTokens
            num_ctx     = $NumCtx
            seed        = $Seed
        }
    } | ConvertTo-Json -Depth 6

    $t0 = Get-Date
    $resp = Invoke-RestMethod -Uri "$OllamaUrl/api/chat" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 600
    $elapsed = ((Get-Date) - $t0).TotalSeconds
    $content = $resp.message.content

    # --- 官方式代碼擷取:逐行掃 [BEGIN]/[DONE] ---
    # 稽核輪一 V1 修正:與官方一致,兩標記齊全才採用(截斷回應走 fallback)
    $codeLines = New-Object System.Collections.Generic.List[string]
    $started = $false; $ended = $false
    foreach ($line in ($content -split "`r?`n")) {
        if (-not $started) {
            if ($line.Trim() -eq "[BEGIN]") { $started = $true }
            elseif ($line.TrimStart().StartsWith("[BEGIN]")) {
                $codeLines.Add($line.TrimStart().Replace("[BEGIN]", "")); $started = $true
            }
        } elseif (-not $ended) {
            if ($line.Trim() -eq "[DONE]") { $ended = $true }
            elseif ($line.TrimEnd().EndsWith("[DONE]")) {
                $codeLines.Add($line.TrimEnd().Replace("[DONE]", "")); $ended = $true
            } else { $codeLines.Add($line) }
        }
    }
    if (-not ($started -and $ended)) { $codeLines.Clear() }
    # 後備:標記不齊時退而擷取 ``` 圍欄(記錄 fallback 供分析)
    $usedFallback = $false
    if ($codeLines.Count -eq 0) {
        $usedFallback = $true
        $inFence = $false
        foreach ($line in ($content -split "`r?`n")) {
            if ($line.Trim().StartsWith('```')) {
                if ($inFence) { break } else { $inFence = $true; continue }
            }
            if ($inFence) { $codeLines.Add($line) }
        }
        if ($codeLines.Count -eq 0) { $codeLines.Add($content) }  # 全文照存,讓編譯器誠實裁決
    }

    $probOut = "$outDir\$probName"
    New-Item -ItemType Directory -Force -Path $probOut | Out-Null
    # 用 .NET WriteAllText:UTF-8 無 BOM(iverilog 不吃 BOM)
    [System.IO.File]::WriteAllText("$probOut\sample01.sv", ($codeLines -join "`n") + "`n")

    $meta = [ordered]@{
        problem           = $probName
        gen_seconds       = [math]::Round($elapsed, 1)
        prompt_eval_count = $resp.prompt_eval_count
        eval_count        = $resp.eval_count
        marker_fallback   = $usedFallback
    }
    $runMeta += $meta
    Write-Host ("[{0}/{1}] {2}  {3}s  out={4} tok  fallback={5}" -f $idx, $problems.Count, $probName, [math]::Round($elapsed,1), $resp.eval_count, $usedFallback)
}

# 整輪 metadata(方法論可追溯:與官方 n=20/temp0.8 取樣的差異在此註明)
$runInfo = [ordered]@{
    model       = $Model
    task        = "spec-to-rtl"
    shots       = $Shots
    temperature = $Temperature
    top_p       = $TopP
    max_tokens  = $MaxTokens
    num_ctx     = $NumCtx
    seed        = $Seed
    n_samples   = 1
    note        = "single-sample pass@1 (temp 0); official uses n=20 samples at temp 0.8 for pass@k"
    problems    = $runMeta
}
# 按批次命名 metadata,避免多批次寫同一 Tag 目錄時互相覆寫(provenance 保全)
[System.IO.File]::WriteAllText("$outDir\run_metadata_skip$SkipProblems.json", ($runInfo | ConvertTo-Json -Depth 5))
Write-Host "完成:$outDir"
