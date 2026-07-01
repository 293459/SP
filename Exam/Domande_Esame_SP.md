# Domande d'Esame — Fluidodinamica Computazionale dei Sistemi Propulsivi (SP)

> Raccolta di **tutte le domande effettivamente proposte all'esame** (prof. Ferrero) finora
> collezionate. Le **domande tipo generate dall'IA** (solo per esercitarsi) sono state spostate
> nel file separato **[`Domande_AI_generate_SP.md`](./Domande_AI_generate_SP.md)** per tenere
> questo file pulito con le sole domande reali.
> Le risposte sono compilate a partire dai file di `teoria/`, dal **report delle esercitazioni**
> (`Latex/*.tex`) e dai dati delle simulazioni.

---

## Modalità d'esame

- **Orale** di circa **30 minuti**.
- **Tre domande**: le **prime due sulla teoria**, l'**ultima sull'esercitazione** (il report).
- Per questo motivo le domande raccolte sulla **teoria** sono molte di più di quelle
  sull'**esercitazione**: a parità di studenti, di teoria ne sono state fatte di più.
- La domanda di esercitazione dura ~10 minuti: un solo punto ben sviluppato (es. l'estrapolazione
  di Richardson sul bump) copre già il tempo; spesso il docente ferma prima e aggiunge un dettaglio.

## Legenda (distinzione visiva)

| Marcatore | Significato |
|---|---|
| 🟦 **[T]** | Domanda di **teoria** — *realmente proposta* all'esame |
| 🟩 **[E]** | Domanda di **esercitazione / report** — *realmente proposta* (sempre **in fondo**) |
| 🤖 **[AI]** | Domanda **generata dall'IA** — *NON proposta davvero* → spostata in [`Domande_AI_generate_SP.md`](./Domande_AI_generate_SP.md) |

> Formato: blocchi *toggle* `<details>` (incollabili in Notion), **parole chiave** in grassetto,
> formule in LaTeX (`$...$` inline, `$$...$$` display). Stessa convenzione di `teoria/`.

---

# 🟦 PARTE TEORICA (domande realmente proposte)

<details>
<summary><strong>🗓️ Domande raccolte agli APPELLI RECENTI (prof. Ferrero) — riepilogo</strong></summary>

> Raccolte dal gruppo del corso. **Ignorate** le domande di un altro corso (prof. *Ferlauto*, che erano
> finite per errore nello stesso gruppo). Confermano/arricchiscono le sezioni sotto.

**Teoria (Ferrero):**
- Equazioni di Eulero (anche **stazionarie**): cosa se ne può dire, **caratteristiche** e **invarianti di Riemann** → *sez. 1, 2*.
- **Differenza Eulero vs RANS** e le **sorgenti di perdite/dissipazione** (Eulero: urti; RANS: urti + **viscosità turbolenta** che si aggiunge a quella molecolare già presente in NS) → *sez. 1, 4, 6*.
- **Problema di Riemann** e **metodo di Godunov**, poi in generale gli **upwind** e le **varianti** (Osher, Roe) → *sez. 3*.
- **Gradienti su griglie non strutturate**: Green–Gauss e **minimi quadrati (con e senza pesi)**; **gradiente all'interfaccia** (sistemi con termine **diffusivo**) → *sez. 3*.
- **Limitatori di pendenza**: schemi di **2° grado** (come si calcola la pendenza, come si **limita**); su **griglie strutturate** perché si usano e come si **scrivono** (almeno **minmod**, poi superbee); **schemi espliciti vs impliciti** → *sez. 3*.
- **Metodi numerici di ordine superiore al 2°** → *sez. 3*.
- **Condizioni al contorno** per Eulero: **uscita supersonica e subsonica** (e condizioni su paletta/parete) → *sez. 2*.
- **Metodo delle caratteristiche per il pistone con moto accelerato** → *sez. 2*.
- **Calcolo dei flussi turbolenti** (differenze, pregi/difetti) e nello specifico la **LES** → *sez. 4*.

**Relazione / esercitazioni (Ferrero):**
- **Convergenza temporale** = norma (es. $L_2$) dei **residui**; commento del **campo di moto** della paletta e **confronto con dati sperimentali**.
- **Doppia rampa:** commentare il **campo di Mach** identificando **urti e strutture**, e **riconoscerle** anche nel grafico della **pressione a parete**.
- **$M_{is}$ (Mach isentropico) a parete** della turbina, **bordo di fuga**, come si **calcola**; **come si ricava** il Mach isentropico e **perché si chiama isentropico**.
- **Causa di dissipazione e caduta di $p_{tot}$ nelle RANS**.
- **Ottimizzazione:** descrivere il problema, **fronte di Pareto**, risultati finali → *sez. 8*.

*(Nessuna domanda sostanzialmente nuova rispetto alle sezioni esistenti: i dettagli sopra le arricchiscono.)*

</details>

<details>
<summary><strong>📊 Frequenza delle domande (cosa esce più spesso)</strong></summary>

> Conteggio (**qualitativo**) delle occorrenze sugli appelli raccolti (giu–lug 2026, prof. Ferrero).
> Serve a **dare priorità** allo studio: non è statistica rigorosa, ma il segnale è chiaro.

**🔥 Molto frequenti (≈5+ volte) — da sapere benissimo**

| Argomento | Dove |
|---|---|
| **RANS vs Eulero**, sorgenti di dissipazione/perdite, **viscosità turbolenta**, **LES** | *sez. 4* |
| **Esercitazione paletta (LS59)**: campi di Mach/pressione, **$M_{is}$ isentropico a parete**, bordo di fuga, confronto sperimentale/RANS | *sez. E* |
| **Condizioni al contorno di uscita** (sub/supersonica) e regime del flusso | *sez. 2* |

**⭐ Frequenti (≈3–4 volte)**

| Argomento | Dove |
|---|---|
| **Gradienti** su griglie non strutturate (Green–Gauss, minimi quadrati **con/senza pesi**), gradiente all'**interfaccia** (termine diffusivo) | *sez. 3* |
| **Pistone in moto accelerato** (caratteristiche, invarianti di Riemann, **Rankine–Hugoniot**) | *sez. 2* |
| **Godunov / upwind / problema di Riemann** e varianti (Osher, **Roe**) | *sez. 3* |
| **Limitatori di pendenza** (minmod, superbee) e schemi di **2° ordine** nello spazio | *sez. 3* |
| **Esercitazione rampa / doppia presa**: campo di Mach, urti e strutture, **$p_{wall}$** | *sez. E* |
| **Convergenza** (di griglia con **Richardson**; temporale = norma dei residui) | *sez. E* |
| **BC a parete** per Eulero (impostazione con le **caratteristiche**) | *sez. 2* |

**▫️ Occasionali (1–2 volte)**

| Argomento | Dove |
|---|---|
| **Ottimizzazione** di forma (fronte di **Pareto**) | *sez. 8* |
| **Metodi ODE** espliciti/impliciti (scrivere **Eulero implicito**), stabilità | *sez. 3* |
| Flusso **ellittico vs iperbolico**, teoria dei segnali | *sez. 1–2* |
| **Strato limite** e processo iterativo per $\tau$ | *sez. 4* |
| **Schemi di ordine > 2** (WENO, Discontinuous Galerkin) | *sez. 3* |

**Lettura d'insieme:** l'esame è **2 domande di teoria + 1 di esercitazione**. Le due "teste di serie"
sono **turbolenza (RANS/LES)** e **condizioni al contorno**; sull'esercitazione domina la **paletta LS59**
(Mach, $M_{is}$, confronto con RANS/esperimento). Preparare bene questi tre blocchi copre la maggioranza
degli appelli.

</details>

<details>
<summary><strong>🗓️ Domande per data (registro degli appelli)</strong></summary>

> Trascrizione fedele delle domande raccolte, **raggruppate per appello/data**. Formato: le prime due
> voci sono teoria, l'ultima esercitazione (quando distinguibile). Sono **ignorate** le domande del corso
> del prof. *Ferlauto* (finite per errore nello stesso gruppo).

**📅 01/07**
- Gradiente di centro cella (**Green–Gauss** e **minimi quadrati pesati**).
- **Condizione al contorno a parete** con **onda d'urto**.
- *Esercitazione:* **estrapolazione di Richardson**; strutture della **pala di turbina**; perché si impone
  la **pressione all'uscita** nonostante il flusso sia supersonico → *il flusso è supersonico ma **non in
  direzione normale** alle celle del bordo d'uscita, lungo cui è **subsonico***.

**📅 23/06 (Ferrero)**
- **Pistone in accelerazione**: tutto — incognite e valori noti; ricorda le **BC a $t=0$** e **lungo la
  traiettoria** del pistone.
- **RANS** in generale, focus sulla **viscosità turbolenta** + **LES**.
- **Rampa supersonica**: descrivere onde ed espansioni; spiegare perché, **pur essendo in Eulero 2D**, si
  ha **variazione di entropia** (attraverso gli **urti**).

**📅 22/06**
- **Condizione al contorno a parete** per Eulero (voleva quella con le **linee caratteristiche**).
- **Strato limite** e **processo iterativo** per trovare $\tau$.
- *Esercitazione* con **Azteco** (solver lineare).
- *(altri studenti stessa finestra)*
  - Flusso **ellittico vs iperbolico**, **teoria dei segnali**; **pistone accelerato** & **Rankine–Hugoniot**;
    **LES**; esercitazione **rampa + paletta** (commentare grafici $M_{is}$ e campi di Mach).
  - **Metodi per flussi turbolenti** (differenze, pregi/difetti) e nello specifico la **LES**; condizioni di
    **uscita** per flusso sub/supersonico; esercitazione **paletta** (campi di Mach e pressione, BC imposte).
  - Calcolo del **gradiente all'interfaccia** con **termine diffusivo**; metodo di **Godunov** e varianti
    (**Osher, Roe**); esercitazione **ottimizzazione** (problema, **fronte di Pareto**, risultati) e **doppia
    rampa** (campo di Mach, strutture, e riconoscerle nel grafico della **pressione a parete**).

**📅 19/06**
- **Limitatori di pendenza** per griglie **strutturate**: perché si usano e come si scrivono (almeno il
  **minmod** con $a,b$; poi **superbee**).
- **Metodi ODE** in generale (pro/contro) e scrivere **Eulero implicito**.
- *Relazione:* commentare i **campi di Mach** (urti, strutture); come si ricava il **Mach isentropico** e
  perché si chiama così; **cause di dissipazione** e **caduta di $p_{tot}$** nelle RANS.
- *(F. Vaccaro)* metodi numerici di **ordine > 2**; **metodo delle caratteristiche** per il pistone
  accelerato. Relazione: **convergenza temporale** (norma dei **residui**), campo di moto della **paletta** e
  confronto con **dati sperimentali** e **RANS**; differenza delle **sorgenti di dissipazione** Eulero vs RANS.
- *(Nico)* equazioni di **Eulero non stazionarie** (caratteristiche, invarianti di **Riemann**); **Godunov** e
  poi gli **upwind** in generale; relazione in generale; **pendenza per griglie non strutturate** (= gradienti
  Green–Gauss e minimi quadrati pesati); condizioni per Eulero **uscita super/subsonica**.

**📋 Domande sparse (appello non annotato)**
- Differenza **Eulero vs RANS**; **problema di Riemann**; **pendenze** per schemi di 2° grado (come si calcola,
  come si limita); **minimi quadrati** con e senza pesi; **BC uscita** sub/supersonica.
- Campo di Mach **doppia rampa**, sorgenti di perdite Eulero vs RANS (Eulero: **urti**; RANS: urti +
  **viscosità turbolenta** aggiunta a quella molecolare, già presente nelle NS); **convergenza di griglia**;
  **$M_{is}$ a parete** della turbina.
- **Limitatori di pendenza**; caratteristiche degli schemi **espliciti e impliciti**; campo di Mach della
  turbina (bordo di fuga, effetto del $M_{is}$ a parete, come si è calcolato).

**💬 Precisazioni dal gruppo**
- Per i modelli di **viscosità turbolenta**: non serve saperli a memoria, ma **riconoscere i termini** se
  mostrati (convettivi, diffusivi, di **produzione**, **distruzione**, **compressibilità**) e sapere le relative
  **condizioni al contorno**.

</details>

## 1) Leggi di conservazione e sistema di Eulero — `teoria/bilancio.md`

<details>
<summary><strong>🟦 [T] Equazione di Burgers, collegandosi ai casi delle condizioni al contorno</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/bilancio.md` (modello di Burgers),
> `teoria/caratteristiche.md` (condizioni al contorno via caratteristiche), `teoria/metodi_numerici.md`.
> Attesi: Burgers come **modello scalare non lineare** (formazione di urti, onde di rarefazione,
> condizione di entropia), e come si traducono le **condizioni al contorno** a seconda del segno
> delle caratteristiche.

</details>


<details>
<summary><strong>🟦 [T] Equazione di Burgers</strong></summary>

> 📌 *Risposta da compilare.* Variante "secca" della precedente. Riferimento: `teoria/bilancio.md`.

</details>

## 2) Linee caratteristiche: pistone, Sod, condizioni al contorno — `teoria/caratteristiche.md`

<details>
<summary><strong>🟦 [T] Esempio del pistone in accelerazione</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/caratteristiche.md` §6 (toggle "simulazione d'esame").
> Attesi: pistone che accelera in un condotto → **compressione progressiva** → coalescenza delle
> onde di compressione in un **urto** (caratteristiche che convergono); caso speculare di espansione
> con pistone che retrocede.
>
> **Considerazioni dalla simulazione d'esame:**
> - **Zone:** a sinistra della faccia del pistone **no gas**, a destra **gas compresso**; la zona
>   **indisturbata** è quella **sotto la prima caratteristica** (dall'origine).
> - **Dal pistone** ha senso solo $\lambda_3=u+a$ (più veloce di $u_p$): $\lambda_1$ andrebbe nel vuoto,
>   $\lambda_2$ resta sul pistone. (Vale solo per le caratteristiche che originano sul pistone.)
> - **Pendenza** $dt/dx=1/\lambda$ (l'inverso della velocità); accelerando, le $\lambda_3$ diventano più
>   veloci → meno inclinate → **convergono** → urto (poi **Rankine–Hugoniot**).
> - **Procedura (invarianti di Riemann):** $W_1(5)=W_1(2)$ con $u_2$ = velocità del pistone (nota) → ricavo
>   $a_2$; poi $W_3(2)=W_3(P)$ e $W_1(4)=W_1(P)$ → stato in $P$. **3 incognite ($a_2,u_P,a_P$), 3 equazioni
>   → determinato.** La velocità del pistone è nota ovunque (legge di moto), ma $a_2$ **no** (il pistone
>   impone solo la cinematica). $S$ ("$\delta$") costante (omoentropico) chiude la termodinamica.

![Pistone: due stati (gas/no gas)](../teoria/images/piston_due_stati.svg)
![Costruzione dello stato in P con le caratteristiche (frecce dal noto verso P)](../teoria/images/piston_costruzione_P.svg)

</details>


<details>
<summary><strong>🟦 [T] Tubo di Sod</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`, `teoria/caratteristiche.md`.
> Attesi: problema di Riemann "canonico" (membrana che separa due stati), soluzione con
> espansione + contatto + urto, uso come **test di validazione** degli schemi.

![Profili di Sod: rho, p, u, T (espansione + contatto + urto)](../teoria/images/lc_sod_profili.svg)

</details>


<details>
<summary><strong>🟦 [T] Outlet subsonico (e in generale le condizioni al contorno in base al regime)</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/caratteristiche.md`, `teoria/report_QA.md`
> (Domande 12–13). Attesi: numero di **caratteristiche entranti** = numero di condizioni da imporre.
>
> **Le 4 casistiche** (vedi figura `teoria/images/lc_bc_quattro_casi.svg`):
>
> | Caso | Bordo | Segni $\lambda_1,\lambda_2,\lambda_3$ | Entranti | **# BC** | Cosa si impone |
> |---|---|---|---|---|---|
> | **A** Ingresso supersonico | sx | $+,+,+$ | 3 | **3** | $p_0,T_0,M$ (o $u,S$+1 termo) |
> | **B** Ingresso subsonico | sx | $-,+,+$ | 2 | **2** | $p_0,T_0$; $\lambda_1$ esce → si estrapola |
> | **C** Uscita supersonica | dx | $+,+,+$ | 0 | **0** | nulla (tutto estrapolato) |
> | **D** Uscita subsonica | dx | $-,+,+$ | 1 | **1** | $p$ statica (rifl.) o invariante $W_1$ (non rifl.) |
>
> Logica: le **entranti** portano info da fuori → si **impongono**; le **uscenti** portano info dall'interno → si **estrapolano** (risalendo la caratteristica). Dettaglio in `teoria/caratteristiche.md` §8.

![Le 4 casistiche delle condizioni al contorno (ingresso/uscita, sub/super)](../teoria/images/lc_bc_quattro_casi.svg)

</details>

## 3) Metodi numerici (differenze, volumi, elementi finiti) — `teoria/metodi_numerici.md`

### Proprietà dei metodi, errore, stabilità, integrazione temporale


<details>
<summary><strong>🟦 [T] Parlare delle proprietà dei metodi numerici</strong></summary>

Riferimento: `teoria/metodi_numerici.md` §1 (toggle "Proprietà"). Risposta:

Le tre proprietà fondamentali, nell'ordine **logico** consistenza → stabilità → convergenza (non
viceversa), perché la convergenza si **deduce** dalle altre due:
- **Consistenza:** raffinando ($\Delta t\to0$), l'**errore di troncamento** (≈ discretizzazione) → 0; cioè
  l'equazione discretizzata tende a quella esatta.
- **Stabilità:** raffinando, l'**errore di propagazione** → 0; gli errori non si amplificano nel tempo.
- **Convergenza:** raffinando, l'**errore globale** → 0. Ma $E_{\text{globale}}=E_{\text{troncamento}}+E_{\text{propagazione}}$:
  se entrambi → 0, anche la somma → 0.
- **Teorema di equivalenza di Lax** (problema lineare ben posto): **consistenza + stabilità ⟺ convergenza**.

Mappa: (a) consistenza ↔ troncamento · (b) stabilità ↔ propagazione · (c) convergenza ↔ globale.

**Per completezza** (proprietà aggiuntive):
- **Ordine di convergenza:** la potenza $p$ con cui l'errore va a zero, $E\sim O(\Delta x^{p})$ (1°, 2°…).
- **Monotonicità:** lo schema non crea **nuovi massimi/minimi** (niente oscillazioni spurie) — legata al TVD.
- **Conservatività:** il flusso che esce da una cella entra nell'adiacente → la grandezza si **conserva**
  globalmente; essenziale per gli **urti** (velocità d'urto corretta via Rankine–Hugoniot).

</details>

<details>
<summary><strong>🟦 [T] Dimostrare il senso fisico dell'errore locale di troncamento</strong></summary>

Riferimento: `teoria/metodi_numerici.md` §1 (toggle "Errori"). Risposta:

**Idea:** equazioni diverse hanno soluzioni diverse. La soluzione **esatta** annulla l'equazione
**originale** $u_t+a\,u_x=0$, **ma non** l'equazione **discretizzata**: inserendo $u_{ex}$ nella discreta si
ottiene proprio l'**errore di troncamento** (≠ 0).

**Esempio (upwind esplicito), via Taylor.** Sostituendo $u_{ex}$ e sviluppando in serie:

$$\frac{u_j^{n+1}-u_j^{n}}{\Delta t}+a\,\frac{u_j^{n}-u_{j-1}^{n}}{\Delta x}\bigg|_{u_{ex}}
=\underbrace{(u_t+a\,u_x)}_{=\,0}\;+\;\frac{\Delta t}{2}\,u_{tt}-a\,\frac{\Delta x}{2}\,u_{xx}+\dots
=E_{\text{tronc}}\neq 0.$$

**Senso fisico:** i termini residui (i gradi alti del Taylor, **troncati** nello schema → da cui il nome)
sono l'**equazione modificata** che il metodo risolve *davvero*: contengono **diffusione/dispersione
numerica**. Quindi il calcolo non risolve l'equazione esatta ma **un'equazione diversa**, con dissipazione/
dispersione spurie. Per $\Delta t,\Delta x\to0$ questi termini → 0 ⇒ **consistenza**. L'idea (l'esatta non
annulla l'equazione approssimata) è **generale**, non solo delle differenze finite.

</details>

<details>
<summary><strong>🟦 [T] Stabilità di uno schema numerico — (a) UPWIND ESPLICITO</strong></summary>

> All'esame "la stabilità di uno schema generico" → **studiali tutti e tre** (upwind esplicito, centrato
> esplicito, centrato implicito): qui sono **tre domande separate** così sei pronto a qualsiasi richiesta.

Riferimento: `teoria/metodi_numerici.md` §1 (toggle "von Neumann — upwind esplicito"). Risposta:

Analisi di **von Neumann**: inserisco un modo d'errore $e_j^n=E^n e^{i\beta x_j}$ nello schema upwind
$u_j^{n+1}=u_j^n-\nu(u_j^n-u_{j-1}^n)$, $\nu=a\Delta t/\Delta x$. Ricavo il **fattore di amplificazione**

$$G=\frac{E^{n+1}}{E^n}=(1-\nu)+\nu\,e^{-i\theta},\qquad \theta=\beta\Delta x,$$

un **cerchio** di centro $(1-\nu,0)$ e raggio $\nu$. Stabilità $\iff |G|\le1\ \forall\theta\iff$ il cerchio
sta nel cerchio unitario $\iff \boxed{\nu\le1}$ (**CFL**). → **condizionatamente stabile**
($\nu<1$ stabile, $\nu=1$ neutro, $\nu>1$ instabile). Vedi figura `teoria/images/vonneumann_upwind.svg`.

![Cerchio di amplificazione dell'upwind esplicito vs cerchio unitario](../teoria/images/vonneumann_upwind.svg)

</details>

<details>
<summary><strong>🟦 [T] Stabilità di uno schema numerico — (b) CENTRATO ESPLICITO (FTCS)</strong></summary>

> 📌 *Dimostrazione in arrivo (la fornisci tu come PDF → la converto in LaTeX/markdown qui).*
> **Risultato atteso:** $G=1-i\,\nu\sin\theta$ → $|G|^2=1+\nu^2\sin^2\theta>1$ → **incondizionatamente
> instabile** (per la pura advezione). Riferimento: `teoria/metodi_numerici.md` §1–§2.

</details>

<details>
<summary><strong>🟦 [T] Stabilità di uno schema numerico — (c) CENTRATO IMPLICITO</strong></summary>

> 📌 *Dimostrazione in arrivo (la fornisci tu come PDF → la converto in LaTeX/markdown qui).*
> **Risultato atteso:** $G=\dfrac{1}{1+i\,\nu\sin\theta}$ → $|G|=\dfrac{1}{\sqrt{1+\nu^2\sin^2\theta}}\le1$
> sempre → **incondizionatamente stabile** (al prezzo di risolvere un **sistema** ad ogni passo).
> Riferimento: `teoria/metodi_numerici.md` §1.

</details>

<details>
<summary><strong>🟦 [T] Integrazione temporale con metodi espliciti ed impliciti</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: Eulero esplicito vs implicito, Runge–Kutta, costo per passo vs ampiezza del $\Delta t$,
> **stiffness**, A-stabilità.

</details>

<details>
<summary><strong>🟦 [T] Scrivere la formula dello schema numerico per il metodo esplicito e implicito</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: $\mathbf{U}^{n+1} = \mathbf{U}^n + \Delta t\,\mathbf{R}(\mathbf{U}^n)$ (esplicito) vs
> $\mathbf{U}^{n+1} = \mathbf{U}^n + \Delta t\,\mathbf{R}(\mathbf{U}^{n+1})$ (implicito), con la
> linearizzazione/Jacobiano per l'implicito.

</details>

<details>
<summary><strong>🟦 [T] Stabilità di uno schema numerico generico e poi per il metodo implicito</strong></summary>

> 📌 *Risposta da compilare.* Variante combinata: parte generale + **stabilità del metodo implicito**
> (A-stabilità, incondizionata). Riferimento: `teoria/metodi_numerici.md`.

</details>

### Volumi finiti: gradienti, ricostruzione, limitatori


<details>
<summary><strong>🟦 [T] Calcolo del gradiente nelle celle (Gauss–Green e minimi quadrati pesati) e all'interfaccia per i termini diffusivi</strong></summary>

> 📌 *Risposta da compilare — verrà fornita la spiegazione dell'utente, da rifinire.*
> Riferimento: `teoria/metodi_numerici.md` (ricostruzione e gradienti) e `teoria/meshing.md`.
> Punti chiave attesi: gradiente di cella con il **teorema di Gauss–Green** (integrale di superficie
> dei valori di faccia), **minimi quadrati pesati** (sistema sui vicini, peso $\propto 1/d$), e
> il gradiente **all'interfaccia** necessario per i **flussi diffusivi** (media + correzione
> di non-ortogonalità).

</details>

<details>
<summary><strong>🟦 [T] Limitatori di pendenza per griglie strutturate e non strutturate</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: motivazione (monotonicità / TVD, evitare oscillazioni spurie a cavallo delle
> discontinuità), limitatori classici (minmod, Van Leer, Barth–Jespersen / Venkatakrishnan per
> mesh non strutturate), differenza nello **stencil** tra strutturato e non strutturato.

</details>

<details>
<summary><strong>🟦 [T] Limitatori per mesh strutturate e non, spiegando la precisione di macchina in termini di ordine di accuratezza</strong></summary>

> 📌 *Risposta da compilare.* Variante della precedente. Aggancio extra: come la **precisione di
> macchina** (round-off) pone un **limite inferiore** all'errore raggiungibile e interagisce con
> l'**ordine di accuratezza** (oltre un certo raffinamento l'errore di troncamento scende sotto il
> round-off e non si guadagna più). Riferimento: `teoria/metodi_numerici.md`.

</details>

<details>
<summary><strong>🟦 [T] Calcolo dei gradienti: tutti e 3 i metodi (Green–Gauss, minimi quadrati, minimi quadrati pesati) con esempi</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: i **tre** approcci, vantaggi/limiti (Green–Gauss sensibile alla qualità mesh; minimi
> quadrati più robusto su mesh distorte; pesatura per dare più importanza ai vicini vicini),
> con esempio numerico/geometrico.

</details>

<details>
<summary><strong>🟦 [T] Gradiente all'interfaccia e metodo dei minimi quadrati pesati</strong></summary>

> 📌 *Risposta da compilare.* Sottocaso delle precedenti, focalizzato su **interfaccia** (flussi
> diffusivi) + **WLSQ**. Riferimento: `teoria/metodi_numerici.md`.

</details>

<details>
<summary><strong>🟦 [T] Schemi di ordine superiore al primo nello spazio (intro generica) e calcolo della pendenza per griglie strutturate</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: dal **primo ordine** (Godunov) alla **ricostruzione MUSCL** (pendenza/slope), upwind vs
> centrati, ruolo del limitatore; calcolo della **pendenza** su griglia strutturata (differenze su
> stencil regolare).

</details>

### Schemi per i flussi convettivi: Riemann, Godunov, alta risoluzione


<details>
<summary><strong>🟦 [T] Flusso di Roe (simulazione d'esame)</strong></summary>

Riferimento: `teoria/metodi_numerici.md` §3 (toggle "Metodo di Roe"). Risposta:

**Idea di base:** **linearizzare** le equazioni di conservazione iperboliche. Da $\partial_t U+\partial_x F=0$,
introdotta la Jacobiana $A=\partial F/\partial U$, si sostituisce una matrice **costante** $\bar A$
all'interfaccia. $\bar A$ deve soddisfare **tre condizioni**: (1) $\Delta F=\bar A\,\Delta U$ (consistenza
sul salto/conservazione), (2) **diagonalizzabile** con autovalori **reali** (iperbolicità), (3)
$\bar A\to A(U)$ quando $U_j\to U_{j+1}$ (consistenza nel liscio). Si soddisfano con le **medie di Roe**
(pesate con $\sqrt\rho$): $\bar\rho=\sqrt{\rho_j\rho_{j+1}}$, $\bar u$, $\bar h$.

**Variabili:** conservative $U=(\rho,\rho u,\rho E)$ e **caratteristiche** $W=L^{-1}U$ ($\lambda=\{u-a,u,u+a\}$),
con $dU=L\,dW$. **Flux difference splitting:** $\Delta F=\bar A\,\Delta U=L\Lambda\,\Delta W$, separato per
segno con $\tfrac{\lambda_k\pm|\lambda_k|}{2}$. **Flusso numerico:**
$$F_{j+1/2}=\tfrac12\big(F_j+F_{j+1}\big)-\tfrac12\sum_k|\lambda_k|\,\ell_k\,\Delta W_k
=\tfrac12(F_j+F_{j+1})-\tfrac12|\bar A|\,\Delta U.$$

**Entropy fix:** quando un autovalore **cambia segno** ($|\lambda_k|\to0$, rarefazione **transonica**), Roe
genera un'**espansione non fisica** → si addolcisce $|\lambda_k|$ vicino a zero (Harten). Pro: accurato,
economico, nitido sugli urti. Contro: richiede l'entropy fix.

</details>

<details>
<summary><strong>🟦 [T] Metodo di Godunov</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`
> (Godunov/Riemann, flux splitting, Roe). Attesi: ricostruzione costante a tratti → **problema di
> Riemann** a ogni interfaccia → flusso esatto/approssimato; primo ordine; legame con l'upwind.

</details>

<details>
<summary><strong>🟦 [T] Problema di Riemann e tubo d'urto di Sod: applicazione al calcolo dei flussi all'interfaccia tra celle (perché farlo, come si usa nel CFD, ODE risultante), metodi di risoluzione del problema di Riemann e metodo di Godunov</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`,
> `teoria/caratteristiche.md`. Attesi: struttura a **3 onde** (urto, contatto, espansione), perché
> all'interfaccia tra celle nasce un problema di Riemann locale, risolutori **esatti vs approssimati**
> (Roe, HLL/HLLC), e il metodo di **Godunov**.

</details>

<details>
<summary><strong>🟦 [T] Schemi di Lax(–Friedrichs) e Jameson–Schmidt–Turkel (JST)</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md`.
> Attesi: **Lax–Friedrichs** (centrato + dissipazione $\propto \lambda_{max}$), **JST** (centrato con
> dissipazione artificiale del 2°/4° ordine commutata da sensore di pressione), pro/contro.

</details>

<details>
<summary><strong>🟦 [T] Equazioni di Eulero 2D, discretizzazione a volumi finiti (arrivare a $\mathrm{d}\mathbf{U}/\mathrm{d}t = \sum \text{flussi}$), panoramica degli schemi per i flussi convettivi e illustrare Jameson</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/bilancio.md` (sistema di Eulero),
> `teoria/metodi_numerici.md`. Attesi: forma conservativa, integrazione sul volume di controllo,
> teorema della divergenza → bilancio dei flussi sulle facce, semidiscretizzazione, poi rassegna
> schemi e dettaglio **Jameson**.

</details>

<details>
<summary><strong>🟦 [T] Metodi WENO e Discontinuous Galerkin (esempio 2D e formulazione variazionale)</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/metodi_numerici.md` (approfondimenti
> WENO/DG). Attesi: **WENO** (combinazione pesata di stencil, pesi non lineari per evitare gli
> stencil che attraversano la discontinuità), **DG** (incognite = coefficienti modali per cella,
> **formulazione debole/variazionale**, flussi numerici tra elementi), esempio 2D.

</details>

<details>
<summary><strong>🟦 [T] WENO 5 e Galerkin Discontinuo</strong></summary>

> 📌 *Risposta da compilare.* Variante della precedente, focus su **WENO di ordine 5** (3 sottostencil)
> e DG. Riferimento: `teoria/metodi_numerici.md`, immagine `weno5_stencil_sottogruppi.jpg`.

</details>

## 4) Turbolenza — `teoria/turbolenza.md`


<details>
<summary><strong>🟦 [T] RANS</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/turbolenza.md`.
> Attesi: media di Reynolds, **tensore degli sforzi di Reynolds**, problema di chiusura, modelli
> (Spalart–Allmaras, $k$–$\varepsilon$, $k$–$\omega$ SST), ipotesi di Boussinesq.

</details>

<details>
<summary><strong>🟦 [T] LES e modelli per la eddy viscosity</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/turbolenza.md`.
> Attesi: **filtraggio** spaziale, scale risolte vs **sottogriglia (SGS)**, modello di
> **Smagorinsky** e Smagorinsky **dinamico** (Germano), DES/DDES. Immagini
> `les_filtri_top_hat_vs_gaussian.jpg`, `smagorinsky_dinamico_filtri_test_germano.jpg`.

</details>

## 5) Turbomacchine — `teoria/turbomacchine.md`


<details>
<summary><strong>🟦 [T] Metodi per valutare l'interazione statore–rotore</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/turbomacchine.md`.
> Attesi: **mixing plane** (media circonferenziale all'interfaccia, stazionario), **sliding mesh**
> (non stazionario), metodi **corocronici**, **tempo inclinato**. Immagini `mixing_plane.jpg`,
> `sliding_mesh_ripartizione_flussi.jpg`.

</details>

## 6) Modelli di ordine ridotto — `teoria/modelli_ordine_ridotto.md`


<details>
<summary><strong>🟦 [T] Modelli di ordine ridotto: POD</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/modelli_ordine_ridotto.md`.
> Attesi: **snapshot**, decomposizione in **modi** (energia, RIC), training **offline/online**,
> proiezione di Galerkin.

</details>

## 7) Flussi reagenti — `teoria/reacting_flows.md`


<details>
<summary><strong>🟦 [T] Come si affronta il problema dei flussi reagenti — senza scrivere equazioni</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `teoria/reacting_flows.md`.
> Attesi (qualitativo): specie chimiche aggiuntive, **mixing**, fiamme **premiscelate vs diffusive**,
> scale temporali della chimica (stiffness), metodo di **proiezione**. Immagine
> `fiamme_premiscelata_vs_diffusiva.svg`.

</details>

## 8) Ottimizzazione — (esercitazione; nessun capitolo di teoria dedicato)


<details>
<summary><strong>🟦 [T] Ottimizzazione di forma</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/ottimizzazione.tex`, cartella `Ottimizzazione/`.
> Attesi: parametrizzazione della geometria, **funzione obiettivo** e vincoli, algoritmi
> (gradiente/aggiunto vs evolutivi), workflow con **modeFRONTIER**.

</details>

---

# 🟩 PARTE DI ESERCITAZIONE (domande realmente proposte — sempre in fondo)

> Nota sullo *splitting*: i punti d'esame raccolti spesso **impacchettano più argomenti
> concettualmente indipendenti** (es. "Richardson sul bump **+** simulazione della paletta **+**
> differenze col RANS"). Qui vengono **separati** in domande singole, così da poterli studiare in
> modo autonomo.

<details>
<summary><strong>🟩 [E] Estrapolazione di Richardson nel caso del Bump ✅ (risposta completa)</strong></summary>

### 1. Cos'è l'estrapolazione di Richardson

L'estrapolazione di Richardson è una tecnica che, combinando i risultati di **più griglie a
raffinamento diverso**, permette di **stimare la soluzione "esatta"** (a griglia infinita) e di
**valutare l'ordine di convergenza** dello schema. L'ordine può essere inteso in due modi:

- **ordine teorico**: quello che lo schema *avrebbe* nel regime ideale (per Roe e Lax–Friedrichs di
  base, $p = 1$); è più facile da usare ma quasi mai raggiunto esattamente;
- **ordine effettivo (empirico)**: quello che lo schema raggiunge *concretamente* su quelle griglie,
  ricavato dai dati.

La tua intuizione è corretta: assumere $p = p_{teorico}$ ha senso **solo se si è nella regione
asintotica**, cioè su griglie già abbastanza fini. Altrimenti i termini di ordine superiore non
sono trascurabili e l'ordine osservato si discosta (di norma è **più basso**).

> ⚠️ **Correzione importante (transitorio vs regione asintotica).** Nella tua spiegazione hai legato
> la "regione asintotica" al grafico **residui vs numero di iterazioni**. Attenzione: quel grafico
> riguarda la **convergenza temporale** verso lo stato stazionario (stabilità: i residui calano fino
> ad assestarsi su una singola griglia), ed è una cosa **diversa** dalla **convergenza spaziale di
> griglia**. L'ordine $p$ di Richardson vive sul grafico **errore vs $h$** (log–log), e la "regione
> asintotica" che conta per Richardson è quella per **$h \to 0$** (griglia sempre più fitta), non
> per $\text{iter}\to\infty$. Le due convergenze sono indipendenti (cfr. `Latex/bump.tex`,
> "Distinzione tra Convergenza Spaziale e Temporale"). Quindi: il numero di iterazioni **non
> influisce sull'ordine $p$**, a patto che ogni simulazione sia portata **a convergenza** (stato
> stazionario); ciò che influisce su $p$ è solo **quanto è fitta la griglia**.

### 2. Perché si traccia l'entropia, e perché la norma $L_2$

Il bump è **subsonico** ($M_{in} = 0.3$) e risolto con un solver **inviscido (Eulero)**: niente
viscosità e niente urti. In queste condizioni il flusso è **isentropico**, quindi (a meno della
costante di riferimento) l'entropia dovrebbe essere **identicamente nulla** ovunque. Ne segue il
punto chiave:

> Qualunque variazione di entropia osservata è un **artefatto numerico** (dissipazione dello schema).
> L'entropia diventa quindi una **misura diretta dell'errore numerico**: più è piccola, più la
> soluzione è vicina a quella esatta.

Questo risponde al tuo dubbio: l'entropia non "influisce" sull'ordine di convergenza; è la
**grandezza-osservabile di cui misuriamo l'ordine**. Va distinta da due usi diversi:
- entropia **vs iterazioni** → monitor della **convergenza temporale** (come i residui);
- norma dell'entropia **vs $h$** (a convergenza) → è ciò che fornisce l'**ordine spaziale** $p$.

La scelta della **norma $L_2$** non è la norma euclidea "geometrica", ma una **$L_2$ pesata sul
volume e mediata** (RMS integrale):

$$
\|\bar S\|_2 = \sqrt{\frac{\sum_i \bar S_i^{\,2}\,|\Omega_i|}{\sum_i |\Omega_i|}}
$$

La pesatura con l'area di cella $|\Omega_i|$ la rende un'**approssimazione dell'integrale**
$\int_\Omega \bar S^2\,d\Omega$ (indipendente da come è fatta la mesh), e la normalizzazione la rende
un **RMS** confrontabile **tra griglie diverse** — esattamente ciò che serve per un'analisi di
convergenza. (Dettaglio in `teoria/report_QA.md`, Domanda 21.)

### 3. La legge di potenza dell'errore e le sue incognite

L'errore di discretizzazione (per definizione: **valore numerico − valore esatto**) si modella come

$$
E = u_h - u_{\rm esatto} = k\,h^{p}
$$

dove:
- $h$ = **dimensione caratteristica** della cella. Per un quadrato è il lato ($h=\sqrt{A}$); per
  elementi qualsiasi si usa una dimensione equivalente $h_{\rm eff}\approx\sqrt{A/N}$ — la tua
  intuizione è giusta, "che poi non sia esattamente il lato non importa". (cfr. `teoria.tex`,
  "Lunghezza caratteristica nominale ed effettiva");
- $p$ = **ordine di convergenza** (proprietà del **metodo**);
- $k$ = **costante di proporzionalità** (l'errore è *proporzionale* a $h^p$, quindi serve $k$).

**Incognite e noti**: $u_h$ è **noto** (è il risultato della simulazione); $h$ è **noto** (l'abbiamo
scelto con la mesh); $u_{\rm esatto}$ è in generale **incognito** (altrimenti non simuleremmo);
$p$ può essere noto (se assumiamo il teorico) o incognito; $k$ è incognito. Una sola equazione con
due incognite non basta → servono **più griglie**.

### 4. Derivazione della formula della soluzione esatta (ordine teorico, 2 griglie) — *eq. 3.25*

Si scrivono **due** simulazioni con lo **stesso metodo** (quindi stessi $p$ e $k$) ma **griglie
diverse**: $h_1$ (fine) e $h_2 = r\,h_1$ (con $r$ = rapporto di diradamento). Con $p$ **assunto** pari
al teorico:

$$
\text{(1)}\quad u_{h_1} - u_{\rm esatto} = k\,h_1^{p}
\qquad\qquad
\text{(2)}\quad u_{h_2} - u_{\rm esatto} = k\,(r h_1)^{p} = r^{p}\,k\,h_1^{p}
$$

**Passo 1 — elimino $k$.** Sottraggo la (1) dalla (2):

$$
u_{h_2} - u_{h_1} = (r^{p}-1)\,k\,h_1^{p}
\quad\Longrightarrow\quad
k\,h_1^{p} = \frac{u_{h_2} - u_{h_1}}{r^{p}-1}
$$

**Passo 2 — sostituisco in (1) per isolare $u_{\rm esatto}$.** Dalla (1) $u_{\rm esatto}=u_{h_1}-k h_1^p$:

$$
u_{\rm esatto} = u_{h_1} - \frac{u_{h_2}-u_{h_1}}{r^{p}-1}
= u_{h_1} + \frac{u_{h_1}-u_{h_2}}{r^{p}-1}
$$

**Passo 3 — forma compatta** (denominatore comune):

$$
\boxed{\,u_{\rm esatto} \approx \dfrac{r^{p}\,u_{h_1} - u_{h_2}}{r^{p}-1}\,}
$$

che è la **formula 3.25** del report. Il termine $\dfrac{u_{h_1}-u_{h_2}}{r^{p}-1}$ è la **stima
dell'errore** della griglia fine, che Richardson **somma** a $u_{h_1}$ per "estrapolare" verso
$h\to 0$.

> 🔧 **Nota di coerenza interna al progetto.** In `Latex/teoria.tex` l'equazione equivalente è
> scritta come $u_{\rm esatto}\approx u_h + \frac{u_{2h}-u_h}{2^p-1}$: con la convenzione
> $E=u-u_{\rm esatto}$ il segno corretto è $u_{\rm esatto}\approx u_h - \frac{u_{2h}-u_h}{2^p-1}
> = u_h + \frac{u_h-u_{2h}}{2^p-1}$ (coerente col box qui sopra e con `report_QA.md` Domanda 24).
> È un **refuso di segno** nel report da correggere.

### 5. Derivazione dell'ordine effettivo (3 griglie)

Se **non** si vuole assumere il teorico, $p$ diventa **incognita**: le incognite sono ora $u_{\rm
esatto}$ **e** $p$ (la $k$ continua a non interessarci, viene eliminata), quindi serve una **terza**
griglia. Con tre griglie a **rapporto costante** $r$, comodamente $h,\;2h,\;4h$ (cioè $r=2$):

$$
u_h - u_{\rm esatto} = k\,h^p,\qquad
u_{2h} - u_{\rm esatto} = k\,(2h)^p = 2^p k h^p,\qquad
u_{4h} - u_{\rm esatto} = k\,(4h)^p = 4^p k h^p
$$

Sottraendo a coppie **scompare $u_{\rm esatto}$**:

$$
u_{2h}-u_{h} = k h^p\,(2^{p}-1),\qquad
u_{4h}-u_{2h} = k h^p\,(4^{p}-2^{p}) = k h^p\,2^{p}(2^{p}-1)
$$

Il **rapporto** elimina anche $k h^p$:

$$
\frac{u_{4h}-u_{2h}}{u_{2h}-u_{h}} = \frac{2^{p}(2^{p}-1)}{2^{p}-1} = 2^{p}
$$

da cui, prendendo il logaritmo:

$$
\boxed{\,p = \dfrac{\ln\!\left(\dfrac{u_{4h}-u_{2h}}{u_{2h}-u_{h}}\right)}{\ln 2}\,}
\qquad\text{(in generale } p=\ln(\dots)/\ln r\text{)}
$$

Trovato $p$, lo si reinserisce nella formula di estrapolazione del Passo 3 per ottenere
$u_{\rm esatto}$. È esattamente la sequenza usata nel report.

### 6. Il rapporto di diradamento $r$ — deve essere costante?

$r = h_2/h_1$. Con $r > 1$ la griglia "2" ha celle **più grandi**, quindi è **più rada**; la griglia
"1" (con $h$ più piccolo) è la **più fitta**. "Diradamento" indica proprio che, partendo dalla fine,
si **dirada** moltiplicando per $r>1$. (cfr. `report_QA.md` Domanda 23.)

**Deve essere costante?** Per la formula a 3 griglie nella forma "pulita" sopra **sì**, serve
$h:2h:4h$ con lo **stesso** $r$ tra livelli consecutivi: è ciò che fa comparire un unico $2^p$ e
permette di isolare $p$ in forma chiusa. Con $r$ **non costante** ($h_3/h_2 \ne h_2/h_1$) il sistema
si risolve ancora, ma $p$ va trovato **numericamente** (equazione trascendente), e tipicamente non si
guadagna nulla. Per questo si sceglie un $r$ **costante**, di solito $r=2$, **per pura comodità**: con
una mesh strutturata raddoppiare i nodi per lato realizza $r=2$ in modo esatto. La tua osservazione è
giusta — $r=2$ può essere "grande" se si parte già da una mesh fitta — e infatti **nulla vieta** un
$r$ costante minore (es. 1.5); è solo una scelta operativa. Nel bump del report si è usato
$r=2$ con la quaterna $l_c = 0.02,\,0.01,\,0.005,\,0.0025$.

### 7. La costante $k$ — è davvero costante? serve ricordarla?

$k$ è la **costante dell'errore di testa** ($E\simeq k h^p$). Nelle ipotesi di Richardson la si
considera **la stessa** sulle griglie usate, **perché**: (i) è lo **stesso metodo**, (ii) lo **stesso
problema**, (iii) si è (idealmente) nel **regime asintotico** dove domina il solo termine $k h^p$.
È proprio questa costanza che permette di **eliminarla** sottraendo le equazioni.

Risposta ai tuoi dubbi:
- **non ci interessa il suo valore**: in entrambi gli approcci $k$ viene **cancellata**, non
  calcolata. Nel caso "ordine teorico" l'unica incognita che resta è $u_{\rm esatto}$; nel caso
  "ordine effettivo" sono $u_{\rm esatto}$ e $p$. $k$ non serve mai esplicitamente;
- **è generale?** No: $k$ dipende dal metodo *e* dal problema *e* dal regime. Se esci dalla regione
  asintotica (termini di ordine superiore non trascurabili), l'"effettivo" $k$ apparente **cambia**.
  Quindi **non** ha valore predittivo da riusare altrove: è giusto **non** affezionarsi al suo valore.

### 8. Il caso "soluzione esatta nota" del bump e i dati concreti

C'è una scorciatoia specifica del bump: poiché $u_{\rm esatto} = \|\bar S\|_2^{\,\rm esatto} = 0$ è
**noto** (flusso isentropico), non serve nemmeno estrapolare per stimarlo. L'ordine si legge
**direttamente** dalla **pendenza** della retta in scala **log–log** ($\log E = p\log h + \log k$),
perché $E = u_h - 0 = u_h$. Risultati del report (codice eseguito, $\mathrm{CFL}=0.3$):

| Metodo | $p$ (sol. esatta nota) | Errore su griglia fine | GCI |
|---|---|---|---|
| **Roe** | $\approx 0.96$ | $8.98\times10^{-4}$ | $2.7\times10^{-3}$ |
| **Lax–Friedrichs** | $\approx 0.62$ | $1.22\times10^{-3}$ | $3.7\times10^{-3}$ |

Letture:
- entrambi **sotto** l'ordine teorico $p=1$ ⟹ griglie **non ancora pienamente asintotiche**;
- **Roe** più accurato e più vicino a 1 (minore dissipazione: scompone il salto sulle onde
  caratteristiche, mentre LF usa una dissipazione unica $\propto\lambda_{max}$);
- l'estrapolazione a **ordine effettivo** sul bump risulta **non affidabile** ($p_{\rm eff}\approx
  0.5$–$0.8$, fuori regime asintotico): per questo, *avendo* la soluzione esatta, si preferisce la
  stima "sol. esatta nota". È la conferma quantitativa del punto §1.

### 9. Risposte sintetiche ai tuoi dubbi puntuali

- **L'entropia influisce sull'ordine?** No: è l'**osservabile** di cui *si misura* l'ordine, non un
  parametro che lo cambia. (vs iterazioni = convergenza temporale; vs $h$ = ordine spaziale).
- **Perché la norma 2 (pesata)?** Per renderla l'approssimazione di un integrale, indipendente da
  mesh e dominio, quindi **confrontabile tra griglie**.
- **Errore = numerico − esatto?** Sì, è la definizione usata.
- **$h_2$ più o meno fitta di $h_1$ con $r>1$?** $h_2$ è **più rada** (celle più grandi).
- **$r$ costante?** Conveniente e quasi sempre adottato ($r=2$), non obbligatorio.
- **$k$ costante / da ricordare?** Costante nelle ipotesi di Richardson, **eliminata** nei conti,
  **non** riutilizzabile altrove: non serve ricordarla.

</details>

<details>
<summary><strong>🟩 [E] Estrapolazione di Richardson — approfondimenti e FAQ (Q1–Q8) ✅</strong></summary>

> Chiarimenti puntuali emersi sul punto precedente. Gli stessi contenuti sono stati integrati anche
> nella **parte teorica del report** (`Latex/teoria.tex`, sezione Richardson, e `Latex/bump.tex`).

#### Q1 — Perché si dice che **stima** la soluzione esatta e non la **calcola**? Da dove viene il $\approx$?

Perché la legge $E = k\,h^p$ è solo il **termine dominante** di uno sviluppo asintotico:

$$
E = u_h - u_{\rm esatto} = k_p\,h^p + k_{p+1}\,h^{p+1} + k_{p+2}\,h^{p+2} + \dots
$$

Richardson **tronca al primo termine**, trascurando i contributi $O(h^{p+1})$. Il risultato è un
valore **migliorato** (di un ordine più accurato di $u_h$) ma **non esatto**: l'errore residuo è
quello dei termini buttati via. Le altre approssimazioni che giustificano il $\approx$: $k$ assunta
**uguale** sulle due griglie, $p$ assunto **pari** a quello vero, più la contaminazione da
**round-off** e da convergenza iterativa imperfetta. Da qui "**stima** (estrapolazione)", non
"calcolo".

#### Q2 — Grafico: come varia l'ordine di convergenza, regione asintotica vs transitorio iniziale

![Ordine di convergenza: errore in funzione di h (log–log)](images/ordine_convergenza_loglog.png)

In scala **log–log** ($\log E = \log k + p\log h$) la **pendenza** è l'ordine $p$. Su **griglie rade**
($h$ grande, **regione pre-asintotica**, in arancione) i termini di ordine superiore non sono
trascurabili e la pendenza osservata è **diversa** (qui più bassa: $p\approx0.19$) da quella teorica.
**Raffinando** ($h\to0$, **regione asintotica**, in verde) la curva si dispone **parallela** alla
retta ideale di pendenza $p=1$ ($p$ locale che sale a $0.76$, $0.90$, …).

> ⚠️ Il "**transitorio iniziale**" qui è quello sulle **griglie rade** (convergenza **spaziale** di
> griglia, $E$ vs $h$): **non** confonderlo col transitorio dei **residui vs iterazioni**, che è la
> convergenza **temporale** verso lo stazionario. Sono due cose diverse.

#### Q3 — Perché proprio il **root mean square** dell'entropia? E quel $|\Omega_i|$ è un valore assoluto?

Sì, $\bar S$ è l'**entropia adimensionale** ($\bar S = \gamma\ln\bar T - (\gamma-1)\ln\bar P$),
riferita a zero, quindi coincide con l'errore locale. Si usa l'**RMS** (valore quadratico medio) per
ridurre il *campo* d'errore a **un solo scalare** confrontabile tra griglie:
- il **quadrato** impedisce che errori locali di segno opposto si **cancellino** (come farebbe una
  media semplice) e pesa di più gli scostamenti grandi;
- la **radice** riporta tutto alle unità di $\bar S$;
- la **media** (divisione per l'area totale) lo rende un valore *tipico per cella*, indipendente dal
  **numero** di celle.

$|\Omega_i|$ **non è un valore assoluto** (modulo di un numero con segno): è la **misura della cella**
$\Omega_i$ — la sua **area** (2D) o **volume** (3D), per definizione positiva. Pesare $\bar S_i^2$ con
$|\Omega_i|$ rende la somma una **quadratura** dell'integrale $\int_\Omega \bar S^2\,d\Omega$:
senza il peso, le tante celle piccole di una zona raffinata sarebbero sovra-rappresentate. In breve è
la versione **discreta, pesata sul volume e mediata** della norma $L_2$ continua.

#### Q4 — Nella dimostrazione (ordine teorico), perché sembra che $u_{h_1}$ venga "trascurato"?

Non viene trascurato — anzi è il **termine principale**. Riscrivendo la formula:

$$
u_{\rm esatto} \approx \underbrace{u_{h_1}}_{\text{valore fine}} + \underbrace{\frac{u_{h_1}-u_{h_2}}{r^p-1}}_{\text{stima dell'errore } E_1}
$$

l'estrapolazione **parte** dalla soluzione sulla griglia **più fine** $u_{h_1}$ (la migliore che
abbiamo) e le **somma** la stima dell'errore residuo per "proiettare" verso $h\to0$. Nella forma
compatta $u_{\rm esatto}\approx (r^p u_{h_1}-u_{h_2})/(r^p-1)$: per $r^p\gg1$ il peso di $u_{h_1}$
**domina** e $u_{\rm esatto}\to u_{h_1}$; $u_{h_2}$ (griglia rada) entra **solo nella correzione**.
"Estrapolare verso $h\to0$" = correggere il valore fine, non scartarlo.

#### Q5 — Perché si va sempre verso una mesh **più rada**? Non sarebbe più comodo un rapporto di **infittimento**?

Hai ragione sul piano progettuale: **in pratica si infittisce** (si parte rada e si raffina:
$l_c=0.02\to0.01\to\dots$, cioè $h$ **diminuisce**). Il punto è che **l'ordine in cui esegui le
simulazioni è irrilevante**: per Richardson le **riordini a posteriori** rispetto ad $h$ e le
etichetti nel modo più comodo. La convenzione fissa come **riferimento la griglia più fine** $h_1$ e
scrive le altre come multipli $h_2 = r\,h_1$ con **$r>1$** (quindi $h_2$ più rada). Perché questo
ordine è "comodo"? Perché **l'estrapolazione è una correzione applicata alla soluzione migliore**:
si parte da $u_{h_1}$ (la più accurata) e si guarda di quanto cambia andando verso la rada.

- Definire un **rapporto di infittimento** $r'=h_1/h_2<1$ sarebbe **del tutto equivalente** (basta
  mettere $1/r$ nelle formule): pura convenzione, la matematica non cambia.
- Il tuo esempio $0.02\to0.01$ è infatti un **infittimento** ($h$ dimezzato); per Richardson lo leggi
  ponendo $h_1=0.01$ (fine), $h_2=0.02$ (rada), $r=h_2/h_1=2>1$.

In una riga: **infittisci per ottenere le griglie, ma descrivi il salto col rapporto di diradamento
$r>1$ riferito alla più fine**.

#### Q6 — Cosa vuol dire che $k$ dipende dal **problema**? Set diversi di mesh danno $k$ diversi?

$k$ **non è universale**. Dall'analisi dell'errore di troncamento (Taylor), $k$ è proporzionale alle
**derivate di ordine elevato della soluzione esatta** (per uno schema del 1° ordine, le derivate
seconde del campo) per coefficienti propri dello schema. Quindi $k$ dipende da:
- **schema** (Roe e LF, stesso $p=1$, hanno $k$ diversi → errori diversi a parità di $h$);
- **problema = geometria + condizioni al contorno + regime**: sono questi a fissare la soluzione e
  quindi le sue derivate. Geometria con curvature/gradienti più forti → derivate maggiori → $k$
  maggiore. "Dipende dal problema" significa **questo, non la singola mesh**;
- **non** da $h$ (è fattorizzato in $h^p$), purché si sia nel regime asintotico.

**Set diversi di 2 mesh → $k$ diverse?**
- **In regime asintotico** (raffinamento self-simile): *circa la stessa* $k$ (è proprietà di
  schema + problema).
- **Fuori dal regime asintotico** (mesh rade, come il bump): **sì, $k$ apparente cambia** da coppia a
  coppia, perché il fit a **un solo termine** $k h^p$ deve **assorbire** i termini di ordine superiore
  trascurati, che pesano diversamente a $h$ diversi. Per questo $k$ non si riusa altrove e non
  interessa calcolarla: in entrambe le modalità viene **eliminata**.

*(Discusso anche nel report: `Latex/teoria.tex` §"Da che cosa dipende la costante $k$" e
`Latex/bump.tex` §"Perché l'ordine effettivo è basso e perché $k$ cambia".)*

#### Q7 — Perché l'inaffidabilità dell'ordine effettivo "permette" di usare il teorico? Causa dell'ordine basso? È un problema?

Non è che "l'effettivo inaccurato **autorizza** il teorico": è una questione di **affidabilità della
stima**. L'ordine effettivo è una **misura** dai dati; se i dati sono **pre-asintotici** la misura è
**rumorosa** e l'estrapolazione che ne segue è inaffidabile. Allora ci si appoggia a un'informazione
**a priori** più solida:
- se **conosci la soluzione esatta** (bump, $\bar S_{\rm esatto}=0$): la usi **direttamente** (ordine
  dalla pendenza log–log, niente estrapolazione);
- altrimenti **assumi l'ordine teorico** come stima ingegneristica (sai che lo schema è formalmente
  del 1° ordine e che $p\to1$ raffinando) → lo usi come **prior** al posto di una misura troppo
  rumorosa.

**Perché l'ordine pratico è basso?** Griglie non abbastanza fini (regione pre-asintotica, causa
principale), **mesh non uniforme** (stretching/Bump/progressione), **effetti di bordo**, dissipazione
non lineare/limitatori.

**È un problema? Si risolve?** Non è un bug (codice validato) e non impedisce la convergenza
(monotòna, errori piccoli, GCI ~0.3%). Vuol dire solo che la stima **rigorosa** dell'ordine su quelle
griglie è incerta. Rimedi: **raffinare ancora** (costoso), raffinamento **self-simile/uniforme**,
oppure **schema di ordine più alto**. In sintesi: l'effettivo è preferibile *quando è affidabile*;
quando non lo è, ci si affida al teorico o alla soluzione esatta.

*(Discusso anche nel report: `Latex/teoria.tex` §"Ordine effettivo più basso del teorico" e
`Latex/bump.tex`.)*

#### Q8 — Cosa vuol dire "**sottraendo a coppie**" nella dimostrazione dell'ordine effettivo?

Significa sottrarre le tre relazioni d'errore **a due a due**, per griglie **consecutive**. Partendo da

$$
u_h - u_{\rm esatto}=k h^p,\quad
u_{2h}-u_{\rm esatto}=2^p k h^p,\quad
u_{4h}-u_{\rm esatto}=4^p k h^p
$$

faccio (seconda − prima) e (terza − seconda): in ogni differenza **sparisce $u_{\rm esatto}$** (è in
tutte e tre con lo stesso segno):

$$
u_{2h}-u_h = k h^p(2^p-1),\qquad u_{4h}-u_{2h}=k h^p\,2^p(2^p-1)
$$

Il **rapporto** di queste due differenze elimina anche $k h^p$ e lascia solo $2^p$:

$$
\frac{u_{4h}-u_{2h}}{u_{2h}-u_h}=2^p \;\;\Longrightarrow\;\; p=\frac{\ln\!\big(\frac{u_{4h}-u_{2h}}{u_{2h}-u_h}\big)}{\ln 2}
$$

"A coppie" = abbinamenti consecutivi; serve proprio a **cancellare $u_{\rm esatto}$** prima, e
**$k h^p$** poi.

</details>

<details>
<summary><strong>🟩 [E] Discutere la simulazione della paletta (LS59)</strong></summary>

> 📌 *Risposta da compilare* (parte del punto d'esame originale, separata). Riferimento:
> `Latex/paletta.tex`, `teoria/report_QA.md` (Domande 1–4), cartelle `Paletta/`, `Fluent/`.
> Da trattare: cascata di turbina LS59 transonica, campi di Mach/pressione, scia al bordo di fuga,
> $y^+$, setup della simulazione.

</details>

<details>
<summary><strong>🟩 [E] Differenze con il caso RANS (Eulero vs RANS, p.es. sulla paletta)</strong></summary>

> 📌 *Risposta da compilare* (parte del punto d'esame originale, separata).
> ❓ *Da chiarire a cosa si riferisce esattamente "il caso RANS"* (paletta? presa?): plausibilmente
> il confronto **Eulero vs RANS** sulla paletta. Riferimento: `teoria/report_QA.md` (Domande 17, 19),
> `Latex/fluent.tex`, `Latex/paletta.tex`. Da trattare: cosa coglie il RANS che Eulero ignora
> (strato limite, separazione, scia viscosa, SBLI), e perché.

</details>

<details>
<summary><strong>🟩 [E] Estrapolazione di Richardson, metodi diretti, $p_{wall}$ per la presa a doppia rampa e campo di moto generico per la LS59</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/doppia_presa.tex`, `Latex/paletta.tex`,
> `Rampa/conv/`, `teoria/report_QA.md` (Domande 5–12, 16–19). Da trattare: convergenza sulla presa,
> "metodi diretti" (soluzione esatta nota vs estrapolazione), pressione a parete $p_w/p^\circ$ con
> i salti d'urto, e campo di moto della LS59.

</details>

<details>
<summary><strong>🟩 [E] Eulero stima bene il lift ma non la drag della paletta — perché?</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/paletta.tex`, `teoria/report_QA.md`.
> Idea attesa: il **lift** è dominato dalla **distribuzione di pressione** (ben colta anche da un
> modello inviscido), mentre la **drag** ha una forte componente **viscosa/d'attrito** e di scia che
> **Eulero non riproduce** (drag inviscida ≈ solo onda/pressione, manca lo skin friction).

</details>

<details>
<summary><strong>🟩 [E] Descrizione di ciò che si è eseguito e macro-differenze fra bump (dosso), paletta e presa</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `README.md` (tabella casi di studio), `Latex/bump.tex`,
> `Latex/paletta.tex`, `Latex/doppia_presa.tex`. Da trattare: i **tre regimi** (subsonico $M=0.3$,
> transonico $M=0.5$, supersonico $M=3$), urti/assenza di urti, mesh, scopo di ciascun caso.

</details>

<details>
<summary><strong>🟩 [E] Confronto Eulero vs RANS per la pala: cosa ci aspettavamo, riscontro dalla simulazione, confronti sull'analisi di convergenza (idem per la presa, meno dettagliato)</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/paletta.tex`, `Latex/fluent.tex`,
> `teoria/report_QA.md`. Da trattare: aspettative teoriche, accordo/disaccordo riscontrato,
> confronto delle analisi di convergenza pala vs presa.

</details>

<details>
<summary><strong>🟩 [E] Bump: commento sui campi di moto e confronto Lax–Friedrichs vs Roe sull'errore</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/bump.tex` (campi Mach/pressione Roe vs LF,
> tabelle norma entropia), `Bump/conv/`. Aggancio diretto col toggle Richardson qui sopra (Roe più
> accurato di LF sulle griglie fini).

</details>

<details>
<summary><strong>🟩 [E] LS59 (campo di moto e risultati)</strong></summary>

> 📌 *Risposta da compilare.* Riferimento: `Latex/paletta.tex`, `Fluent/`, `teoria/report_QA.md`
> (Domande 1–4).

</details>
