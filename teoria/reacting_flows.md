# Flussi Reagenti — Trattazione teorica

> Trattazione esaustiva dei **flussi reagenti** (combustione e dissociazione). Le domande
> del capitolo e i commenti d'esame degli appunti sono integrati nel testo; le caselle
> **📝 Nota d'esame** riportano le osservazioni utili discusse a lezione. Il **metodo di
> Chorin**, presente per refuso negli appunti di questo capitolo, è stato spostato nella
> teoria del report (sezione *Solutori Density-Based e Pressure-Based*), cui appartiene
> logicamente.

---

## 1. Inquadramento: cosa sono e dove compaiono

I **flussi reagenti** descrivono fluidi in cui avvengono **reazioni chimiche** che
rilasciano (o assorbono) calore e **modificano la composizione** della miscela. Il caso
tipico è la **combustione** in un combustore, ma non l'unico.

> 📝 **Nota d'esame.** I flussi reagenti **non servono solo nel combustore**: compaiono
> anche nel **supersonico/ipersonico**, dove gli **urti** fanno salire fortemente la
> temperatura e possono innescare la **dissociazione** delle molecole (es. $O_2$, $N_2$ che
> si dissociano dietro un urto forte). Anche questa è chimica accoppiata al campo di moto.

Un flusso reagente generale ha **tre caratteristiche** che lo complicano rispetto a un
flusso ideale:

| Caratteristica | Conseguenza |
|---|---|
| **Comprimibile** | densità variabile (il gas combusto è caldo e leggero, $\rho$ cala anche di 5–7×) |
| **Viscoso** | servono i termini diffusivi (sforzi, conduzione, diffusione di specie) |
| **Reagente** | compaiono il **trasporto delle specie** e un **termine sorgente chimico** |

Rispetto a un flusso **inerte** si aggiungono quindi: (i) le **equazioni di trasporto delle
specie**, (ii) un **termine sorgente chimico** fortemente non lineare, (iii) l'accoppiamento
con l'**energia** tramite il calore di reazione. La difficoltà centrale è l'**enorme
separazione di scale temporali** tra la chimica (velocissima) e il trasporto/mescolamento
(lento), che rende il problema **stiff** e introduce il concetto di **collo di bottiglia**
(tempo limitante, §4).

---

## 2. Equazioni di governo

Si descrive la miscela con **$N_S$ specie chimiche**, ciascuna caratterizzata dalla sua
**frazione di massa**
$$
Y_i = \frac{m_i}{m}, \qquad \sum_{i=1}^{N_S} Y_i = 1 .
$$
Le $Y_i$ sono le variabili che descrivono la **composizione locale**. Le equazioni di
governo sono le **Navier–Stokes** estese con il **trasporto delle specie** e i relativi
termini sorgente.

### 2.1 Continuità globale (massa)

$$
\frac{\partial \rho}{\partial t} + \nabla\cdot(\rho \mathbf{u}) = 0
$$

La massa **totale** si conserva: le reazioni chimiche trasformano specie in altre specie ma
non creano né distruggono massa.

### 2.2 Trasporto delle specie chimiche

Per ogni specie $i$ vale una legge di conservazione che, a differenza della massa globale,
ha **un termine diffusivo e un termine sorgente** (la specie viene prodotta/consumata e si
diffonde):

$$
\boxed{\;\frac{\partial (\rho Y_i)}{\partial t} + \nabla\cdot(\rho \mathbf{u}\, Y_i)
= -\,\nabla\cdot \mathbf{J}_i + \dot{\omega}_i\;}
\qquad i = 1,\dots,N_S
$$

I quattro termini sono: accumulo locale, **convezione** (trasporto col flusso), **diffusione
molecolare** $-\nabla\cdot\mathbf{J}_i$ e **sorgente chimico** $\dot\omega_i$ (§3).

> 📝 **Nota d'esame — chiusura del sistema delle specie.** Di solito **non** si risolvono
> tutte le $N_S$ equazioni: se ne risolvono **$N_S-1$** e l'ultima specie si ricava dal
> vincolo $\sum_i Y_i = 1$, sostituendola di fatto con la **conservazione della massa
> globale** (che è automaticamente soddisfatta). In pratica si **elide l'equazione della
> specie in concentrazione maggiore** (tipicamente $N_2$ nell'aria): la specie *dominante*
> assorbe l'errore di chiusura senza problemi. **Non** si elide una specie minore, perché
> ricavarla per differenza la espone a **valori negativi** non fisici (errori numerici che,
> sottratti da $1$, possono far diventare negativa una piccola $Y_i$).

#### 🔎 Domanda — Il termine diffusivo è il gradiente di $\mathbf{J}$? Come è definito $\mathbf{J}$?

Una precisazione preliminare: il termine $-\nabla\cdot\mathbf{J}_i$ compare nell'**equazione
di trasporto delle specie**, *non* in quella della quantità di moto (lì il termine diffusivo
è $\nabla\cdot\boldsymbol{\tau}$, la divergenza del tensore degli sforzi viscosi). È un
punto facile da confondere perché entrambe sono equazioni di trasporto con struttura
analoga.

Detto questo: il termine diffusivo è la **divergenza** (non il gradiente) di $\mathbf{J}_i$,
cioè $-\nabla\cdot\mathbf{J}_i$, dove $\mathbf{J}_i$ è il **flusso diffusivo di massa della
specie $i$** — un **vettore** con unità di kg·m⁻²·s⁻¹. Fisicamente $\mathbf{J}_i$ è la
quantità di specie $i$ che attraversa l'unità di area nell'unità di tempo **per pura
diffusione molecolare**, cioè rispetto alla velocità media di massa $\mathbf{u}$ (al netto
del trasporto convettivo, già contenuto nel termine $\nabla\cdot(\rho\mathbf{u}Y_i)$).

La sua definizione di base è la **legge di Fick** (diffusione per gradiente di
concentrazione):
$$
\mathbf{J}_i = -\,\rho D_i\,\nabla Y_i
\qquad\Longrightarrow\qquad
-\nabla\cdot\mathbf{J}_i = \nabla\cdot(\rho D_i \nabla Y_i),
$$
con $D_i$ **coefficiente di diffusione** della specie $i$. Il segno meno dice che la specie
si muove **da dove è concentrata verso dove è rarefatta** (gradiente discendente). Tre
proprietà importanti:

- **Somma nulla:** $\sum_i \mathbf{J}_i = 0$. I flussi diffusivi sono definiti *rispetto alla
  velocità di massa*, quindi globalmente non trasportano massa netta (coerente col fatto che
  la diffusione non viola la continuità globale).
- **Forma completa:** la legge di Fick è l'approssimazione più semplice. In generale
  $\mathbf{J}_i$ include la **diffusione multicomponente** (equazioni di Stefan–Maxwell), la
  **termodiffusione** (effetto Soret, diffusione per gradiente di temperatura) e la
  diffusione per gradiente di pressione.
- **Numero di Lewis:** il rapporto tra diffusione termica e diffusione di massa,
  $Le = \alpha/D_i$, è un parametro chiave; molti modelli assumono $Le=1$ (diffusività
  uguali) per semplificare la chiusura.

### 2.3 Quantità di moto

$$
\frac{\partial (\rho \mathbf{u})}{\partial t} + \nabla\cdot(\rho \mathbf{u}\otimes\mathbf{u})
= \nabla\cdot\boldsymbol{\sigma},
\qquad \boldsymbol{\sigma} = \boldsymbol{\tau} - p\,\mathbf{I}
$$

dove $\boldsymbol{\sigma}$ è il **tensore degli sforzi totale**, somma del tensore degli
sforzi **viscosi** $\boldsymbol{\tau}$ e del contributo di **pressione** $-p\,\mathbf{I}$.
La struttura è identica a quella di un flusso inerte: la chimica entra nella quantità di moto
solo **indirettamente**, cambiando $\rho$ e le proprietà di trasporto attraverso la
temperatura.

### 2.4 Energia ed entalpia

In forma di **energia totale** $E$ (energia interna + cinetica per unità di massa):

$$
\frac{\partial (\rho E)}{\partial t} + \nabla\cdot(\rho \mathbf{u} E)
= \nabla\cdot(\boldsymbol{\sigma}\cdot\mathbf{u}) - \nabla\cdot\mathbf{q}_T - \nabla\cdot\mathbf{q}_m
$$

con i tre termini a secondo membro: **lavoro degli sforzi** $\nabla\cdot(\boldsymbol\sigma\cdot\mathbf u)$,
**flusso di calore conduttivo** $\mathbf{q}_T = -\lambda\nabla T$ (Fourier) e **flusso di
energia per diffusione di specie** $\mathbf{q}_m = \sum_i h_i \mathbf{J}_i$ (ogni specie che
diffonde trasporta la propria entalpia). L'energia totale specifica è la somma pesata delle
energie interne di specie più l'energia cinetica:

$$
E = \sum_{i=1}^{N_S} Y_i\, e_i + \tfrac{1}{2}\,\mathbf{u}^2 .
$$

#### 🔎 Domanda — Perché si passa da trattazioni basate sull'energia a trattazioni basate sull'entalpia? Qual è il vantaggio?

Nella combustione si preferisce riscrivere il bilancio energetico in termini di **entalpia**
anziché di energia interna. La relazione tra le due è
$$
h_i = e_i + \frac{p}{\rho},
$$
e l'entalpia di **una specie** si scompone in due contributi:
$$
h_i = \underbrace{h^\circ_{f,i}}_{\text{entalpia di formazione}}
   + \underbrace{\int_{T_0}^{T} c_{p,i}(T')\,dT'}_{\text{entalpia sensibile}} .
$$
Cioè: **entalpia = entalpia di formazione in uno stato standard (a $T_0$) + variazione di
entalpia "sensibile"** dovuta al riscaldamento. (L'energia interna ha una struttura analoga,
$e_i = h^\circ_{f,i} + \int c_{v,i}\,dT - \tfrac{p}{\rho}$, ma è meno comoda.)

I **vantaggi** dell'entalpia in questo contesto sono:

1. **La combustione avviene quasi sempre a pressione (quasi) costante.** Nei combustori a
   basso Mach la pressione varia poco; a $p$ costante il calore scambiato è esattamente la
   variazione di entalpia ($\delta q = dh$). L'entalpia è quindi la **variabile naturale** del
   problema, mentre l'energia interna sarebbe naturale a volume costante (caso raro).

2. **Sparisce il termine sorgente chimico esplicito nell'equazione dell'energia.** È il
   vantaggio decisivo. Se si usa l'entalpia **assoluta** (formazione + sensibile), il calore
   di reazione è **già contabilizzato** dentro le $h^\circ_{f,i}$ delle specie trasportate:
   una reazione esotermica si limita a **convertire entalpia di formazione in entalpia
   sensibile** (le specie cambiano, ma l'entalpia totale della miscela si conserva). Di
   conseguenza l'equazione dell'**entalpia totale è priva del termine sorgente**
   $\dot Q$ — non bisogna calcolare esplicitamente il rilascio di calore, che emerge
   automaticamente dal cambio di composizione. Lavorando invece con energia *sensibile* si
   dovrebbe aggiungere a mano una sorgente $\dot Q = -\sum_i h^\circ_{f,i}\dot\omega_i$,
   fonte di errori e di accoppiamento aggiuntivo.

3. **Comodità nel trasporto e nella convezione.** Il flusso di energia convettivo nelle
   equazioni comprimibili coinvolge naturalmente l'**entalpia totale** $H = E + p/\rho$ (il
   termine $\nabla\cdot(\rho\mathbf u H)$): usare $H$ evita di portarsi dietro separatamente
   il lavoro di pressione $\nabla\cdot(p\mathbf u)$.

4. **Dati termodinamici tabulati in forma entalpica.** I polinomi NASA forniscono
   direttamente $c_p(T)$, $h(T)$ ed $s(T)$ per ogni specie: la formulazione entalpica si
   innesta senza conversioni.

> In sintesi: **passare all'entalpia (assoluta) rende l'equazione dell'energia "source-free"
> rispetto alla chimica** e allinea la trattazione al fatto che la combustione è un processo
> a pressione costante. Il calore di reazione non scompare: è "nascosto" nelle entalpie di
> formazione delle specie che si trasportano.

---

## 3. Cinetica chimica e termine sorgente

Il termine sorgente $\dot\omega_i$ è il cuore — e la difficoltà — dei flussi reagenti: è il
termine **più non lineare** e quello che introduce la **stiffness**.

### 3.1 $\dot\omega_i$: "velocità di reazione" o tasso di produzione/consumo?

#### 🔎 Domanda — $\dot\omega_i$ è la velocità di reazione o il tasso di consumo/produzione di una specie? Sono la stessa cosa?

Sono **concetti correlati ma, a rigore, distinti**; vengono spesso confusi (e negli appunti
del corso la formula di $\dot\omega_i$ è etichettata "velocità di reazione"). La distinzione
precisa è:

- **Velocità (o rateo) di reazione** $q_j$ — è una proprietà **della singola reazione** $j$.
  Misura *quanto velocemente avanza quella reazione* (rate of progress), in
  mol·m⁻³·s⁻¹. È la quantità $[\,K_f\prod[X]^{\nu^R} - K_b\prod[X]^{\nu^P}\,]$ tra parentesi
  nella formula del §3.2: una sola reazione, un solo numero.

- **Tasso di produzione/consumo della specie** $\dot\omega_i$ — è una proprietà **della
  specie** $i$. Misura *quanta massa (o moli) di $i$ vengono nette prodotte o consumate per
  unità di volume e tempo*, kg·m⁻³·s⁻¹ (positivo per i prodotti, negativo per i reagenti).

Il legame tra i due è che $\dot\omega_i$ è la **somma, su tutte le reazioni**, del rateo di
ciascuna reazione pesato sul **coefficiente stechiometrico netto** della specie in quella
reazione:
$$
\dot\omega_i = M_i \sum_{j=1}^{N_r} (\nu^P_{ij} - \nu^R_{ij})\, q_j .
$$
Quindi:

| | Velocità di reazione $q_j$ | Tasso di specie $\dot\omega_i$ |
|---|---|---|
| Riferita a | una **reazione** | una **specie** |
| Quante ce ne sono | $N_r$ (una per reazione) | $N_S$ (una per specie) |
| Segno | sempre orientata (avanti $-$ indietro) | $+$ prodotti, $-$ reagenti |
| Relazione | grandezza "primaria" | combinazione lineare delle $q_j$ |

In parole: la **velocità di reazione** è *quanto corre una reazione*; il **tasso della
specie** è *l'effetto netto su una data specie* sommando tutte le reazioni che la
coinvolgono. Sono uguali solo nel caso banale di **una sola reazione con coefficiente
unitario** per quella specie. Nell'uso comune (e negli appunti) il termine "velocità di
reazione" viene esteso anche a $\dot\omega_i$, ma è bene tenerne presente la differenza
concettuale.

### 3.2 La formula del rateo di reazione spiegata termine per termine

#### 🔎 Domanda — Puoi spiegare bene la formula del rateo di reazione?

Per un meccanismo di $N_r$ reazioni tra $N_S$ specie, il tasso di produzione/consumo della
specie $i$ è:

$$
\dot\omega_i = \sum_{j=1}^{N_r} \big(\nu^P_{ij} - \nu^R_{ij}\big)
\left[\;
\underbrace{K_{f,j} \prod_{s=1}^{N_S}\Big(\frac{\rho_s}{M_s}\Big)^{\nu^R_{sj}}}_{\text{reazione diretta}}
\;-\;
\underbrace{K_{b,j} \prod_{s=1}^{N_S}\Big(\frac{\rho_s}{M_s}\Big)^{\nu^P_{sj}}}_{\text{reazione inversa}}
\;\right]
$$

Analizziamo **ogni pezzo** (cos'è, da dove viene, come agisce):

- **$\displaystyle\sum_{j=1}^{N_r}$ — somma sulle reazioni.** Una specie partecipa in
  genere a **più reazioni** del meccanismo; il suo tasso netto è la **somma** dei contributi
  di tutte. *Effetto:* accoppia tutte le reazioni che toccano la specie $i$.

- **$(\nu^P_{ij} - \nu^R_{ij})$ — coefficiente stechiometrico netto** della specie $i$ nella
  reazione $j$ ($\nu^P$ = coefficiente come **prodotto**, $\nu^R$ = come **reagente**).
  *Da dove viene:* dal **bilanciamento stechiometrico** della reazione. *Effetto:* converte
  "quanto avanza la reazione" in "quante moli di $i$ compaiono/spariscono"; è **positivo** se
  $i$ è netto prodotto, **negativo** se netto reagente, **zero** se $i$ è spettatore.

- **$K_{f,j}$ e $K_{b,j}$ — costanti cinetiche** diretta (*forward*) e inversa (*backward*).
  *Da dove vengono:* dalla legge di **Arrhenius** (§3.3); dipendono **fortemente dalla
  temperatura**. *Effetto:* fissano la *scala di velocità* della reazione.

- **$\displaystyle\prod_{s=1}^{N_S}\big(\rho_s/M_s\big)^{\nu^R_{sj}}$ — legge di azione di
  massa per la reazione diretta.** $\rho_s/M_s = [X_s]$ è la **concentrazione molare**
  (mol/m³) della specie $s$ (densità parziale diviso massa molare). Il prodotto è esteso a
  tutte le specie, ma poiché $\nu^R_{sj}=0$ per chi non è reagente, contano **solo i
  reagenti**, ciascuno elevato al proprio coefficiente (ordine di reazione).
  *Da dove viene:* dalla **legge di azione di massa** — la velocità di reazione è
  proporzionale alla **frequenza degli urti** tra le molecole reagenti, che a sua volta è
  proporzionale al **prodotto delle loro concentrazioni**. *Effetto:* più reagenti ci sono,
  più la reazione corre; se un reagente si esaurisce ($[X_s]\to0$), il termine si annulla.

- **$K_{b,j}\prod(\rho_s/M_s)^{\nu^P_{sj}}$ — reazione inversa**, analoga ma sui **prodotti**.
  *Effetto:* tiene conto della **reversibilità**: i prodotti possono ricombinarsi nei
  reagenti.

- **La parentesi $[\,\text{diretta} - \text{inversa}\,] = q_j$** è il **rateo netto** della
  reazione $j$: differenza tra "avanti" e "indietro". *Effetto:* all'**equilibrio chimico**
  le due velocità si pareggiano, $q_j=0$ e la specie non cambia più; fuori equilibrio il
  segno dice in che verso procede la reazione.

In sintesi la formula nasce dalla composizione di **tre ingredienti fisici**: la
**stechiometria** (coefficienti $\nu$), la **cinetica** (costanti $K_f,K_b$ alla Arrhenius)
e la **legge di azione di massa** (prodotti di concentrazioni). La sua forte **non
linearità** (prodotti di potenze delle concentrazioni × esponenziale della temperatura) è
ciò che rende il termine sorgente così difficile da trattare in un flusso turbolento (§6).

### 3.3 La legge di Arrhenius

Le costanti cinetiche seguono l'**approccio di Arrhenius**:

$$
K_{f,j} = A_j\, T^{\beta_j}\, \exp\!\left(-\frac{E_{a,j}}{R\,T}\right),
\qquad
K_{b,j} = \frac{K_{f,j}}{K_{eq,j}(T)} .
$$

- **$A_j$ — fattore pre-esponenziale** (o di frequenza): rappresenta la **frequenza degli
  urti** e il fattore sterico (orientamento favorevole all'urto).
- **$T^{\beta_j}$ — correzione di temperatura** (debole, legge di potenza) della frequenza
  d'urto; $\beta_j$ è piccolo.
- **$\exp(-E_{a,j}/RT)$ — fattore di Boltzmann**: è la **frazione di urti con energia
  superiore all'energia di attivazione** $E_{a,j}$. È il termine **dominante** ed è
  responsabile della **sensibilità esponenziale alla temperatura**: piccole variazioni di
  $T$ cambiano $K_f$ (e quindi $\dot\omega$) di **ordini di grandezza**. È la radice della
  stiffness e del fatto che la fiamma sia un fronte sottilissimo e ipersensibile.
- **$K_{b,j}$** si ricava dalla **costante di equilibrio** $K_{eq}(T)$ (dati
  termodinamici), garantendo che a equilibrio le velocità diretta e inversa coincidano.

### 3.4 Tempi caratteristici, tabella e stiffness

Il **tempo caratteristico delle reazioni chimiche** $\tau_c$ misura quanto impiega la
reazione a completarsi. **Può essere estremamente piccolo**: per la combustione
$\text{H}_2$–$\text{O}_2$ si ha $\tau_c \approx 10^{-6}\,\text{s}$.

#### 🔎 Domanda — Una tabella con i tempi di reazione tipici di sostanze comuni

Valori **indicativi** (ordini di grandezza) del tempo chimico $\tau_c$, utili per avere
"contezza numerica" del fenomeno. Per confronto, il tempo di **mixing turbolento** tipico è
$\tau_t \sim 10^{-3}$–$10^{-2}\,$s (§4):

| Sistema / reazione | $\tau_c$ tipico | Commento |
|---|---|---|
| **Idrogeno–ossigeno** ($\text{H}_2$–$\text{O}_2$) | $\sim 10^{-6}\,$s | combustione **velocissima**, chimica quasi istantanea |
| **Idrocarburi leggeri** ($\text{CH}_4$–aria, metano) | $\sim 10^{-3}\,$s | più lenta dell'idrogeno (catena di reazioni più lunga) |
| **Ossidazione del CO** ($\text{CO}\to\text{CO}_2$) | $\sim 10^{-3}$–$10^{-2}\,$s | **step lento** dell'ossidazione degli idrocarburi |
| **Idrocarburi pesanti** (cherosene, ottano, diesel) | $\sim 10^{-4}$–$10^{-3}\,$s | rilevante per ritardo d'accensione *(ignition delay)* |
| **Formazione NOₓ termici** (meccanismo di Zeldovich) | $\sim 10^{-1}$–$1\,$s | **molto lenta** → chimica limitante, chiave per gli inquinanti |
| **Formazione soot** (particolato) | $\sim 10^{-3}$–$10^{-2}\,$s | cinetica lenta e complessa |
| *(confronto)* **mixing turbolento** $\tau_t = k/\varepsilon$ | $\sim 10^{-3}$–$10^{-2}\,$s | scala dei grandi vortici |

La tabella rende evidente il punto del §4: per l'$\text{H}_2$ la chimica è $\sim10^3$–$10^4$
volte più veloce del mixing ($\mathrm{Da}\gg1$, fiamma **limitata dalla miscelazione**),
mentre per gli **NOₓ** la chimica è **più lenta** del mixing ($\mathrm{Da}\ll1$, formazione
**limitata dalla chimica**): ecco perché gli inquinanti si modellano con cinetica dettagliata
e non con i modelli "mixed-is-burnt".

> 📝 **Nota d'esame — stiffness e scelta dell'integratore.** Quando $\tau_c$ è piccolissimo,
> il sistema di ODE chimiche ha **scale temporali enormemente diverse** ed è **stiff**:
> - uno schema **esplicito** sarebbe vincolato a un passo $\sim\tau_c$ piccolissimo →
>   **numericamente impraticabile** (instabile o lentissimo);
> - lo schema **implicito è di fatto l'unica soluzione** per l'integrazione temporale della
>   chimica; il maggior costo per passo è accettabile, anche perché spesso i **termini
>   chimici** vengono **disaccoppiati** (operator splitting) e integrati a parte.
>
> Inoltre: anche se il **CFL fluidodinamico** permettesse un passo temporale ampio, la
> **chimica veloce impone un passo molto minore**, rendendo stiff l'intero problema
> accoppiato. Conseguenza pratica: se si forza un passo grande, la **diffusione numerica**
> dello schema fluidodinamico **cresce enormemente**, degradando la soluzione.

---

## 4. Il collo di bottiglia: il numero di Damköhler

In un flusso reagente turbolento la combustione richiede **due passaggi in serie**: prima i
reagenti devono **mescolarsi** a livello molecolare (governato da turbolenza e diffusione),
poi devono **reagire** (governato dalla cinetica). Essendo processi **in serie**, la velocità
complessiva è dettata dal **più lento dei due**: è il **collo di bottiglia**
(*rate-limiting step*).

Si definiscono due **scale temporali**:
- **tempo chimico** $\tau_c$ — tempo di completamento delle reazioni ($\approx \delta_L/S_L$,
  rapporto tra spessore e velocità di fiamma laminare);
- **tempo di mixing turbolento** $\tau_t$ — tempo con cui i vortici portano i reagenti a
  contatto, $\tau_t = k/\varepsilon$ (tempo di rotazione dei grandi vortici; $k$ energia
  cinetica turbolenta, $\varepsilon$ sua dissipazione).

Il loro rapporto è il **numero di Damköhler**:
$$
\mathrm{Da} = \frac{\tau_t}{\tau_c} = \frac{\text{tempo di mescolamento}}{\text{tempo chimico}} .
$$

| Regime | Condizione | Chi limita | Comportamento |
|---|---|---|---|
| **Chimica veloce** | $\mathrm{Da}\gg1$ ($\tau_c\ll\tau_t$) | il **mixing** turbolento | Reazione quasi istantanea appena i reagenti si toccano: combustione **controllata dalla miscelazione** (*mixed-is-burnt*). Regime dei modelli **Eddy Break-Up / Eddy Dissipation**. Fronte sottile (**flamelet**). |
| **Chimica lenta** | $\mathrm{Da}\ll1$ ($\tau_c\gg\tau_t$) | la **chimica** | I reagenti si mescolano molto prima di reagire: tende a un **reattore perfettamente miscelato** (*well-stirred reactor*). Rilevante per spegnimento, **inquinanti (NOₓ)**, accensione. |
| **Da intermedio** | $\mathrm{Da}\sim1$ | **entrambi** | La turbolenza può **ispessire o estinguere** localmente la fiamma (*thickened/quenched flame*). Servono modelli che tengano conto di entrambe le scale. |

Conoscere **quale dei due tempi domina** dice quale fisica modellare con cura e quale si può
semplificare. È anche la radice della **stiffness** (§3.4): quando $\tau_c\ll\tau_t$ le scale
temporali del sistema sono estremamente separate.

---

## 5. Fiamme premiscelate e non premiscelate

La distinzione riguarda **dove e quando** combustibile e ossidante vengono messi a contatto.

**Fiamme premiscelate** (*premixed*): combustibile e ossidante sono **già miscelati** a
livello molecolare **prima** di entrare nella zona di reazione (fornello con aria primaria,
motori a benzina SI). La combustione avviene attraverso un **fronte di fiamma sottile** che
si propaga nella miscela fresca a velocità $S_L$. Variabile naturale: la **variabile di
avanzamento** (*progress variable*) $c$, da $0$ (gas fresco) a $1$ (gas combusto).

**Fiamme non premiscelate / diffusive** (*non-premixed*): combustibile e ossidante arrivano
**separati** e bruciano **dove si incontrano per diffusione** (candela, fiamma diesel,
razzo). La reazione è confinata sulla **superficie stechiometrica** dove $\phi=1$. Variabile
naturale: la **frazione di miscela** (*mixture fraction*) $Z$, che vale $1$ nel getto di
combustibile e $0$ nell'ossidante; la fiamma sta dove $Z = Z_{st}$.

| Aspetto | Premiscelata | Non premiscelata |
|---|---|---|
| Miscelazione | a monte, prima della reazione | sul posto, per diffusione |
| Variabile chiave | progress variable $c$ | mixture fraction $Z$ |
| Posizione fiamma | si propaga ($S_L$) | ancorata su $Z=Z_{st}$ |
| Controllo | cinetica + propagazione | mixing/diffusione |
| Sicurezza | rischio **flashback/detonazione** | intrinsecamente più sicura |
| Esempi | motore SI, Bunsen | diesel, candela, razzo |

Esiste anche il caso **parzialmente premiscelato**, in cui coesistono entrambi i meccanismi
(liftoff di getti, stratificazione di carica).

Grandezze ricorrenti: il **rapporto di equivalenza** $\phi$ (combustibile/ossidante
normalizzato allo stechiometrico: $\phi=1$ stechiometrico, $\phi<1$ magro, $\phi>1$ ricco);
la **velocità di fiamma laminare** $S_L$ e lo **spessore di fiamma** $\delta_L$.

---

## 6. Interazione chimica–turbolenza: i modelli

Il problema di chiusura nasce perché, in turbolenza, il termine sorgente **medio**
$\overline{\dot\omega}$ **non** è funzione delle sole grandezze medie: per la non linearità
di Arrhenius, $\overline{\dot\omega}(\bar T) \neq \overline{\dot\omega(T)}$. Bisogna quindi
**modellare** l'interazione tra la chimica e la turbolenza. Il modello dipende dal regime
(laminare/turbolento, $\mathrm{Da}$, premiscelato/non).

### 6.1 Lo schema generale dei modelli

#### 🔎 Domanda — Rifai lo schema che spiega i vari modelli di interazione chimica–turbolenza

```
                            INTEGRAZIONE CHIMICA–TURBOLENZA
                                       │
        ┌──────────────────────────────┴──────────────────────────────┐
        │                                                              │
    LAMINARE                                                      TURBOLENTO
        │                                                              │
        ▼                                            ┌─────────────────┴─────────────────┐
  Finite-Rate Model                                  │                                   │
  (Arrhenius diretto,                              DNS                                NO DNS
   cella per cella:                                  │                            (RANS / LES)
   nessuna chiusura                                  ▼                                   │
   turbolenta serve)                          Finite-Rate Chemistry         Modello di interazione
                                              (tutte le scale risolte,        CHIMICA–TURBOLENZA
                                               Arrhenius diretto:             (serve una CHIUSURA)
                                               nessuna modellazione                  │
                                               dell'interazione)        ┌────────────┴────────────┐
                                                                        │                         │
                                                                  PREMISCELATI            NON PREMISCELATI
                                                                        │                         │
                                                              • Eddy Dissipation        • Mixture fraction /
                                                                Model (EDM)               Flamelet + β-PDF
                                                              • Finite-Rate / EDM        • Flamelet Generated
                                                                (combinato)               Manifold (FGM)
                                                              • β-PDF (RANS +            • Thickened Flame
                                                                varianza)                  Model
```

**Logica dello schema (dall'alto in basso):**

- **Laminare → Finite-Rate Model.** Senza turbolenza non c'è problema di chiusura: si valuta
  il termine sorgente di Arrhenius **direttamente** cella per cella, con la composizione e la
  temperatura locali. È accurato ma costoso (stiff).

- **Turbolento → DNS → Finite-Rate Chemistry.** Se si fa **DNS** (tutte le scale turbolente
  risolte, niente modello di turbolenza), di nuovo si applica la cinetica **diretta**: non
  serve modellare l'interazione perché non c'è media da chiudere. È il riferimento "esatto"
  ma proibitivo per costo.

- **Turbolento → NO DNS (RANS/LES) → modello di interazione chimica–turbolenza.** Qui le
  scale turbolente sono **mediate/filtrate**: il termine sorgente medio è **non chiuso** e
  serve un **modello**, diverso a seconda che la fiamma sia **premiscelata** o **non
  premiscelata**.

### 6.2 Modelli per fiamme premiscelate

**Eddy Dissipation Model (EDM).** Combustione **limitata dal mixing turbolento**: si **assume
che la cinetica chimica sia molto più veloce** del mescolamento ($\mathrm{Da}\gg1$), quindi
il **collo di bottiglia è il mixing**. Il rate è controllato dal tempo dei vortici:
$$
\overline{\dot\omega}_c \approx C\,\frac{\bar\rho}{\tau_t}\,\tilde c(1-\tilde c),
\qquad \tau_t = \frac{k}{\varepsilon},
$$
dove $\tau_t = k/\varepsilon$ è il **tempo caratteristico della turbolenza** (il collo di
bottiglia), $k$ l'energia cinetica turbolenta, $\varepsilon$ la sua dissipazione. La reazione
procede alla velocità con cui i vortici mescolano fresco e combusto, **indipendentemente dai
dettagli cinetici** (*mixed-is-burnt*).

**Finite-Rate / Eddy-Dissipation (combinato).** Si calcolano **entrambi** i ratei — quello
**cinetico** (Arrhenius, finite-rate) e quello di **mixing** (EDM) — e si **sceglie il più
lento** dei due come limitante. *Motivo:* in alcune condizioni **non è evidente a priori
quale sia il collo di bottiglia**; prendendo il minimo non si fanno supposizioni e si copre
sia il regime mixing-limited sia quello kinetics-limited (es. accensione, spegnimento, dove
la chimica torna a contare).

**β-PDF.** Si usa la **RANS** per calcolare i **valori medi** dei campi (concentrazione,
temperatura, rapporto di miscela…), e si **aggiunge un modello** (equazioni di trasporto
extra) per stimarne la **varianza**. Con media e varianza si costruisce una **PDF** assunta
(tipicamente una **funzione β**) della variabile reattiva, e si **media** il rateo di
reazione su di essa:
$$
\overline{\dot\omega} = \int \dot\omega(\xi)\,\tilde P(\xi)\,d\xi,
\qquad \tilde P = \beta\text{-PDF}(\tilde\xi,\,\widetilde{\xi''^2}).
$$
In sintesi: **valori medi + varianza dei campi → velocità di reazione media**. È il modo di
recuperare la non linearità persa nella media (il problema $\overline{\dot\omega(T)}\neq
\dot\omega(\bar T)$).

### 6.3 Modelli per fiamme non premiscelate

**Mixture fraction / Flamelet + β-PDF.** Se la chimica è veloce ($\mathrm{Da}\gg1$), lo stato
locale dipende solo da **quanto** combustibile e ossidante si sono mescolati, cioè da $Z$:
tutte le grandezze diventano $Y_k=Y_k(Z)$, $T=T(Z)$. Si **trasporta una sola equazione** per
$Z$ (scalare **conservato**, senza sorgente):
$$
\frac{\partial(\rho Z)}{\partial t} + \nabla\cdot(\rho\mathbf u Z) = \nabla\cdot(\rho D\nabla Z),
$$
e si media con una **β-PDF** di $Z$ parametrizzata da media $\tilde Z$ e varianza
$\widetilde{Z''^2}$. I modelli **flamelet** (SLFM) tabulano $Y_k(Z,\chi)$ anche in funzione
dello *scalar dissipation rate* $\chi$ (stiramento/estinzione).

**Flamelet Generated Manifold (FGM).** Si **genera un database di fiamme laminari 1D** e si
usa una **tabella di look-up** per **interpolare** velocità di reazione e composizione in
funzione di **poche variabili locali** (rapporto di miscela, progress variable…). Trasforma la
chimica stiff in una semplice **interrogazione di tabella** durante il calcolo CFD.

**Thickened Flame Model.** Il fronte di fiamma reale è spesso **più sottile della cella di
griglia** e non sarebbe risolto. Allora si **ingrossa artificialmente la fiamma**:
$$
\text{si aumenta la diffusione } (D\to FD), \qquad
\text{si riduce il reaction rate } (\dot\omega\to \dot\omega/F),
$$
in modo da **mantenere invariata la velocità di propagazione** $S_L$ (che dipende da
$\sqrt{D\,\dot\omega}$). *Scopo:* "spalmare" la fiamma su più celle quando il suo spessore è
inferiore alla risoluzione di griglia, **evitando problemi numerici**, senza alterare la
fisica macroscopica della propagazione.

### 6.4 Filo conduttore comune

In tutti i modelli (RANS/LES) l'idea è **disaccoppiare** la chimica dal trasporto turbolento:
invece di trasportare tutte le specie con la cinetica completa (costosissimo e stiff), si
**riduce lo stato della combustione a poche variabili scalari** ($Z$, $c$, varianze) e si
**pre-tabella** la chimica (look-up table). Si trasforma così un problema **stiff e non
chiuso** in **poche equazioni di trasporto di scalari + una tabella**, abbattendo
drasticamente il costo.

---

## Simulazione domande d'esame

> Recap a domande aperte (autovalutazione). Le risposte estese sono nelle sezioni sopra.

<details>
<summary><strong>D1 — Quali sono i termini e le variabili delle equazioni dei flussi reagenti? Significato fisico di ciascuna.</strong></summary>

Vedi **§2**. Navier–Stokes estese: continuità (§2.1), **trasporto specie** con flusso
diffusivo $\mathbf J_i$ e sorgente $\dot\omega_i$ (§2.2), quantità di moto con
$\boldsymbol\sigma=\boldsymbol\tau-p\mathbf I$ (§2.3), energia/entalpia (§2.4). Variabili
chiave: $\rho$ (densità, varia molto), $\mathbf u$, $p$, $Y_i$ (frazioni di massa,
$\sum Y_i=1$), $\dot\omega_i$ (sorgente chimico, il termine più critico e non lineare),
$D_i$, $E$/$H$, $\lambda$, $T$. Sorgente alla **Arrhenius** (§3.3): dipendenza esponenziale
da $T$. Grandezze ricorrenti: $\phi$, $S_L$, $\delta_L$ (§5).

</details>

<details>
<summary><strong>D2 — Il "collo di bottiglia": chi limita tra tempo chimico e mixing turbolento? Casistiche.</strong></summary>

Vedi **§4**. Processi in **serie** → limita il più lento. Numero di **Damköhler**
$\mathrm{Da}=\tau_t/\tau_c$: $\mathrm{Da}\gg1$ → limita il **mixing** (mixed-is-burnt,
EDM/flamelet); $\mathrm{Da}\ll1$ → limita la **chimica** (well-stirred, NOₓ); $\mathrm{Da}
\sim1$ → entrambi (thickened/quenched). Radice della **stiffness**.

</details>

<details>
<summary><strong>D3 — Differenza tra flussi premiscelati e non premiscelati.</strong></summary>

Vedi **§5**. Premiscelati: combustibile+ossidante miscelati a monte, fronte che si propaga a
$S_L$, variabile **progress variable** $c$. Non premiscelati: arrivano separati, bruciano per
**diffusione** su $Z=Z_{st}$, variabile **mixture fraction** $Z$. Esiste il parzialmente
premiscelato.

</details>

<details>
<summary><strong>D4 — Qual è il problema alla base? Cosa si vuole calcolare e perché?</strong></summary>

Si vuole il **campo accoppiato moto–chimica**: velocità, pressione, temperatura e
composizione $Y_k$ di un fluido in cui le reazioni **rilasciano calore** e **cambiano la
densità**. Output ingegneristici: **campo di temperatura/calore** (dimensionamento termico),
**posizione e stabilità della fiamma** (evitare spegnimento, flashback, instabilità
termoacustiche), **inquinanti** (NOₓ, CO, soot → normative), **efficienza e spinta**.
È difficile per: (1) sorgente $\dot\omega$ **non lineare** e **stiff** (§3); (2)
**accoppiamento bidirezionale** chimica↔moto via densità; (3) **problema di chiusura** del
termine di reazione in turbolenza, $\overline{\dot\omega(T)}\neq\dot\omega(\bar T)$ (§6).

</details>

<details>
<summary><strong>D5 — Metodi per fiamme premiscelate e non: cosa si calcola, idea, implementazione, formule.</strong></summary>

Vedi **§6**. Si vuole il **termine sorgente medio** $\overline{\dot\omega}$ per chiudere
RANS/LES. **Non premiscelate**: approccio a **mixture fraction** $Z$ (scalare conservato) +
**β-PDF** + **flamelet/FGM** (tabelle). **Premiscelate**: approccio a **progress variable**
$c$ + **Eddy Dissipation** ($\overline{\dot\omega}_c\approx C\bar\rho\,\tilde c(1-\tilde
c)/\tau_t$, $\tau_t=k/\varepsilon$), **Finite-Rate/EDM** (si sceglie il più lento),
**Thickened Flame**. Filo conduttore: **disaccoppiare** la chimica (pre-tabulata) dal
trasporto turbolento.

</details>

> ℹ️ **Nota.** La domanda sul **metodo di proiezione di Chorin** che compariva qui negli
> appunti è stata **spostata nel report** (`Latex/teoria.tex`, sezione *Solutori
> Density-Based e Pressure-Based → Il metodo di proiezione di Chorin*): appartiene infatti
> alla teoria dei **solutori pressure/density-based** e non ai flussi reagenti.
