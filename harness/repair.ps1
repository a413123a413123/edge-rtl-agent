# =========================================================================
# repair.ps1 — 閉環修復迴圈(生成 → 評測 → 讀錯誤 log → 修復 → 重測)
# =========================================================================
# 設計決策(記錄於此供論文與審查):
#  - 無狀態修復:每輪修復提示 = 原規格 + 上一版程式碼 + 工具錯誤摘要,
#    不累積多輪對話——上下文有界、每輪獨立可重現(對照:AutoChip 用累積對話)。
#  - log-grounded:修復提示只允許來自 check_one.py 的工具輸出摘要;
#    永不讀取 test.sv / ref.sv 內容(資料洩漏紅線)。
#  - 全軌跡留痕:每次嘗試的 .sv 與判定碼都落地(attemptN.sv + trajectory.jsonl),
#    支撐可稽核性;sample01.sv 永遠是最後一版,可直接交給 evaluate.py 獨立重評。
#
# 用法:powershell -File repair.ps1 -Model qwen2.5-coder:3b -NumProblems 10 `
#        -SkipProblems 0 -Shots 1 -MaxRepairs 3 -Tag repair_3b_1shot
# =========================================================================
param(
    [string]$Model        = "qwen2.5-coder:3b",
    [int]   $NumProblems  = 10,
    [int]   $SkipProblems = 0,
    [int]   $Shots        = 1,
    [int]   $MaxRepairs   = 3,
    [double]$Temperature  = 0.0,
    [double]$RepairTemperature = 0.4,
    [double]$TopP         = 0.95,
    [int]   $MaxTokens    = 1024,
    [int]   $NumCtx       = 8192,
    [string]$Tag          = "repair_run",
    [string]$WslUser      = "a413123a413123",
    [string]$OllamaUrl    = "http://localhost:11434",
    [int]   $Seed         = 42,
    [string]$ProblemListFile = "",
    [switch]$NoFeedback,
    [switch]$CodeOnly
)
# -ProblemListFile:題目清單檔(每行一個題名),用於非連續子集(如時序題分層);
#   Skip/NumProblems 改作用於清單行。空字串=沿用按檔名排序的連續取題。
# 三臂消融設計(稽核輪一 V3 critical 修正:兩臂各差一個變數,歸因才成立):
#   full(預設)   :規格 + 舊碼 + 工具錯誤摘要
#   -CodeOnly     :規格 + 舊碼(無錯誤摘要)——與 full 只差 log 一個變數
#   -NoFeedback   :規格(無舊碼無摘要)——純重抽樣底線
# -Seed 傳入 Ollama options 並落地於軌跡,使 temp>0 的修復輪可重現。
if ($NoFeedback -and $CodeOnly) { throw "NoFeedback 與 CodeOnly 互斥" }

$ErrorActionPreference = "Stop"

$wslBase    = "\\wsl.localhost\Ubuntu\home\$WslUser"
$wslHome    = "/home/$WslUser"
$datasetWin = "$wslBase\verilog-eval\dataset_spec-to-rtl"
$datasetWsl = "$wslHome/verilog-eval/dataset_spec-to-rtl"
$outWin     = "$wslBase\edge-rtl-agent\results\$Tag"
$outWsl     = "$wslHome/edge-rtl-agent/results/$Tag"

$systemMsg = "You are a Verilog RTL designer that only writes code using correct Verilog syntax."
$noExplain = "Enclose your code with [BEGIN] and [DONE]. Only output the code snippet`nand do NOT output anything else."

$shotPrefix = ""
if ($Shots -gt 0) {
    $shotPrefix = [System.IO.File]::ReadAllText("$wslBase\verilog-eval\scripts\verilog-example-prefix_spec-to-rtl_$Shots-shot.txt")
}

function Invoke-Gen([object[]]$messages, [double]$temp) {
    $body = @{
        model    = $Model
        stream   = $false
        messages = $messages
        options  = @{
            temperature = $temp
            top_p       = $TopP
            num_predict = $MaxTokens
            num_ctx     = $NumCtx
            seed        = $Seed
        }
    } | ConvertTo-Json -Depth 6
    return Invoke-RestMethod -Uri "$OllamaUrl/api/chat" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 600
}

function Extract-Code([string]$content) {
    # 官方式 [BEGIN]/[DONE] 逐行擷取。稽核輪一 V1 修正:與官方一致,
    # 「兩標記齊全」才採用標記擷取(截斷回應→走 fallback,不再照收殘段);
    # 回傳 hashtable 以記錄 fallback 使用情形。
    $lines = New-Object System.Collections.Generic.List[string]
    $started = $false; $ended = $false
    foreach ($line in ($content -split "`r?`n")) {
        if (-not $started) {
            if ($line.Trim() -eq "[BEGIN]") { $started = $true }
            elseif ($line.TrimStart().StartsWith("[BEGIN]")) {
                $lines.Add($line.TrimStart().Replace("[BEGIN]", "")); $started = $true
            }
        } elseif (-not $ended) {
            if ($line.Trim() -eq "[DONE]") { $ended = $true }
            elseif ($line.TrimEnd().EndsWith("[DONE]")) {
                $lines.Add($line.TrimEnd().Replace("[DONE]", "")); $ended = $true
            } else { $lines.Add($line) }
        }
    }
    if ($started -and $ended -and $lines.Count -gt 0) {
        return @{ code = (($lines -join "`n") + "`n"); fallback = $false }
    }
    # fallback:``` 圍欄;再不然整段照存(交給編譯器誠實裁決)
    $fb = New-Object System.Collections.Generic.List[string]
    $inFence = $false
    foreach ($line in ($content -split "`r?`n")) {
        if ($line.Trim().StartsWith('```')) {
            if ($inFence) { break } else { $inFence = $true; continue }
        }
        if ($inFence) { $fb.Add($line) }
    }
    if ($fb.Count -eq 0) { $fb.Add($content) }
    return @{ code = (($fb -join "`n") + "`n"); fallback = $true }
}

function Check-One([string]$probName) {
    $cmd = "docker run --rm -v ${wslHome}:${wslHome} -w $wslHome/edge-rtl-agent ghcr.io/librelane/librelane:3.0.10 python3 harness/check_one.py --sample $outWsl/$probName/sample01.sv --test $datasetWsl/${probName}_test.sv --ref $datasetWsl/${probName}_ref.sv"
    $raw = (wsl -e bash -c $cmd) -join ""
    return $raw | ConvertFrom-Json
}

New-Item -ItemType Directory -Force -Path $outWin | Out-Null
$trajPath = "$outWin\trajectory.jsonl"

if ($ProblemListFile -ne "") {
    $names = Get-Content $ProblemListFile | Where-Object { $_.Trim() -ne "" } | Select-Object -Skip $SkipProblems -First $NumProblems
    $problems = $names | ForEach-Object { Get-Item "$datasetWin\$($_.Trim())_prompt.txt" }
} else {
    $problems = Get-ChildItem $datasetWin -Filter *_prompt.txt | Sort-Object Name | Select-Object -Skip $SkipProblems -First $NumProblems
}
Write-Host ("修復迴圈:{0} | 題 {1}(skip {2})| {3}-shot | 最多修 {4} 輪" -f $Model, $problems.Count, $SkipProblems, $Shots, $MaxRepairs)

$idx = 0
foreach ($p in $problems) {
    $idx++
    $probName = $p.Name -replace '_prompt\.txt$', ''
    $spec = [System.IO.File]::ReadAllText($p.FullName)
    $probOut = "$outWin\$probName"
    New-Item -ItemType Directory -Force -Path $probOut | Out-Null

    $attempts = @()
    $traj = ""
    $prevCode = $null
    $lastExcerpt = $null

    for ($attempt = 0; $attempt -le $MaxRepairs; $attempt++) {
        if ($attempt -eq 0) {
            if ($Shots -gt 0) {
                $userMsg = $shotPrefix + "`nQuestion:`n" + $spec + "`n" + $noExplain + "`n`nAnswer:`n"
            } else {
                $userMsg = $spec + "`n" + $noExplain
            }
        } else {
            # 無狀態修復提示:規格 + 工具錯誤摘要 + 上一版(僅此三者,無 test/ref 內容)。
            # 設計要點(煙霧測試教訓):temp 0 下小模型會把舊答案原樣複製(複製吸子),
            # 故 (1) 修復輪用較高溫度 (2) 錯誤放在舊碼之前 (3) 舊碼明標 INCORRECT
            # (4) 不用 [BEGIN] 框舊碼,避免格式錨定。
            if ($NoFeedback) {
                $userMsg = "Question:`n" + $spec + "`n`nYour previous attempt failed verification. Write a corrected implementation of module TopModule.`n" + $noExplain
            } elseif ($CodeOnly) {
                $userMsg = "Question:`n" + $spec + "`n`nYour previous attempt (INCORRECT - do not repeat it verbatim):`n" + '```' + "`n" + $prevCode + '```' + "`n`nIt failed verification. Rewrite the complete corrected module TopModule.`n" + $noExplain
            } else {
                $userMsg = "Question:`n" + $spec + "`n`nIcarus Verilog reported the following problems with your previous attempt:`n" + $lastExcerpt + "`n`nYour previous attempt (INCORRECT - do not repeat it verbatim):`n" + '```' + "`n" + $prevCode + '```' + "`n`nRewrite the complete corrected module TopModule so it fixes these problems.`n" + $noExplain
            }
        }
        $useTemp = $Temperature
        if ($attempt -gt 0) { $useTemp = $RepairTemperature }
        $messages = @(
            @{ role = "system"; content = $systemMsg },
            @{ role = "user";   content = $userMsg }
        )
        # 稽核留痕:每輪的完整 prompt 落地
        [System.IO.File]::WriteAllText("$probOut\prompt$attempt.txt", $userMsg)
        $t0 = Get-Date
        $resp = Invoke-Gen $messages $useTemp
        $genSec = [math]::Round(((Get-Date) - $t0).TotalSeconds, 1)
        $ext = Extract-Code $resp.message.content
        $code = $ext.code

        [System.IO.File]::WriteAllText("$probOut\attempt$attempt.sv", $code)
        [System.IO.File]::WriteAllText("$probOut\sample01.sv", $code)

        $check = Check-One $probName
        $traj += $check.code
        $attempts += [ordered]@{
            attempt         = $attempt
            result          = $check.code
            mismatches      = $check.mismatches
            temperature     = $useTemp
            marker_fallback = $ext.fallback
            gen_seconds     = $genSec
            eval_count      = $resp.eval_count
            prompt_eval     = $resp.prompt_eval_count
        }
        Write-Host ("[{0}/{1}] {2} attempt{3} -> {4}  ({5}s, {6} tok)" -f $idx, $problems.Count, $probName, $attempt, $check.code, $genSec, $resp.eval_count)

        if ($check.code -eq ".") { break }
        $prevCode = $code
        $lastExcerpt = $check.log_excerpt
    }

    $rec = [ordered]@{
        problem    = $probName
        trajectory = $traj
        final      = $traj[$traj.Length - 1].ToString()
        n_attempts = $attempts.Count
        attempts   = $attempts
        model      = $Model
        shots      = $Shots
        mode       = $(if ($NoFeedback) { "resample" } elseif ($CodeOnly) { "code_only" } else { "full" })
        seed       = $Seed
        repair_temperature = $RepairTemperature
    } | ConvertTo-Json -Depth 5 -Compress
    [System.IO.File]::AppendAllText($trajPath, $rec + "`n")
}

Write-Host "批次完成:$outWin"
