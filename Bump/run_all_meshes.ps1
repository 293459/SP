<#
    run_all_meshes.ps1

    Esegue Euler2D sulle mesh Bump senza modificare Bump/input.txt.

    Uso consigliato da PowerShell:
      powershell -NoProfile -ExecutionPolicy Bypass -File .\run_all_meshes.ps1

    Uso parallelo, con al massimo 2 solver contemporanei:
      powershell -NoProfile -ExecutionPolicy Bypass -File .\run_all_meshes.ps1 -Parallel -ThrottleLimit 2

    Modifica 2026-05-06:
    - niente "del *.plt" e niente SIM_OUTPUT_0 condivisa;
    - ogni mesh riceve input_XX.txt, inlet.txt, outlet.txt e output dedicati;
    - il recap locale RECUP_SIMULAZIONE.txt viene scritto dal solver nella
      cartella della singola simulazione;
    - RECAP_SIMULAZIONI.csv resta il riepilogo globale batch.
#>

[CmdletBinding()]
param(
    [switch]$Parallel,
    [ValidateRange(1, 32)]
    [int]$ThrottleLimit = 2,
    [int]$KFinalOverride = 0,
    [int]$KInfOverride = 0,
    [int]$KOutOverride = 0,
    [string[]]$OnlyMesh = @()
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

$Executable = (Resolve-Path (Join-Path $ScriptDir "..\Euler2D\euler2d.exe")).Path
$TemplateInput = Join-Path $ScriptDir "input.txt"
$InletFile = Join-Path $ScriptDir "inlet.txt"
$OutletFile = Join-Path $ScriptDir "outlet.txt"

$Meshes = @(
    "bump_str_n1.msh",
    "bump_str_n2.msh",
    "bump_str_n3.msh",
    "bump_str_n4.msh",
    "bump_unstr_n05.msh",
    "bump_unstr_n1.msh"
)

if ($OnlyMesh.Count -gt 0) {
    $Meshes = @($OnlyMesh | ForEach-Object { $_ -split "," } | Where-Object { $_.Trim().Length -gt 0 } | ForEach-Object { $_.Trim() })
}

$BatchId = Get-Date -Format "yyyyMMdd_HHmmss"
$BatchDir = Join-Path $ScriptDir (Join-Path "runs" "batch_$BatchId")
$LogFile = Join-Path $ScriptDir "run_all_meshes_log.txt"
$GlobalRecap = Join-Path $ScriptDir "RECAP_SIMULAZIONI.csv"
$GlobalHeader = "batch_id,run_id,mesh,status,exit_code,start_time,end_time,duration_seconds,nnodi,ninterf,nele_interni,output_dir"

function Convert-ToCsvField {
    param([object]$Value)
    return '"' + ([string]$Value -replace '"', '""') + '"'
}

function Join-CsvLine {
    param([object[]]$Values)
    return (($Values | ForEach-Object { Convert-ToCsvField $_ }) -join ",")
}

function Set-ValueAfterMarker {
    param(
        [string[]]$Lines,
        [string]$Marker,
        [string]$Value
    )

    for ($i = 0; $i -lt $Lines.Count; $i++) {
        if ($Lines[$i] -match [regex]::Escape($Marker)) {
            if ($i + 1 -ge $Lines.Count) {
                throw "Marker '$Marker' trovato, ma manca la riga valore successiva."
            }
            $Lines[$i + 1] = $Value
            return
        }
    }

    throw "Marker '$Marker' non trovato in input.txt."
}

function Ensure-GlobalRecap {
    if (-not (Test-Path $GlobalRecap)) {
        $GlobalHeader | Set-Content -Path $GlobalRecap -Encoding ASCII
        return
    }

    $firstLine = Get-Content -Path $GlobalRecap -TotalCount 1
    $normalizedHeader = $firstLine -replace '"', ''
    if ($normalizedHeader -ne $GlobalHeader) {
        $backup = "$GlobalRecap.legacy_$BatchId.bak"
        Copy-Item -Path $GlobalRecap -Destination $backup -Force
        $GlobalHeader | Set-Content -Path $GlobalRecap -Encoding ASCII
        "LEGACY RECAP salvato in: $backup" | Out-File -FilePath $LogFile -Append -Encoding ASCII
    }
}

function New-SimulationCase {
    param(
        [string]$Mesh,
        [int]$Index
    )

    $meshPath = (Resolve-Path (Join-Path $ScriptDir $Mesh)).Path
    $meshStem = [IO.Path]::GetFileNameWithoutExtension($Mesh)
    $runId = "{0:00}_{1}" -f $Index, $meshStem
    $runDir = Join-Path $BatchDir $runId
    New-Item -ItemType Directory -Force -Path $runDir | Out-Null
    $runDirForRecap = $runDir
    if ($runDir.StartsWith($ScriptDir, [System.StringComparison]::OrdinalIgnoreCase)) {
        $runDirForRecap = $runDir.Substring($ScriptDir.Length).TrimStart('\', '/')
    }

    Copy-Item -Path $InletFile -Destination (Join-Path $runDir "inlet.txt") -Force
    Copy-Item -Path $OutletFile -Destination (Join-Path $runDir "outlet.txt") -Force

    [string[]]$inputLines = Get-Content -Path $TemplateInput
    Set-ValueAfterMarker -Lines $inputLines -Marker "MESH FILE" -Value $meshPath

    if ($KFinalOverride -gt 0) { Set-ValueAfterMarker -Lines $inputLines -Marker "KFINAL" -Value ([string]$KFinalOverride) }
    if ($KInfOverride -gt 0) { Set-ValueAfterMarker -Lines $inputLines -Marker "KINF" -Value ([string]$KInfOverride) }
    if ($KOutOverride -gt 0) { Set-ValueAfterMarker -Lines $inputLines -Marker "KOUT" -Value ([string]$KOutOverride) }

    $inputPath = Join-Path $runDir ("input_{0:00}.txt" -f $Index)
    $inputLines | Set-Content -Path $inputPath -Encoding ASCII

    [pscustomobject]@{
        RunId = $runId
        Mesh = $Mesh
        MeshPath = $meshPath
        RunDir = $runDir
        RunDirForRecap = $runDirForRecap
        InputPath = $inputPath
    }
}

function Start-SolverCase {
    param([pscustomobject]$Case)

    $stdout = Join-Path $Case.RunDir "stdout.log"
    $stderr = Join-Path $Case.RunDir "stderr.log"
    $start = Get-Date

    $proc = Start-Process `
        -FilePath $Executable `
        -ArgumentList @($Case.InputPath, $Case.RunDir) `
        -WorkingDirectory $Case.RunDir `
        -RedirectStandardOutput $stdout `
        -RedirectStandardError $stderr `
        -WindowStyle Hidden `
        -PassThru

    $Case | Add-Member -NotePropertyName Process -NotePropertyValue $proc
    $Case | Add-Member -NotePropertyName StartTime -NotePropertyValue $start
    $Case | Add-Member -NotePropertyName Stdout -NotePropertyValue $stdout
    $Case | Add-Member -NotePropertyName Stderr -NotePropertyValue $stderr
    return $Case
}

function Get-RecapValue {
    param(
        [string]$RecapPath,
        [string]$Pattern
    )

    if (-not (Test-Path $RecapPath)) { return "" }
    $match = Select-String -Path $RecapPath -Pattern $Pattern | Select-Object -First 1
    if ($null -eq $match) { return "" }
    return $match.Matches[0].Groups[1].Value
}

function Complete-SolverCase {
    param([pscustomobject]$Case)

    $Case.Process.WaitForExit()
    $Case.Process.Refresh()
    $end = Get-Date
    $elapsed = [math]::Round(($end - $Case.StartTime).TotalSeconds, 3)
    $localRecap = Join-Path $Case.RunDir "RECUP_SIMULAZIONE.txt"
    $exitCode = $Case.Process.ExitCode
    if ($null -eq $exitCode) {
        $stderrLength = if (Test-Path $Case.Stderr) { (Get-Item $Case.Stderr).Length } else { 1 }
        $exitCode = if ((Test-Path $localRecap) -and $stderrLength -eq 0) { 0 } else { 1 }
    }
    $status = if ($exitCode -eq 0) { "OK" } else { "ERR" }

    $nnodi = Get-RecapValue -RecapPath $localRecap -Pattern "Numero nodi:\s+(\d+)"
    $ninterf = Get-RecapValue -RecapPath $localRecap -Pattern "Numero interfacce:\s+(\d+)"
    $neleInterni = Get-RecapValue -RecapPath $localRecap -Pattern "Numero elementi interni:\s+(\d+)"

    Join-CsvLine @(
        $BatchId,
        $Case.RunId,
        $Case.Mesh,
        $status,
        $exitCode,
        $Case.StartTime.ToString("s"),
        $end.ToString("s"),
        $elapsed,
        $nnodi,
        $ninterf,
        $neleInterni,
        $Case.RunDirForRecap
    ) | Add-Content -Path $GlobalRecap -Encoding ASCII

    "$status | $($Case.RunId) | $($Case.Mesh) | exit $exitCode | ${elapsed}s | $($Case.RunDirForRecap)" |
        Out-File -FilePath $LogFile -Append -Encoding ASCII

    if ($exitCode -eq 0) {
        Write-Host (" OK  {0} ({1}s)" -f $Case.RunId, $elapsed) -ForegroundColor Green
    } else {
        Write-Host (" ERR {0} exit={1}" -f $Case.RunId, $exitCode) -ForegroundColor Red
        if (Test-Path $Case.Stderr) {
            Get-Content -Path $Case.Stderr -Tail 30 | ForEach-Object { Write-Host "   $_" -ForegroundColor DarkRed }
        }
    }
}

New-Item -ItemType Directory -Force -Path $BatchDir | Out-Null
"=== RUN AVVIATO: $(Get-Date) | batch=$BatchId | parallel=$Parallel | throttle=$ThrottleLimit ===" |
    Out-File -FilePath $LogFile -Encoding ASCII

Ensure-GlobalRecap

$cases = New-Object System.Collections.Generic.List[object]
$runIndex = 1
foreach ($mesh in $Meshes) {
    if (-not (Test-Path (Join-Path $ScriptDir $mesh))) {
        Write-Warning "Mesh non trovata: $mesh - skip"
        "SKIP | $mesh | file non trovato" | Out-File -FilePath $LogFile -Append -Encoding ASCII
        continue
    }

    $cases.Add((New-SimulationCase -Mesh $mesh -Index $runIndex))
    $runIndex++
}

Write-Host ""
Write-Host "Batch: $BatchId"
Write-Host "Output batch: $BatchDir"
Write-Host "Modalita: $(if ($Parallel) { 'parallela' } else { 'sequenziale' })"
Write-Host ""

$pending = New-Object System.Collections.Queue
foreach ($case in $cases) { $pending.Enqueue($case) }
$active = @()

while ($pending.Count -gt 0 -or $active.Count -gt 0) {
    while ($pending.Count -gt 0 -and (($Parallel -and $active.Count -lt $ThrottleLimit) -or (-not $Parallel -and $active.Count -eq 0))) {
        $case = $pending.Dequeue()
        Write-Host (" Avvio {0}: {1}" -f $case.RunId, $case.Mesh)
        $active += Start-SolverCase -Case $case
    }

    if (-not $Parallel) {
        Complete-SolverCase -Case $active[0]
        $active = @()
        continue
    }

    Start-Sleep -Milliseconds 500
    $finished = @($active | Where-Object { $_.Process.HasExited })
    foreach ($case in $finished) {
        Complete-SolverCase -Case $case
    }
    $active = @($active | Where-Object { -not $_.Process.HasExited })
}

"=== RUN COMPLETATO: $(Get-Date) | batch=$BatchId ===" |
    Out-File -FilePath $LogFile -Append -Encoding ASCII

Write-Host ""
Write-Host "Tutti i run completati."
Write-Host "Recap globale: $GlobalRecap"
Write-Host "Log batch:      $LogFile"
