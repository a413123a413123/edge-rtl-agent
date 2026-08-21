# =========================================================================
# generate_batch.ps1 — 多樣本批次生成器(pilot 閘門與 pass@k 用,Windows 側)
# =========================================================================
# 與 generate.ps1 的差異:
#   1. 題目來源改為 split 檔(data/split_v1.json 的 dev/test 子集)
#   2. 每題抽 NumSamples 個樣本(sample01..NN),每樣本固定 seed=SeedBase+idx
#   3. 冪等續跑:已存在的樣本檔自動跳過;-MaxMinutes 到時自行優雅退出,
#      重跑同指令即接續(配合外層排程器的時間片限制)
# 用法:
#   powershell -File generate_batch.ps1 -Model qwen2.5-coder:3b -Subset dev `
#     -NumSamples 5 -Shots 1 -Temperature 0.8 -Tag pilot_3b_q4
# =========================================================================
param(
    [string]$Model       = "qwen2.5-coder:3b",
    [string]$SplitFile   = "",
    [string]$Subset      = "dev",
    [int]   $NumSamples  = 5,
    [int]   $Shots       = 1,
    [double]$Temperature = 0.8,
    [double]$TopP        = 0.95,
    [int]   $MaxTokens   = 1024,
    [int]   $SeedBase    = 1000,
    [double]$MaxMinutes  = 8.5,
    [string]$Tag         = "batch",
    [string]$WslUser     = "a413123a413123",
    [string]$OllamaUrl   = "http://localhost:11434"
)

$ErrorActionPreference = "Stop"

$wslBase    = "\\wsl.localhost\Ubuntu\home\$WslUser"
$datasetDir = "$wslBase\verilog-eval\dataset_spec-to-rtl"
$scriptsDir = "$wslBase\verilog-eval\scripts"
$outDir     = "$wslBase\edge-rtl-agent\results\completions_$Tag"
if (-not $SplitFile) { $SplitFile = "$wslBase\edge-rtl-agent\data\split_v1.json" }

# 官方 spec-to-rtl 的 system 與結尾指示(逐字取自 sv-generate)
$systemMsg = "You are a Verilog RTL designer that only writes code using correct Verilog syntax."
$noExplain = "Enclose your code with [BEGIN] and [DONE]. Only output the code snippet`nand do NOT output anything else."

$shotPrefix = ""
if ($Shots -gt 0) {
    $shotFile = "$scriptsDir\verilog-example-prefix_spec-to-rtl_$Shots-shot.txt"
    $shotPrefix = [System.IO.File]::ReadAllText($shotFile)
}

$split = Get-Content $SplitFile -Raw | ConvertFrom-Json
$probNames = $split.$Subset
if (-not $probNames) { throw "split 檔沒有子集 '$Subset'" }

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$metaLog = "$outDir\metadata.jsonl"

# 官方式代碼擷取:[BEGIN]/[DONE] 逐行掃描 + ``` 圍欄後備
function Extract-Code([string]$content) {
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
    $fallback = $false
    if ($codeLines.Count -eq 0) {
        $fallback = $true
        $inFence = $false
        foreach ($line in ($content -split "`r?`n")) {
            if ($line.Trim().StartsWith('```')) {
                if ($inFence) { break } else { $inFence = $true; continue }
            }
            if ($inFence) { $codeLines.Add($line) }
        }
        if ($codeLines.Count -eq 0) { $codeLines.Add($content) }
    }
    return @(($codeLines -join "`n"), $fallback)
}

$deadline = (Get-Date).AddMinutes($MaxMinutes)
$done = 0; $skipped = 0
Write-Host ("模型 {0} | 子集 {1}({2} 題)| n={3} | {4}-shot | temp {5} | 時間片 {6} 分" -f `
    $Model, $Subset, $probNames.Count, $NumSamples, $Shots, $Temperature, $MaxMinutes)

foreach ($probName in $probNames) {
    $promptPath = "$datasetDir\$probName" + "_prompt.txt"
    $promptText = [System.IO.File]::ReadAllText($promptPath)
    if ($Shots -gt 0) {
        $userMsg = $shotPrefix + "`nQuestion:`n" + $promptText + "`n" + $noExplain + "`n`nAnswer:`n"
    } else {
        $userMsg = $promptText + "`n" + $noExplain
    }

    $probOut = "$outDir\$probName"
    New-Item -ItemType Directory -Force -Path $probOut | Out-Null

    for ($s = 1; $s -le $NumSamples; $s++) {
        $sampleFile = "$probOut\sample{0:d2}.sv" -f $s
        if (Test-Path $sampleFile) { $skipped++; continue }
        if ((Get-Date) -gt $deadline) {
            Write-Host ("TIME_SLICE_DONE 本片新增 {0} 樣本(略過既有 {1});重跑同指令續傳" -f $done, $skipped)
            exit 0
        }

        $seed = $SeedBase + $s
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
                seed        = $seed
            }
        } | ConvertTo-Json -Depth 6

        $t0 = Get-Date
        $resp = Invoke-RestMethod -Uri "$OllamaUrl/api/chat" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 600
        $elapsed = ((Get-Date) - $t0).TotalSeconds

        $extracted = Extract-Code $resp.message.content
        [System.IO.File]::WriteAllText($sampleFile, $extracted[0] + "`n")

        $meta = [ordered]@{
            problem     = $probName
            sample      = $s
            seed        = $seed
            model       = $Model
            shots       = $Shots
            temperature = $Temperature
            top_p       = $TopP
            gen_seconds = [math]::Round($elapsed, 1)
            prompt_tok  = $resp.prompt_eval_count
            out_tok     = $resp.eval_count
            fallback    = $extracted[1]
        } | ConvertTo-Json -Compress
        Add-Content -Path $metaLog -Value $meta -Encoding UTF8
        $done++
        Write-Host ("{0} s{1:d2}  {2}s  out={3}" -f $probName, $s, [math]::Round($elapsed,1), $resp.eval_count)
    }
}
Write-Host ("ALL_SAMPLES_DONE 本片新增 {0},略過既有 {1}" -f $done, $skipped)
