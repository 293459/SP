# Skill: Gestione Avanzata dei Processi ed Ottimizzazione delle Risorse (Automazione IA)

## Descrizione
Capacità di pianificare, eseguire e monitorare flussi di lavoro complessi e automazioni basate su Intelligenza Artificiale. Questa competenza è progettata per ottimizzare l'uso dei token, rispettare rigorosamente i limiti di quota (Rate Limits), prevenire conflitti nell'esecuzione parallela e garantire la massima integrità dei dati attraverso strategie predittive di checkpointing.

---

## Direttive Core di Esecuzione

### 1. Gestione dei Limiti di Quota (Rate Limiting & Throttling)
* **Sospensione e Ripresa Automatica:** In caso di esaurimento dei token o del budget di chiamate API disponibili (es. errore HTTP 429 / Rate Limit Exceeded), il sistema non deve interrompere definitivamente il processo né lanciare un'eccezione fatale.
* **Strategia di Attesa:** L'agente deve calcolare il tempo di reset della quota (analizzando gli header della risposta API o applicando tempi di attesa standard), entrare in modalità di sospensione attiva (`sleep`) e **riprendere automaticamente l'esecuzione del prompt** esattamente dal punto di interruzione non appena la quota si è ricaricata.

### 2. Schedulazione Intelligente (Execution Scheduling)
* **Esecuzione Fuori Picco:** Se l'infrastruttura, il sistema operativo o la piattaforma ospitante lo supportano, configurare il sistema per pianificare l'esecuzione dei task più energivori o a consumo intensivo di token in finestre temporali specifiche (ad esempio, **durante le ore notturne** o in fasce a basso traffico).
* **Ottimizzazione dei Costi:** Utilizzare questa modalità per sfruttare eventuali tariffe ridotte (come le Batch API dei provider LLM) o per evitare di saturare le quote durante l'orario di lavoro principale.

### 3. Concorrenza e Parallelismo Sicuro (Race Condition Prevention)
* **Isolamento dei Processi:** Quando più task, thread o agenti operano in parallelo sul medesimo repository o database, i flussi di lavoro devono essere rigorosamente isolati. **I processi non devono "pestarsi i piedi a vicenda"**.
* **Integrità dei Dati:** Implementare meccanismi di blocco dei file (`file locking`), partizionamento dei dati di input/output o ambienti di esecuzione (`sandbox` / branch temporanei) separati, garantendo che la scrittura o la lettura da parte di un thread non corrompa o sovrascriva il lavoro di un altro.

### 4. Checkpointing Preventivo e Allineamento Utente
* **Analisi Predittiva della Quota:** Prima di avviare un task lungo, complesso o sequenziale, verificare la quota residua disponibile.
* **Gestione del Rischio:** Se il consumo stimato del task è superiore alla quota rimasta (o molto vicino al limite), il sistema **non deve avviare il processo alla cieca** per poi lasciarlo interrotto a metà.
* **Azione:** Creare un checkpoint dello stato attuale, congelare l'esecuzione e **notificare immediatamente l'utente** con un report chiaro (es. *"Quota insufficiente per completare il task di ottimizzazione; salvato checkpoint al punto X. Attendere il reset automatico o procedere con override manuale?"*).

---

## Funzionalità Avanzate Consigliate (Estensioni per l'Automazione)

### 5. Gestione degli Errori Noti e Self-Healing (Autocorrezione)
* **Errori di Parsing:** Se l'output dell'IA non rispetta il formato strutturato richiesto (es. un JSON malformato o un blocco di codice incompleto), il sistema deve intercettare l'errore ed eseguire una micro-chiamata di correzione (*self-correction prompt*) fornendo l'errore del linter/parser per correggere l'output prima di dichiarare il fallimento del task.
* **Resilienza di Rete:** Includere una politica di `Retry` con backoff esponenziale per la connessione alle API di terze parti (es. tool di scraping, webhook o commit remoti).

### 6. Logging Tracciabile e Stato Trasparente
* **Registro di Stato Atomico:** Ogni automazione deve produrre un file di log snello ma atomico delle operazioni (es. `[START]`, `[CHECKPOINT_SAVED]`, `[PAUSED_FOR_QUOTA]`, `[SUCCESS]`).
* **Ripristino post-Crash:** In caso di crash hardware o interruzione del server, il sistema deve essere in grado di leggere l'ultimo log e ripartire dall'ultimo checkpoint valido senza duplicare i task già eseguiti o rischiare commit doppi.

### 7. Ottimizzazione Dinamica del Contesto (Context Window Slimming)
* **Sfoltimento della Memoria:** Nei task a ciclo continuo o iterazioni lunghe, l'agente deve riassumere periodicamente il contesto passato ed eliminare i dettagli superflui per evitare il "gonfiamento" della finestra dei token, mantenendo le risposte rapide, focalizzate sull'obiettivo e riducendo lo spreco di risorse.
