# Fluidodinamica Computazionale dei Sistemi Propulsivi

Repository del progetto d'esame del corso **Fluidodinamica Computazionale dei Sistemi
Propulsivi** (Politecnico di Torino, Ing. Aerospaziale).
Contiene il **solutore Euler 2D** sviluppato a lezione, i **casi di studio** (bump, presa a
doppia rampa, paletta LS59), le **analisi in ANSYS Fluent** e l'**ottimizzazione con
modeFRONTIER**, oltre al **report LaTeX** e al materiale teorico per lo studio.

**Autori:** Gabriel Cialdini · Fabiola D'Avino · Francesco Farella

---

## Struttura della repository

| Cartella | Contenuto |
|---|---|
| `Euler2D/` | Solutore CFD Euler 2D in Fortran (volumi finiti, schemi Lax–Friedrichs e Roe) |
| `Latex/` | Sorgenti del report (`main.tex` + capitoli). PDF compilato: `Latex/main.pdf` |
| `Bump/` | Caso condotto con bump: mesh, dati e analisi di convergenza (`Bump/conv/`) |
| `Rampa/` | Caso presa a doppia rampa: geometrie `.geo`, mesh, input, dati sperimentali |
| `Paletta/` | Caso paletta di turbina LS59 |
| `Postprocessing/` | Notebook Jupyter per convergenza e confronti |
| `Fluent/` | Progetti e risultati ANSYS Fluent (LS59, doppia rampa) |
| `Ottimizzazione/` | Ottimizzazione aerodinamica con modeFRONTIER |
| `Images/` | Figure usate nel report |
| `teoria/` | Appunti teorici del corso + sintesi e simulazioni d'esame (immagini in `teoria/images/`) |
| `Mermaid/` | Mappe mentali del corso (formato Mermaid) |
| `Debug/` | Casi di riferimento per verificare il solutore |
| `History/` | Archivio di prompt, dubbi e correzioni della fase di stesura |
| `Skill/` | Skill/istruzioni usate per generare il materiale |
| `0-Reference/` | Materiale di riferimento (codice del docente, dispense) |

---

## Compilare il report

```bash
cd Latex
latexmk -pdf main.tex      # produce main.pdf
```

## Compilare ed eseguire il solutore Euler 2D

```bash
cd Euler2D
mingw32-make rebuild       # compila euler2d.exe (richiede gfortran)
```

L'eseguibile legge `input.txt`, `inlet.txt`, `outlet.txt` dalla cartella di lavoro e una mesh
Gmsh (`.msh`, versione 2.2). Esempio di prova nella cartella `Debug/Debug_1/` (bump):

```bash
cp Euler2D/euler2d.exe Debug/Debug_1/ && cd Debug/Debug_1 && ./euler2d.exe
```

- Lo **schema numerico** (Lax–Friedrichs / Roe) si seleziona in `Euler2D/compute_fluxes.f90`
  (commentando/scommentando la chiamata corrispondente) e ricompilando.
- Output: file Tecplot `.plt` in `SIM_OUTPUT_*`, norma dell'entropia e residui a schermo.

## Casi di studio

| Caso | Regime | Mach ingresso | Note |
|---|---|---|---|
| Bump | subsonico | 0.3 | analisi di convergenza (Roe vs Lax–Friedrichs, norma entropia) |
| Presa a doppia rampa | supersonico | 3.0 | due urti obliqui, convergenza con Roe |
| Paletta LS59 | transonico | 0.5 | cascata di turbina, uscita supersonica |

---

## Note

- File pesanti (eseguibili, output `.plt`, mesh Gmsh, ambienti) sono esclusi via `.gitignore`
  e rigenerabili dai sorgenti.
- Il materiale in `teoria/` è pensato anche per essere incollato in Notion (blocchi *toggle* e
  formule LaTeX); i chiarimenti/dubbi sono integrati nella teoria come note, mentre le sezioni di
  *simulazione d'esame* restano separate.
- La verifica del solutore (convergenza del bump rigenerata, campi della doppia rampa,
  consistenza con i casi di `Debug/`) è documentata in `History/` e in `Bump/conv/README.md`.
