# SP — Esercitazioni di Fluidodinamica Computazionale dei Sistemi Propulsivi

> Sviluppo e analisi di un solutore CFD 2D per le equazioni di Eulero su griglia non strutturata, applicato a geometrie propulsive canoniche.

---

## Indice

- [Struttura del repository](#struttura-del-repository)
- [Software richiesto](#software-richiesto)
- [Estensioni VSCode raccomandate](#estensioni-vscode-raccomandate)
- [Quick Start](#quick-start)
- [Test case](#test-case)
- [Architettura del solutore](#architettura-del-solutore)
- [Post-processing](#post-processing)
- [Report LaTeX](#report-latex)

---

## Struttura del repository

```
SP/
├── .gitignore
├── .vscode/                          # Configurazione VSCode (tasks, settings, extensions)
│   ├── extensions.json
│   ├── settings.json
│   └── tasks.json
│
├── 0-Reference/                      # Materiale di riferimento (paper, dispense)
│
├── Euler2D/                          # Solutore 2D Euler — Fortran
│   ├── strutture.f90                 # Definizione dei tipi derivati (tipo_elemento, tipo_nodo,
│   │                                 #   tipo_interfaccia, …)
│   ├── Variabili.f90                 # Dichiarazione variabili globali
│   ├── costanti.f90                  # Costanti fisiche e numeriche
│   ├── main.f90                      # Programma principale — ciclo temporale
│   ├── leggi_gmsh.f90                # Lettore mesh in formato Gmsh (.msh v4)
│   ├── calcola_area.f90              # Calcolo aree degli elementi
│   ├── calcola_baricentri.f90        # Calcolo baricentri degli elementi
│   ├── vicini.f90                    # Costruzione della connettività tra elementi vicini
│   ├── BCs.f90                       # Condizioni al contorno (parete, ingresso, uscita, …)
│   ├── calcola_flussi.f90            # Flussi numerici (Roe / Rusanov)
│   ├── calcola_derivate.f90          # Ricostruzione dei gradienti (Green-Gauss / LSQ)
│   ├── calcola_passo_temporale.f90   # Passo temporale locale basato su CFL
│   ├── output_tecplot.f90            # Scrittura output in formato Tecplot ASCII (.dat)
│   └── Makefile                      # Build system — compilazione con gfortran
│
├── Bump/                             # Test case 1 — bump transonico
│   ├── bump.geo                      # Script geometria Gmsh
│   ├── bump.msh                      # Mesh generata (può essere rigenerata da bump.geo)
│   └── post/                         # Script post-processing (Gnuplot, Python)
│
├── Rampa/                            # Test case 2 — urto obliquo su rampa
│   ├── rampa.geo
│   ├── rampa.msh
│   └── post/
│
├── Paletta/                          # Test case 3 — paletta/profilo alare
│   ├── paletta.geo
│   ├── paletta.msh
│   └── post/
│
└── Latex/                            # Report completo del progetto
    ├── main.tex
    ├── capitoli/
    └── figure/
```

> **Nota:** Il binario di Gmsh non è incluso nel repository. Scaricarlo autonomamente come indicato nella sezione [Software richiesto](#software-richiesto).

---

## Software richiesto

| Software | Versione minima | Utilizzo | Link |
|---|---|---|---|
| **gfortran** (GCC) oppure **Intel oneAPI ifort/ifx** | GCC ≥ 10 | Compilazione del solutore Fortran | [gcc.gnu.org](https://gcc.gnu.org) / [intel.com/oneapi](https://www.intel.com/content/www/us/en/developer/tools/oneapi/overview.html) |
| **GNU Make** | ≥ 4.3 | Build system | incluso in GCC toolchain |
| **Gmsh** | ≥ 4.13 | Generazione e visualizzazione delle mesh | [gmsh.info](https://gmsh.info/) |
| **Python** | ≥ 3.10 | Script di post-processing e analisi | [python.org](https://www.python.org/) |
| **Gnuplot** | ≥ 5.4 | Plotting residui, soluzioni 1D | [gnuplot.info](http://www.gnuplot.info/) |
| **Julia** | ≥ 1.9 | Script di analisi numerica aggiuntivi | [julialang.org](https://julialang.org/) |
| **TeX Live** o **MiKTeX** | recente | Compilazione del report LaTeX | [tug.org/texlive](https://tug.org/texlive/) |
| **ParaView** | ≥ 5.11 | Visualizzazione output Tecplot (reader nativo) | [paraview.org](https://www.paraview.org/) |

### Installazione Gmsh

```bash
# Linux (apt)
sudo apt install gmsh

# macOS (Homebrew)
brew install gmsh

# Windows
# Scaricare il binario da https://gmsh.info/#Download
# Aggiungere la cartella gmsh/bin al PATH di sistema
```

### Dipendenze Python

```bash
pip install -r Euler2D/requirements.txt
# oppure
pip install numpy matplotlib scipy
```

---

## Estensioni VSCode raccomandate

Le estensioni elencate in `.vscode/extensions.json` sono installabili automaticamente alla prima apertura del workspace.

| Estensione | ID | Utilizzo |
|---|---|---|
| **Modern Fortran** | `fortran-lang.linter-gfortran` | Syntax highlighting, diagnostics, hover documentation per Fortran |
| **LaTeX Workshop** | `James-Yu.latex-workshop` | Compilazione e preview in-editor del report LaTeX |
| **Python** | `ms-python.python` | Supporto Python con IntelliSense e debugging |
| **Julia** | `julialang.language-julia` | Supporto linguaggio Julia |
| **Gnuplot** | `MarioSchwalbe.gnuplot` | Syntax highlighting per script `.gp` |
| **GitLens** | `eamodio.gitlens` | Cronologia Git integrata nell'editor |

> Per installare tutte le estensioni raccomandate: `Ctrl+Shift+P` → *Extensions: Show Recommended Extensions* → installa tutto.

---

## Quick Start

### 1. Clonare il repository

```bash
git clone https://github.com/293459/SP.git
cd SP
```

### 2. Generare la mesh con Gmsh

```bash
# Esempio con il test case Bump
gmsh Bump/bump.geo -2 -o Bump/bump.msh
```

Il flag `-2` forza la generazione di una mesh 2D. Il file `.msh` viene salvato nella cartella del test case.

### 3. Compilare il solutore

```bash
cd Euler2D
make
```

Il `Makefile` gestisce automaticamente le dipendenze tra moduli (l'ordine di compilazione è: `costanti` → `strutture` → `Variabili` → … → `main`). L'eseguibile prodotto è `euler2d`.

Per compilare in modalità debug (con bound checking):

```bash
make debug
```

### 4. Eseguire il solutore

```bash
./euler2d ../Bump/bump.msh
```

L'output viene scritto nella directory del test case in formato Tecplot ASCII (`.dat`), leggibile direttamente da ParaView o VisIt con il reader Tecplot.

### 5. Post-processing

```bash
# Residui — Gnuplot
gnuplot Bump/post/residui.gp

# Analisi soluzione — Python
python Bump/post/analisi.py

# Confronto con soluzione analitica — Julia (dove applicabile)
julia Bump/post/confronto.jl
```

---

## Test case

### Bump transonico (`Bump/`)

Flusso transonico su un bump sinusoidale in un canale. Permette di verificare la corretta cattura dell'onda d'urto normale e la conservazione della massa. Confronto con la soluzione di riferimento AGARD.

| Parametro | Valore |
|---|---|
| Mach ingresso | 0.8 |
| Tipo urto | normale |
| Validazione | soluzione AGARD |

### Urto obliquo — Rampa (`Rampa/`)

Flusso supersonico su una rampa che genera un urto obliquo. La soluzione analitica è disponibile tramite le relazioni di Rankine-Hugoniot per onda d'urto obliqua, permettendo un confronto esatto.

| Parametro | Valore |
|---|---|
| Mach ingresso | 2.0 |
| Angolo rampa | 15° |
| Validazione | soluzione analitica R-H |

### Paletta / Profilo alare (`Paletta/`)

Flusso attorno a un profilo alare (o paletta di turbina). Test case più complesso: la mesh è a corpo immerso con condizioni al contorno di parete solida (slip wall). Nessuna soluzione analitica esatta — validazione tramite confronto con dati di letteratura.

---

## Architettura del solutore

Il solutore implementa un metodo ai volumi finiti esplicito al primo ordine (con estensione al secondo ordine tramite ricostruzione lineare a pezzi) per le equazioni di Eulero 2D in forma conservativa:

$$\frac{\partial \mathbf{U}}{\partial t} + \nabla \cdot \mathbf{F}(\mathbf{U}) = 0$$

Il vettore delle variabili conservative è:

$$\mathbf{U} = (\rho E,\; \rho,\; \rho u,\; \rho v)^T$$

### Pipeline di esecuzione

```
leggi_gmsh        →  Lettura mesh .msh (nodi, elementi, boundary tags)
calcola_area      →  Aree degli elementi
calcola_baricentri→  Baricentri per la ricostruzione
vicini            →  Connettività elemento–elemento e elemento–bordo
────────────────────────────────────────────────────────────────
loop temporale (RK esplicito):
  BCs             →  Imposizione condizioni al contorno
  calcola_derivate→  Ricostruzione gradiente (Green-Gauss)
  calcola_flussi  →  Flusso numerico agli spigoli (Roe/Rusanov)
  calcola_passo_t →  Passo temporale locale (CFL)
  aggiorna U      →  Aggiornamento soluzione
────────────────────────────────────────────────────────────────
output_tecplot    →  Scrittura soluzione su file .dat
```

### Tipi derivati principali (`strutture.f90`)

| Tipo | Campi principali | Descrizione |
|---|---|---|
| `tipo_nodo` | coordinate, indice | Nodo della mesh |
| `tipo_elemento` | nodi, area, baricentro, vicini, U | Cella del volume finito |
| `tipo_interfaccia` | normale, lunghezza, elem\_L, elem\_R | Spigolo interno tra due celle |
| `tipo_bordo` | tipo\_BC, elementi associati | Segmento di bordo con tag BC |

---

## Post-processing

| Tool | File | Output |
|---|---|---|
| **Gnuplot** | `post/residui.gp` | Convergenza della norma L2 dei residui |
| **Gnuplot** | `post/mach.gp` | Campo di Mach lungo la parete/asse |
| **Python** | `post/analisi.py` | Confronto pressione con soluzione di riferimento |
| **Julia** | `post/confronto.jl` | Verifica conservazione entità fisiche (massa, energia) |
| **ParaView** | — | Visualizzazione 2D del campo soluzione da file `.dat` |

---

## Report LaTeX

Il report completo del progetto si trova in `Latex/`. Per compilarlo:

```bash
cd Latex
pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

Oppure tramite LaTeX Workshop in VSCode (`Ctrl+Alt+B`).

---

## Nota sulla licenza

Repository accademico per uso interno al corso. Nessuna licenza open source associata.
