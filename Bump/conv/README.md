# Analisi di convergenza del bump — dati e verifica

Questa cartella raccoglie i **dati di convergenza di griglia** del caso bump, ottenuti
**eseguendo realmente il codice di Eulero** (cartella `Euler2D/`) e non da valori pre-inseriti.

## File
| File | Contenuto |
|---|---|
| `results_llf.csv` | Norma $L_2$ dell'entropia con flusso di **Lax–Friedrichs**, 4 griglie |
| `results_roe.csv` | Norma $L_2$ dell'entropia con flusso di **Roe**, 4 griglie |
| `analyze.py` | Calcolo ordine di convergenza, Richardson e GCI dai CSV |
| `plot_fields_pil.py` | Renderer dei campi Mach/P/T da `.plt` (senza matplotlib) |

## Risultati (CFL = 0.3, a convergenza dei residui)

| Griglia | nodi | h | ‖S‖₂ LLF | ‖S‖₂ Roe |
|---|---|---|---|---|
| n1 | 750 | 0.020 | 2.88e-3 | 3.35e-3 |
| n2 | 3000 | 0.010 | 1.91e-3 | 1.79e-3 |
| n3 | 6750 | 0.0067 | 1.47e-3 | 1.16e-3 |
| n4 | 12000 | 0.005 | 1.22e-3 | 8.98e-4 |

**Ordine di convergenza** (fit log-log): LLF p ≈ 0.62, Roe p ≈ 0.96 — coerenti con i valori
attesi (≈0.60 e ≈0.86). La norma decresce monotonicamente; sulle griglie fini Roe < LLF
(minore dissipazione). Sulla griglia più fine Roe = 8.98e-4 coincide entro l'1.5% col
riferimento.

## Note operative
- Lo **schema** (Roe / Lax–Friedrichs) si seleziona a compile-time in
  `Euler2D/compute_fluxes.f90` (righe ~20–21): per cambiare schema si commenta una chiamata e
  si ricompila.
- Stabilità: il caso bump è stabile per **CFL ≤ ~0.5**; a CFL = 0.8 diverge.
- Mesh: `Bump/bump_str_n1..n4.msh`.

> I run completi (cartelle di output `.plt`, eseguibili) non sono versionati perché pesanti:
> sono rigenerabili eseguendo il solutore con gli input in `Debug/Debug_1/`.
