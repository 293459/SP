# =============================================================================
# run_all_meshes.ps1
# Esegue il solver Euler2D per ogni mesh presente nella cartella,
# modificando automaticamente il file input.txt tra un run e l'altro.
#
# USO:
#   Aprire PowerShell nella cartella Bump, poi:
#   .\run_all_meshes.ps1
#
# OUTPUT:
#   Per ogni mesh viene creata una cartella SIM_OUTPUT_<k>/ con i .plt
#   e una riga nel file RECAP_SIMULAZIONI.csv
# =============================================================================

# --- CONFIGURAZIONE ---------------------------------------------------------

# Percorso dell'eseguibile (relativo o assoluto)
$EXECUTABLE = "..\Euler2D\euler2d.exe"

# File di input da modificare ad ogni run
$INPUT_FILE = "input.txt"

# Lista dei file mesh da simulare (modifica l'ordine se vuoi)
$MESHES = @(
    "bump_str_n1.msh",
    "bump_str_n2.msh",
    "bump_str_n3.msh",
    "bump_str_n4.msh",
    "bump_unstr_n1.msh",
    "bump_unstr_n05.msh"
)

# ----------------------------------------------------------------------------

# Legge il contenuto originale di input.txt come array di righe
$original_input = Get-Content $INPUT_FILE

# Trova l'indice della riga che contiene il nome del mesh attuale.
# Convenzione: il nome del mesh è sulla riga DOPO la riga "MESH FILE"
$mesh_line_index = -1
for ($i = 0; $i -lt $original_input.Length; $i++) {
    if ($original_input[$i] -match "MESH FILE") {
        $mesh_line_index = $i + 1   # la riga successiva contiene il nome file
        break
    }
}

if ($mesh_line_index -eq -1) {
    Write-Error "Impossibile trovare la sezione 'MESH FILE' in $INPUT_FILE"
    exit 1
}

# Crea file log con timestamp di inizio
$log_file = "run_all_meshes_log.txt"
"=== RUN AVVIATO: $(Get-Date) ===" | Out-File $log_file

# ----------------------------------------------------------------------------
# CICLO PRINCIPALE — un run per ogni mesh
# ----------------------------------------------------------------------------

$run_index = 1

foreach ($mesh in $MESHES) {

    # Verifica che il file mesh esista prima di lanciare
    if (-not (Test-Path $mesh)) {
        Write-Warning "[$run_index/$($MESHES.Count)] Mesh non trovata: $mesh — SKIP"
        "SKIP: $mesh — file non trovato" | Out-File $log_file -Append
        $run_index++
        continue
    }

    Write-Host ""
    Write-Host "============================================================"
    Write-Host " Run $run_index / $($MESHES.Count): $mesh"
    Write-Host "============================================================"

    # Sostituisce il nome del mesh nella riga corretta di input.txt
    $modified_input = $original_input.Clone()
    $modified_input[$mesh_line_index] = $mesh
    $modified_input | Set-Content $INPUT_FILE

    # Avvia il solver e aspetta che finisca (Start-Process -Wait)
    $start_time = Get-Date
    Write-Host " Inizio: $start_time"

    $proc = Start-Process -FilePath $EXECUTABLE `
                          -Wait `
                          -PassThru `
                          -NoNewWindow

    $end_time  = Get-Date
    $elapsed   = ($end_time - $start_time).ToString("hh\:mm\:ss")

    if ($proc.ExitCode -eq 0) {
        Write-Host " Fine:   $end_time  (durata: $elapsed)  [OK]" -ForegroundColor Green
        "OK  | $mesh | durata $elapsed" | Out-File $log_file -Append
    } else {
        Write-Host " ERRORE: exit code $($proc.ExitCode)" -ForegroundColor Red
        "ERR | $mesh | exit code $($proc.ExitCode)" | Out-File $log_file -Append
    }

    $run_index++
}

# ----------------------------------------------------------------------------
# Ripristina il file input.txt originale (opzionale ma consigliato)
# ----------------------------------------------------------------------------
$original_input | Set-Content $INPUT_FILE
Write-Host ""
Write-Host "Tutti i run completati. input.txt ripristinato al valore originale."
Write-Host "Log salvato in: $log_file"
"=== RUN COMPLETATO: $(Get-Date) ===" | Out-File $log_file -Append
