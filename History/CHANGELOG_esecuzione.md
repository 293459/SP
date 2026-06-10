# History — Esecuzione pipeline `SP dubbi.txt`

> Cartella di archiviazione di prompt, dubbi, domande e modifiche effettuate durante l'esecuzione
> del workflow descritto in `SP dubbi.txt`. Serve da memoria persistente per riprendere il lavoro
> in sessioni future. Data esecuzione: **2026-06-06**.

## File archiviati in questa cartella
- `SP_dubbi_ARCHIVIATO.txt` — copia del file originale di richieste (input della pipeline).
- `CHANGELOG_esecuzione.md` — questo file: log delle modifiche.

---

## Fase 1 — Lettura materiale (token-aware)
- Letti `.claudeignore`, `Skill/token_saving_techniques.md`, skill `Exam/Mind Map/Explanation/Report`, `Skill/data_handling.md`.
- Mappata struttura Notion (cartella `Notion/`): macro-pagine **Fluid dynamics, Numerical Methods (ODE),
  Finite Volumes Schemes, Meshing, Turbolence, Reacting Flows** (quest'ultima vuota).
- Letti i file `.tex` del report: `main, teoria, bump, doppia_presa, paletta, fluent, grafica, Codice_CFD`.

## Fase 2 — Mappe mentali Mermaid (cartella `Mermaid/`)
- `00_SP_generale.mmd` — mappa generale del corso.
- `01..06_*.mmd` — una mappa per macro-argomento (fedeli alla suddivisione Notion).
- `07_fluent_workflow.mmd` — workflow di simulazione Fluent (richiamato nel report).
- `README.md` — istruzioni d'uso (Notion + rendering per LaTeX).

## Fase 3 — Risposte markdown / simulazione d'esame (cartella `markdown/`)
- `teoria_reacting_flows.md` — teoria domande **1–6** (variabili flussi reagenti, collo di
  bottiglia/Damköhler, premiscelati vs non, problema di base, metodi, proiezione di Chorin).
  Funge anche da contenuto per la pagina Notion *Reacting Flows*.
- `teoria_metodi_numerici.md` — teoria domande **7–9** (collocazione di espliciti/impliciti,
  WENO, DG, teorema barriera di Godunov, limitatori; upwind iperbolici vs centrati ellittici).
- `report_QA.md` — le **26 domande** sul report.
- `README.md` — indice + istruzioni per incollare in Notion.
- Formato: toggle `<details>/<summary>`, keyword in grassetto, LaTeX `$...$`/`$$...$$`.

## Fase 4 — Modifiche LaTeX report (10 errori noti + discussioni)
| # | Errore noto | Intervento | File |
|---|---|---|---|
| 1 | Schema TikZ doppia rampa (testo illeggibile, urti non rappresentativi, mancano wall/simmetria) | Riscritto il `tikzpicture`: etichette leggibili (\footnotesize), urti che convergono al labbro, label Inlet/Outlet/Wall/Simmetria, nota su dipendenza dal Mach | `doppia_presa.tex` |
| 2 | "ipersonico basso" per M=3 | Sostituito con "regime supersonico" | `doppia_presa.tex` |
| 3 | Header destro troppo lungo, si sovrappone | Titolo corso spostato in piè di pagina | `main.tex` |
| 4 | `doppia_presa_semplificata` sfora il margine | Titoli subsection accorciati (filename nel corpo) | `doppia_presa.tex` |
| 5 | Sezione 6.4.1 raffinamento mesh superflua | Commentata con `\iffalse...\fi` | `doppia_presa.tex` |
| 6 | Immagine di confronto duplicata | Rimosso il duplicato (label multipla) | `doppia_presa.tex` |
| 7 | Sezione 6.8 Fluent da spostare + diagramma processo | Workflow già nel capitolo Fluent; aggiunto diagramma di flusso TikZ + versione Mermaid | `fluent.tex`, `Mermaid/07_*` |
| 8 | 3.7.1: norma L2 entropia valida solo per bump | Aggiunto paragrafo "Ambito di validità" | `teoria.tex` |
| 9 | Codice troppo vicino al margine / stile incoerente | Stile `base` con margini/padding; applicato `style=fortran` ai listing di `Codice_CFD.tex` | `grafica.tex`, `Codice_CFD.tex` |
| 10 | Riferimenti ai report degli anni precedenti | Rimossi/riformulati | `bump.tex` |

### Discussioni teoriche aggiunte
- Definizione formale del **rapporto di diradamento** $r=h_2/h_1>1$ (domanda 23) — `teoria.tex`.
- **Grafico dell'ordine di convergenza** (Roe vs Lax–Friedrichs, regione asintotica), domanda 22 — `teoria.tex`.
- Nota su **quando usare l'ordine teorico** in Richardson — `teoria.tex`.

## Fase 5 — History e archiviazione
- Creata questa cartella `History/` con changelog e copia archiviata del file dubbi.

---

## Note / materiale mancante riscontrato
- Inizialmente mancavano l'immagine della struttura Notion e l'export Notion (INPUT 1–2):
  forniti dall'utente (cartella `Notion/`) durante l'esecuzione.
- La pagina Notion *Reacting Flows* era vuota: popolata tramite `markdown/teoria_reacting_flows.md`.

## Possibili follow-up
- Validare la suddivisione Notion proposta per WENO/DG (domanda 7) e spostare i contenuti.
- Renderizzare le mappe Mermaid in PDF (`mermaid-cli`) e includerle nel report se desiderato.
- Verificare visivamente il nuovo schema TikZ della doppia rampa nel PDF compilato.
