# Flashcards Anki — SP (Fluidodinamica Computazionale dei Sistemi Propulsivi)

Mazzo di ripasso generato dai file di `teoria/`. **310 carte** (239 `FORMULE` + 71 `PROOF`).

## File

- **`SP_flashcards.tsv`** — file unico da importare in Anki (tutte le carte).
- `*_formule.tsv` / `*_proof.tsv` — sorgenti per capitolo (utili se vuoi importarne solo alcuni).
- **`caratteristiche_aggiunte.tsv`** — *solo* le 15 carte nuove del capitolo caratteristiche
  (10 `FORMULE` + 5 `PROOF`, incl. la matrice $A'$ e la sua dimostrazione). Importa **questo** per
  aggiungerle senza rifare tutto: Anki fa il
  match sul **primo campo**, quindi non duplica le esistenti. In alternativa puoi ri-importare
  `SP_flashcards.tsv` (con "Update existing notes when first field matches"): aggiorna le esistenti
  e aggiunge le nuove.

## Formato

Tre campi separati da **TAB**:

```
Fronte <TAB> Retro <TAB> Tag
```

- **Fronte** = nome della formula / "Dimostra: …".
- **Retro** = formula o passaggi in **LaTeX MathJax** (`\( … \)` inline, `\[ … \]` display) — Anki li renderizza nativamente.
- **Tag** = tipo + capitolo, es. `FORMULE turbolenza` oppure `PROOF schemi_volumi_finiti`.

## Come importare in Anki

1. *File → Importa…* e seleziona `SP_flashcards.tsv`.
2. **Field separator: Tab**.
3. Mappa: campo 1 → *Front*, campo 2 → *Back* (tipo nota **Basic**).
4. **Tags**: imposta la terza colonna come *Tags* (in Anki: "Tag" → colonna 3), così ogni carta riceve sia il tipo (`FORMULE`/`PROOF`) sia il capitolo.
5. Lascia attivo **Allow HTML in fields** (per il MathJax `\(...\)`).

## Filtri utili (ricerca Anki)

- `tag:FORMULE` — solo formule · `tag:PROOF` — solo dimostrazioni.
- `tag:turbolenza` — solo un capitolo · `tag:PROOF tag:turbolenza` — dimostrazioni di turbolenza.

> Le carte sono **generate dall'IA** a partire dagli appunti: ricontrolla le formule critiche prima dell'esame.
