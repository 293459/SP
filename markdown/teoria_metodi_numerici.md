# Metodi Numerici — Teoria & Simulazione d'esame

> Risposte alle domande di teoria 7–9. Le domande 7 e 8 sono **domande di organizzazione**:
> chiedono dove collocare alcuni argomenti nella suddivisione del Notion. La 9 è concettuale.
> Formato toggle Notion; **parole chiave** in grassetto.

---

## Premessa — la suddivisione attuale del Notion

| Pagina Notion | Cosa contiene (natura) |
|---|---|
| **Fluid dynamics** | Equazioni di governo, caratteristiche, natura iperbolica/ellittica |
| **Numerical Methods (ODE)** | Integrazione **nel tempo**: errori, stabilità, espliciti/impliciti, stadi/passi/stencil |
| **Finite Volumes Schemes** | Discretizzazione **nello spazio**: volumi finiti, Godunov, flux splitting, Roe |
| **Meshing** | Generazione e qualità della griglia |
| **Turbolence** | RANS/LES/DNS |
| **Reacting Flows** | Combustione |

La chiave per collocare un metodo è chiedersi: **discretizza il tempo o lo spazio?**

---

## Simulazione domande d'esame

<details>
<summary><strong>Domanda 7 — Il blocco "metodi impliciti ed espliciti, WENO, Discontinuous Galerkin, ecc.": dove andrebbe inserito a livello logico nella suddivisione del Notion?</strong></summary>

Il blocco **non è omogeneo**: contiene cose che discretizzano il **tempo** e cose che
discretizzano lo **spazio**. Vanno quindi separate.

- **Metodi espliciti / impliciti** → pagina **Numerical Methods (ODE)**, nella sezione già
  esistente *"Passi, espliciti-impliciti, stadi e stencil"*. La dicotomia esplicito/implicito è
  infatti una proprietà dell'**integrazione temporale** (la $\mathbf{u}^{n+1}$ dipende solo dal
  passato → esplicito; dipende anche da sé stessa → implicito, richiede un sistema). È lo stesso
  asse concettuale di Eulero in avanti vs all'indietro e di Runge–Kutta.
  - *Collegamento:* la **regione di assoluta stabilità** (già presente nel Notion) è proprio ciò
    che distingue espliciti (stabilità condizionata, vincolo CFL) e impliciti (spesso A-stabili).

- **WENO** (*Weighted Essentially Non-Oscillatory*) → pagina **Finite Volumes Schemes**. È una
  tecnica di **ricostruzione spaziale ad alto ordine** dei valori all'interfaccia: appartiene alla
  famiglia che nasce per **aggirare il teorema barriera di Godunov** (vedi Domanda 8). Logicamente
  va come sottosezione *"Schemi ad alta risoluzione / ricostruzione"*, vicino a limitatori e MUSCL.

- **Discontinuous Galerkin (DG)** → anch'esso **discretizzazione spaziale**, ma di natura
  ibrida (elementi finiti + volumi finiti) con rappresentazione **polinomiale a tratti
  discontinua** dentro ogni cella. Logicamente va in **Finite Volumes Schemes** come metodo
  ad alto ordine "parente" dei FV (condivide i **flussi numerici** di Riemann all'interfaccia),
  oppure in una pagina dedicata *"Metodi ad alto ordine"* se l'argomento cresce.

**In sintesi:** esplicito/implicito → *Numerical Methods (ODE)*; WENO e DG → *Finite Volumes
Schemes* (sezione ricostruzione/alto ordine). La regola: **tempo → ODE, spazio → Finite Volumes**.

</details>

<details>
<summary><strong>Domanda 8 — Il teorema barriera di Godunov, i limitatori di pendenza e il calcolo del gradiente all'interfaccia/al centro cella: dove vanno inseriti logicamente?</strong></summary>

Tutti e tre appartengono alla pagina **Finite Volumes Schemes**, perché riguardano la
**ricostruzione spaziale** e l'**accuratezza** dello schema ai volumi finiti. Idealmente in una
sottosezione *"Schemi ad alta risoluzione"* posta **dopo** Godunov e Roe.

- **Teorema barriera di Godunov** (*order barrier theorem*): afferma che uno schema **lineare**
  e **monotono** (che non crea nuove oscillazioni) può essere **al massimo del primo ordine**. È la
  motivazione teorica di tutto ciò che viene dopo: per avere **alto ordine senza oscillazioni**
  bisogna usare schemi **non lineari** (limitatori, WENO). Logicamente è il "ponte" tra lo schema
  di Godunov del primo ordine e i metodi ad alta risoluzione → va subito dopo *"Godunov & Problema
  di Riemann"*.

- **Limitatori di pendenza** (*slope limiters*, es. minmod, van Leer, superbee): sono il modo
  **pratico** di aggirare il teorema. Ricostruiscono una **pendenza lineare** dentro la cella
  (schema MUSCL, secondo ordine) ma la **limitano** vicino a discontinuità/estremi per non creare
  overshoot (proprietà **TVD**). Vanno nella stessa sottosezione *"Alta risoluzione"*, come
  applicazione diretta del teorema barriera.

- **Gradiente all'interfaccia e al centro cella**: è il calcolo del **gradiente** necessario sia
  per la ricostruzione (passare dal valore medio di cella al valore all'**interfaccia**, dove si
  valuta il flusso) sia per i termini diffusivi/viscosi. Logicamente va vicino alla **ricostruzione
  spaziale** e alla distinzione **cella-centrata vs nodo-centrata** (già presente nel Notion, sez.
  *"Celle Centrate vs Nodi Centrati"*), perché il *come* si calcola il gradiente dipende da dove
  sono collocate le incognite.

**Filo logico suggerito nella pagina Finite Volumes:**
Godunov (1° ordine) → **Teorema barriera** → necessità di non-linearità → **ricostruzione +
gradienti** → **limitatori di pendenza** (TVD) → WENO (Domanda 7).

</details>

<details>
<summary><strong>Domanda 9 — Perché i metodi upwind sono "iperbolici" e quelli centrati "ellittici"?</strong></summary>

La risposta sta nel **rispetto del dominio di dipendenza fisico**: uno schema numerico è "adatto"
a un'equazione quando il suo **stencil** (le celle che usa) ricalca il modo in cui
l'informazione si propaga in quell'equazione.

**Equazioni iperboliche** (es. advezione, Eulero supersonico): l'informazione viaggia lungo le
**linee caratteristiche** con **velocità finita** e **direzione ben precisa** (a valle, dentro il
cono di Mach). Il **dominio di dipendenza** di un punto è solo ciò che sta **a monte** lungo le
caratteristiche. Lo schema **upwind** usa i valori provenienti dalla **direzione da cui arriva il
segnale**:

$$
u_i^{n+1} = u_i^n - \frac{a\Delta t}{\Delta x}\left(u_i^n - u_{i-1}^n\right) \quad (a>0)
$$

cioè guarda **all'indietro**, verso $i-1$. Questo **rispetta la causalità fisica** e introduce
una **dissipazione numerica** che stabilizza lo schema. Un centrato puro, su un'iperbolica
del primo ordine, è invece **instabile** (porta informazione anche da valle, dove non dovrebbe).
Per questo gli schemi **upwind** (Godunov, Roe) sono la scelta naturale per problemi **iperbolici**.

**Equazioni ellittiche** (es. Laplace/Poisson, pressione nel flusso incomprimibile, regime
subsonico): **non esistono direzioni privilegiate** di propagazione. Una perturbazione in un punto
si fa sentire **istantaneamente e in tutte le direzioni**: il **dominio di dipendenza è l'intero
dominio**. Lo schema appropriato è quindi **centrato e simmetrico**, perché tratta allo stesso
modo i vicini da ogni lato:

$$
\frac{u_{i-1} - 2u_i + u_{i+1}}{\Delta x^2} = f_i
$$

Uno schema upwind (asimmetrico) su un'ellittica introdurrebbe una **direzionalità artificiale**
che non ha senso fisico.

**Collegamento con il report (doppia rampa):** è esattamente per questo che, se nel dominio
comparisse una **tasca subsonica**, le equazioni di Eulero stazionarie cambierebbero natura da
**iperbolica** (supersonico) a **ellittica** (subsonico), richiedendo un trattamento diverso delle
condizioni al contorno all'outlet. Ed è anche il motivo per cui il **metodo di proiezione di
Chorin** (Domanda 6) deve risolvere un'**equazione di Poisson ellittica** per la pressione:
l'incomprimibilità ha natura ellittica.

**In una frase:** *upwind = direzionale = rispetta le caratteristiche delle iperboliche;
centrato = simmetrico = rispetta l'isotropia di propagazione delle ellittiche.*

</details>
