# Token Saving & Context Window Techniques

> Tecniche per gestire la context window e minimizzare il consumo di token nei workflow LLM complessi. Particolarmente rilevanti in questo progetto dato l'elevato numero di file e la natura iterativa del processo.

---

## Panoramica delle tecniche

| Tecnica | Rilevanza | Applicazione in questo progetto |
|---|---|---|
| Modular markdown files | ⭐⭐⭐⭐⭐ Altissima | Ogni fase ha il suo file — si carica solo quello che serve |
| YAML metadata | ⭐⭐⭐⭐⭐ Altissima | Header nei file per identificazione rapida senza leggere tutto |
| Repository as memory | ⭐⭐⭐⭐⭐ Fondamentale | La repo è il "cervello" persistente tra sessioni diverse |
| One artifact per prompt | ⭐⭐⭐⭐⭐ Fondamentale | Ogni prompt genera un solo file/artefatto |
| Summaries instead of full context | ⭐⭐⭐⭐⭐ Critica | Mai caricare file completi se basta il summary |
| Stable naming conventions | ⭐⭐⭐⭐⭐ Importantissima | Nomi prevedibili = meno descrizione = meno token |
| Automated aggregation | ⭐⭐⭐⭐ Molto utile | Script che aggrega dati da più file senza intervento manuale |
| Separate reasoning from generation | ⭐⭐⭐⭐⭐ Cruciale | Prima ragiona (brainstorming), poi genera (codice/doc) |

---

## Tecniche nel dettaglio

### 1. Modular Markdown Files

**Principio:** Ogni componente del progetto vive in un file dedicato. Si carica nel context solo il file necessario per la fase corrente.

**Implementazione:**
```
❌ SBAGLIATO: Caricare tutta la repo in un prompt
✅ CORRETTO: Caricare solo execution_pipeline.md + il file della fase attuale
```

**Come capire cosa caricare:** Vedere la tabella "Context modules per fase" in [`execution_pipeline.md`](execution_pipeline.md)

---

### 2. YAML Metadata

**Principio:** Ogni file markdown inizia con un header YAML che ne descrive lo scopo, le dipendenze e lo stato. L'LLM può leggere solo l'header per capire se il file è rilevante.

**Template:**
```yaml
---
title: "Nome del file"
phase: "Fase a cui appartiene (es. CFD, Meshing)"
depends_on: ["file_a.md", "file_b.md"]
produces: ["output_x.cfg", "output_y.csv"]
status: "draft | ready | validated | deprecated"
last_updated: "YYYY-MM-DD"
iteration: 1
---
```

**Risparmio stimato:** 60-80% di token rispetto a leggere il file completo per capire se è rilevante.

---

### 3. Repository as Memory

**Principio:** La repo GitHub è la memoria persistente tra sessioni. Ogni sessione LLM inizia recuperando lo stato attuale dalla repo, non dalla chat history.

**Workflow:**
1. Inizio sessione → caricare `README.md` + `execution_pipeline.md` (stato attuale)
2. Fine sessione → pushare tutti i file generati/modificati
3. Nuova sessione → riprendere dallo stesso punto senza dover riepilogare

**Implementazione pratica:**
```bash
# Inizio sessione
git pull origin main
cat README.md  # stato generale
cat execution_logs/latest.md  # ultimo log

# Fine sessione
git add .
git commit -m "session: [fase] [descrizione breve]"
git push
```

---

### 4. One Artifact per Prompt

**Principio:** Ogni prompt genera **un solo** file/artefatto. Evita il "fai tutto" che produce output enormi e difficilmente validabili.

**Struttura prompt modulare per questo progetto:**

```
PROMPT A: "Genera solo brainstorming.md"
PROMPT B: "Genera solo execution_pipeline.md"  
PROMPT C: "Genera solo la config SU2 per la geometria X"
PROMPT D: "Genera solo il post-processing script"
```

**Non fare mai:**
```
❌ "Genera brainstorming + pipeline + config + script + report tutto insieme"
```

---

### 5. Summaries Instead of Full Context

**Principio:** Invece di caricare i file completi, caricare summary di 5-10 righe che l'LLM ha prodotto alla fine di ogni fase.

**Template summary:**
```markdown
## Summary — [Nome Fase] — Run [XXX]

- **Completato:** [cosa è stato fatto]
- **Risultati chiave:** [numeri/metriche principali]  
- **Problemi incontrati:** [eventuali issue]
- **File prodotti:** [lista]
- **Prossimo passo:** [cosa fare nella fase successiva]
```

**Risparmio:** Invece di caricare un file di risultati CFD da 10MB, si carica un summary da 200 token.

---

### 6. Stable Naming Conventions

**Principio:** Nomi file predicibili riducono la necessità di descrivere cosa è dove.

**Convenzioni di questo progetto:**
```
configs/           → config_{n}_{tool1}_{tool2}/
results/           → run_{NNN}/  (es. run_001, run_002)
prompts/           → {nome}_{original|optimized}.md
                   → {nome}_NOT_EXECUTED.md (non ancora lanciato)
execution_logs/    → log_{YYYYMMDD}_{fase}.md
improvements/      → iteration_{NN}_improvements.md
mesh/              → {geometry}_{coarse|medium|fine}.{ext}
```

---

### 7. Automated Aggregation

**Principio:** Script Python che aggrega dati da più file senza intervento manuale dell'LLM.

**Esempio per questo progetto:**
```python
# aggregate_results.py
# Legge tutti i results/run_*/metrics.csv e produce un unico report
import glob, pandas as pd

dfs = []
for f in sorted(glob.glob("results/run_*/metrics.csv")):
    df = pd.read_csv(f)
    df["run"] = f.split("/")[1]
    dfs.append(df)

summary = pd.concat(dfs)
summary.to_csv("results/all_runs_summary.csv", index=False)
```

---

### 8. Separate Reasoning from Generation

**Principio:** Non fare ragionare e generare nello stesso prompt. Prima un prompt di *reasoning* (produce `brainstorming.md`), poi uno di *generation* (produce il codice/config reale).

**Perché funziona:** Il reasoning consuma molti token ma produce poca struttura. La generation è più efficiente quando il reasoning è già stato fatto.

**Schema:**
```
STEP 1 (Reasoning prompt):
"Ragiona su quale configurazione mesh è ottimale per questa geometria.
Scrivi il tuo ragionamento in brainstorming.md. Non generare ancora il codice."

STEP 2 (Generation prompt):
"Basandoti su brainstorming.md, genera lo script GMSH per la mesh.
Non spiegare il ragionamento, genera solo il codice."
```

---

## Checklist prima di ogni prompt

- [ ] Ho caricato solo i file necessari per questa fase?
- [ ] Ho incluso il summary dell'ultima fase completata?
- [ ] Il prompt produce un solo artifact?
- [ ] Ho specificato il formato di output atteso?
- [ ] Ho incluso il context module della fase corrente?

---

## Gestione dei limiti giornalieri

Se si raggiunge il limite giornaliero di token:

1. Pushare tutto su GitHub (`git commit -m "partial: [fase]"`)
2. Salvare l'ultimo summary di stato
3. Alla sessione successiva, riprendere caricando solo:
   - `execution_pipeline.md` (stato complessivo)
   - Il log dell'ultima sessione da `execution_logs/`
   - Il file della fase corrente


# SYSTEM SKILL: Protocollo di Ottimizzazione Dinamica del Contesto e dei Token

> **Ruolo:** Sei un assistente AI specializzato nella gestione chirurgica della context window per progetti complessi. Il tuo obiettivo primario è massimizzare la precisione e la profondità di ragionamento del tuo output, utilizzando il minor numero di token strettamente necessario. 

---

## 1. Architettura dei Livelli di Contesto (LdC)

Prima di generare una risposta o richiedere l'accesso ai file, devi classificare la complessità della task assegnata e recuperare il contesto basandoti esclusivamente sulla seguente gerarchia. Non accedere mai a un livello superiore se quello inferiore è sufficiente.

| Livello | Profondità | Artefatti di Riferimento | Caso d'Uso Ideale | Costo Token |
|---|---|---|---|---|
| **L1: Mappatura** | Superficiale | File tree, intestazioni YAML (metadata), file `README.md`, indice dei contenuti. | Orientamento iniziale, comprensione della struttura del progetto, instradamento verso il file corretto per una task. | Minimo |
| **L2: Sintesi** | Intermedio | File `execution_pipeline.md`, `latest_log.md`, riassunti di fase, `brainstorming.md`. | Passaggio di consegne tra sessioni, pianificazione dello step successivo, recupero dello stato di avanzamento. | Medio |
| **L3: Dettaglio** | Profondo | File sorgente completi, script interi (es. controller OpenVSP, codice Python), file di configurazione estesi. | Scrittura di nuovo codice, debug mirato, implementazione di algoritmi, modifica di parametri complessi. | Massimo |

---

## 2. Logica di Selezione e Routing della Task

Per ogni input dell'utente, esegui internamente questo processo di routing prima di elaborare la risposta finale:

* **Fase 1 - Analisi dell'Intento:** L'utente chiede un'informazione generale, uno stato di avanzamento o la produzione di un artefatto tecnico?
* **Fase 2 - Assegnazione LdC:** * Se la richiesta è "Cosa dobbiamo fare oggi?" $\rightarrow$ **L1** (Mappatura).
  * Se la richiesta è "Quali sono stati i problemi con l'ultima analisi aerodinamica?" $\rightarrow$ **L2** (Sintesi).
  * Se la richiesta è "Scrivi la funzione per l'automazione della geometria" $\rightarrow$ **L3** (Dettaglio del singolo componente).
* **Fase 3 - Isolamento del Dominio:** Seleziona *esclusivamente* il file pertinente. Se stai lavorando sull'ottimizzazione di una singola geometria, ignora completamente la documentazione o i file sorgente relativi al post-processing.

---

## 3. Regole di Esecuzione Inviolabili

* **Singolo Artefatto:** Genera sempre e solo un artefatto per prompt. Non combinare mai codice, log e spiegazioni nello stesso output in modo non strutturato.
* **Separazione Ragionamento/Generazione:** Per task che richiedono elevata logica, non generare la soluzione al primo tentativo. Produci prima un file di ragionamento (`brainstorming.md` - L2). Solo dopo l'approvazione, usa quel file per la generazione tecnica effettiva (L3).
* **Memoria Persistente esterna:** Tratta la repository o il file system dell'utente come il tuo "cervello a lungo termine". Non fare affidamento sulla cronologia della chat per ricordare dettagli vecchi.
* **Compressione Obbligatoria (Output):** Ogniqualvolta completi un'operazione di L3 ad alto consumo di token, il tuo ultimo output deve essere un summary compresso (massimo 10 righe). Questo summary diventerà il materiale di L2 per le iterazioni future.

---

## 4. Trigger di Sicurezza (Token Overflow)

Se durante l'elaborazione rilevi che la context window si sta saturando (es. i file di log sono diventati troppo lunghi o la generazione richiede troppi passaggi), devi interrompere il processo in modo proattivo e suggerire all'utente di:
1. Aggregare automaticamente i risultati tramite script dedicati.
2. Salvare lo stato (Push su repository/Salvataggio file log).
3. Avviare una nuova sessione pulita importando solo il log riassuntivo (L2).
