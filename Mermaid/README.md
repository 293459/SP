# Mappe mentali Mermaid — corso SP (CFD)

Questa cartella contiene le mappe mentali del corso in formato **Mermaid** (`.mmd`),
una generale e una per ogni macro-argomento, fedeli alla suddivisione della pagina Notion.

## File

| File | Argomento |
|---|---|
| `00_SP_generale.mmd` | Mappa generale dell'intero corso (tutti i macro-argomenti) |
| `01_fluid_dynamics.mmd` | Fluidodinamica (Eulero 1D, caratteristiche, modelli) |
| `02_numerical_methods.mmd` | Metodi numerici per ODE (errori, stabilità, struttura metodi) |
| `03_finite_volumes.mmd` | Volumi finiti (Godunov, Roe, flux splitting) |
| `04_meshing.mmd` | Meshing (tipologie, metriche, refinement) |
| `05_turbolence.mmd` | Turbolenza (RANS/LES/DNS, Reynolds, Boussinesq) |
| `06_reacting_flows.mmd` | Flussi reagenti (Damköhler, premiscelati, Chorin) |

## Come usarle

### 1. In Notion (consigliato)
Crea un blocco `/code`, scegli linguaggio **Mermaid**, e incolla il contenuto del file
(senza le righe iniziali di commento `%%` se Notion non le gradisce). Notion renderizza
la mindmap direttamente.

### 2. Renderizzare in PNG/PDF per il LaTeX
Mermaid **non** si compila nativamente con `pdflatex`. Per inserire le mappe nel report
si pre-renderizza l'immagine con `mermaid-cli` e la si include con `\includegraphics`:

```bash
# installazione una tantum
npm install -g @mermaid-js/mermaid-cli

# render di una mappa in PDF vettoriale
mmdc -i 00_SP_generale.mmd -o 00_SP_generale.pdf

# oppure in PNG ad alta risoluzione
mmdc -i 00_SP_generale.mmd -o 00_SP_generale.png -w 2000
```

Poi nel `.tex`:
```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=\textwidth]{Mermaid/00_SP_generale.pdf}
  \caption{Mappa concettuale generale del corso.}
\end{figure}
```

> Nota: la sintassi `mindmap` richiede una versione recente di mermaid-cli.
> Se non disponibile, le mappe restano comunque utilizzabili direttamente in Notion.
