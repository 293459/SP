# Teoria

Appunti teorici del corso **Fluidodinamica Computazionale dei Sistemi Propulsivi**, nati
dall'unione dei vecchi export Notion e delle sintesi in formato Q&A. Tutte le immagini stanno in
[`images/`](images/).

## Convenzioni

- Ogni file è organizzato in **capitoli `## `** e ogni argomento è racchiuso in una **toggle list
  collassabile** (`<details>` / `<summary>`): chiudendo il toggle il contenuto si compatta, così si
  ha sempre la vista d'insieme dei vari punti e si apre solo ciò che interessa.
- I **chiarimenti / dubbi** sono **integrati direttamente nella teoria** come note tra virgolette
  (`>` blockquote), così da non spezzare il filo del discorso.
- Le sezioni di **simulazione d'esame / quiz / esercizi** restano in **toggle dedicati**.
- Le **formule** sono in LaTeX (`$...$` inline, `$$...$$` display); le immagini che erano solo
  formule sono state trascritte in LaTeX per alleggerire il progetto. Restano come immagini solo
  **diagrammi, grafici, whiteboard e screenshot** (con nomi descrittivi).

## File

| File | Contenuto |
|---|---|
| `bilancio.md` | Leggi di conservazione, problemi ellittici/iperbolici, sistema di Eulero, modelli scalari/vettoriali |
| `caratteristiche.md` | Metodo delle caratteristiche, linee caratteristiche, invarianti di Riemann, Rankine–Hugoniot (regime supersonico) |
| `meshing.md` | Tipologie di mesh, generazione, metriche, ALE |
| `schemi_volumi_finiti.md` | Metodo dei volumi finiti, Godunov/Riemann, flux splitting, Roe |
| `metodi_numerici.md` | Collocazione dei metodi nel corso, upwind vs centrati (+ simulazione d'esame) |
| `metodi_numerici_ode.md` | Errori, consistenza/stabilità/convergenza, Runge-Kutta, stiffness, approfondimenti HPC/WENO/DG |
| `turbolenza.md` | RANS/URANS, cascata di Kolmogorov, LES (filtri, SGS, Smagorinsky dinamico), DES/DDES |
| `turbomacchine.md` | Interfaccia statore–rotore: mixing plane, sliding mesh, corocroniche, tempo inclinato (lez. 06-04) |
| `modelli_ordine_ridotto.md` | ROM e POD: snapshot, modi, RIC, training offline/online (lez. 06-04) |
| `flussi_rarefatti.md` | Numero di Knudsen, DSMC/Monte Carlo, modelli collisionali, requisiti numerici (lez. 06-04) |
| `reacting_flows.md` | Flussi reagenti: variabili, mixing, premiscelati/non, metodo di proiezione |
| `report_QA.md` | **Simulazione d'esame** — 26 domande sul report (paletta, doppia rampa, Fluent, convergenza) |
