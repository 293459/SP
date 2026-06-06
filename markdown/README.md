# Markdown — Risposte teoriche e simulazione d'esame

Cartella con le risposte a tutte le domande del file `SP dubbi.txt`, in formato **simulazione
d'esame** pronto per Notion: ogni domanda è un **toggle** (`<details>/<summary>`) e la risposta è
discorsiva con **parole chiave in grassetto**. Le formule sono in LaTeX (`$...$` inline,
`$$...$$` display), renderizzabili dai blocchi formula di Notion.

## File

| File | Contenuto | Pagina Notion di destinazione |
|---|---|---|
| `teoria_reacting_flows.md` | Teoria domande **1–6** (flussi reagenti) | **Reacting Flows** (attualmente vuota) |
| `teoria_metodi_numerici.md` | Teoria domande **7–9** (collocazione metodi, upwind/centrati) | **Numerical Methods** / **Finite Volumes Schemes** |
| `report_QA.md` | **26 domande** sul report (paletta, doppia rampa, Fluent, convergenza) | sezione **Simulazione domande d'esame** della root SP |
| `teoria_turbomacchine.md` | Teoria + esame domande **1–5** (interfaccia statore–rotore: mixing plane, sliding mesh, corocroniche, tempo inclinato) | pagina **Turbomacchine** (lezione 06-04) |
| `teoria_modelli_ordine_ridotto.md` | Teoria + esame domande **6–7** (ROM, POD, RIC, training offline/online) | pagina **ROM / Reduced Order Models** (lezione 06-04) |
| `teoria_flussi_rarefatti.md` | Teoria + esame domande **9–16** (Knudsen, DSMC/Monte Carlo, modelli collisionali, requisiti) | pagina **Flussi Rarefatti** (lezione 06-04) |

## Come incollare in Notion

1. Apri la pagina Notion di destinazione.
2. Incolla il contenuto markdown: Notion converte automaticamente i blocchi `<details>` in
   **toggle list** e le formule `$$...$$` in blocchi equazione.
3. In alternativa, per ogni toggle: crea un blocco *toggle*, incolla la domanda nel titolo e la
   risposta all'interno.

> Nota: alcune risposte contengono anche snippet LaTeX/TikZ (es. il grafico dell'ordine di
> convergenza, Domanda 22) pensati per essere inseriti direttamente nel report.
