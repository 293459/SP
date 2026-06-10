## Parte teorica (riassunto)

I **flussi reagenti** descrivono fluidi in cui avvengono **reazioni chimiche** (tipicamente
combustione) che rilasciano calore e modificano la composizione. Rispetto a un flusso inerte si aggiungono: 
(i) **equazioni di trasporto delle specie**, 
(ii) un **termine sorgente chimico**
fortemente non lineare, 
(iii) l'accoppiamento con l'**energia** tramite il calore di reazione.
La difficoltà centrale è la **enorme separazione di scale temporali** tra la chimica (velocissima) e il trasporto/mescolamento (lento), che rende il problema **stiff** e introduce il concetto di **collo di bottiglia** (tempo limitante).

---

## Simulazione domande d'esame

<details>
<summary><strong>Domanda 1 — Quali sono i termini e le variabili che compaiono nelle equazioni dei flussi reagenti? Spiega il significato fisico di ciascuna variabile.</strong></summary>

Le equazioni di governo di un flusso reagente sono le equazioni di **Navier–Stokes** estese con
il **trasporto delle specie** e un termine sorgente chimico. In forma compatta:

$$
\frac{\partial \rho}{\partial t} + \nabla\cdot(\rho \mathbf{u}) = 0
$$

$$
\frac{\partial (\rho \mathbf{u})}{\partial t} + \nabla\cdot(\rho \mathbf{u}\otimes\mathbf{u}) = -\nabla p + \nabla\cdot \boldsymbol{\tau}
$$

$$
\frac{\partial (\rho Y_k)}{\partial t} + \nabla\cdot(\rho \mathbf{u} Y_k) = \nabla\cdot(\rho D_k \nabla Y_k) + \dot{\omega}_k
$$

$$
\frac{\partial (\rho E)}{\partial t} + \nabla\cdot(\rho \mathbf{u} H) = \nabla\cdot(\lambda \nabla T) + \dot{Q}
$$

Significato fisico delle variabili principali:

- $\rho$ — **densità** della miscela. In combustione varia molto (il gas combusto è caldo e leggero, $\rho$ cala anche di 5–7 volte).
- $\mathbf{u}$ — **campo di velocità** del fluido.
- $p$ — **pressione**; $\boldsymbol{\tau}$ è il **tensore degli sforzi viscosi**.
- $Y_k$ — **frazione di massa** della specie $k$ (es. combustibile, ossidante, prodotti). Per definizione $\sum_k Y_k = 1$. È la variabile che descrive la **composizione locale**.
- $\dot{\omega}_k$ — **tasso di produzione/consumo chimico** della specie $k$ (kg·m⁻³·s⁻¹). È il **termine sorgente** delle reazioni: positivo per i prodotti, negativo per i reagenti. È il termine **più critico e non lineare**.
- $D_k$ — **coefficiente di diffusione** della specie $k$ (trasporto molecolare per gradiente di concentrazione, legge di Fick).
- $E$, $H$ — **energia** ed **entalpia totale** specifiche; includono l'entalpia di formazione delle specie.
- $\dot{Q}$ — **calore rilasciato** dalle reazioni (legato a $\dot{\omega}_k$ tramite le entalpie di formazione $\Delta h_{f,k}^\circ$).
- $\lambda$ — **conducibilità termica**; $T$ — **temperatura**, che governa la velocità delle reazioni.

Il termine sorgente segue tipicamente una cinetica di **Arrhenius**:

$$
\dot{\omega}_k \propto A\, T^{\beta}\, \exp\!\left(-\frac{E_a}{R T}\right) \prod_j [X_j]^{n_j}
$$

dove $A$ è il **fattore pre-esponenziale**, $E_a$ l'**energia di attivazione**, $\beta$ l'esponente di temperatura, $[X_j]$ le concentrazioni molari e $n_j$ gli ordini di reazione. La dipendenza **esponenziale dalla temperatura** è ciò che rende la chimica estremamente sensibile e veloce: piccole variazioni di $T$ cambiano $\dot\omega$ di ordini di grandezza.

Altre grandezze ricorrenti:
- **Rapporto di equivalenza** $\phi$: rapporto combustibile/ossidante normalizzato allo stechiometrico ($\phi=1$ stechiometrico, $\phi<1$ magro, $\phi>1$ ricco).
- **Velocità di fiamma laminare** $S_L$ e **spessore di fiamma** $\delta_L$: scale caratteristiche del fronte di combustione.

</details>

<details>
<summary><strong>Domanda 2 — Il "collo di bottiglia": chi è il tempo limitante tra quello chimico e quello di mixing turbolento? Quali sono le casistiche possibili?</strong></summary>

In un flusso reagente turbolento la combustione richiede **due passaggi in serie**: prima i
reagenti devono **mescolarsi** a livello molecolare (governato dalla **turbolenza** e dalla
diffusione), poi devono **reagire** (governato dalla **cinetica chimica**). Trattandosi di
processi in **serie**, la velocità complessiva è dettata dal **più lento dei due**: questo è il
**collo di bottiglia** (rate-limiting step).

Si definiscono due **scale temporali**:
- **tempo chimico** $\tau_c$ — tempo necessario alle reazioni per completarsi (≈ $\delta_L/S_L$);
- **tempo di mixing turbolento** $\tau_t$ — tempo con cui i vortici portano i reagenti a contatto (es. $\tau_t = k/\varepsilon$, tempo di rotazione dei grandi vortici).

Il loro rapporto è il **numero di Damköhler**:

$$
\mathrm{Da} = \frac{\tau_t}{\tau_c} = \frac{\text{tempo di mescolamento}}{\text{tempo chimico}}
$$

**Casistiche possibili:**

| Regime | Condizione | Chi limita | Comportamento |
|---|---|---|---|
| **Chimica veloce** | $\mathrm{Da} \gg 1$ ($\tau_c \ll \tau_t$) | il **mixing** turbolento | La reazione è quasi istantanea appena i reagenti si toccano: la combustione è **controllata dalla miscelazione** (*mixed-is-burnt*). È il regime dei modelli **Eddy Break-Up / Eddy Dissipation**. Il fronte è sottile (**flamelet**). |
| **Chimica lenta** | $\mathrm{Da} \ll 1$ ($\tau_c \gg \tau_t$) | la **chimica** | I reagenti si mescolano molto prima di reagire: il sistema tende a un **reattore perfettamente miscelato** (*well-stirred reactor*). Rilevante per spegnimento, formazione inquinanti (NOx), accensione. |
| **Da intermedio** | $\mathrm{Da} \sim 1$ | entrambi confrontabili | Regime più complesso: la turbolenza può **ispessire o estinguere** localmente la fiamma (*thickened/quenched flame*). Richiede modelli che tengano conto di **entrambe** le scale. |

Il punto chiave: poiché il processo globale procede alla velocità del passo più lento, **conoscere quale dei due tempi domina** dice quale fisica modellare con cura e quale si può semplificare. Da qui anche il problema della **stiffness**: quando $\tau_c \ll \tau_t$ il sistema di ODE chimiche ha scale temporali estremamente diverse e richiede integratori impliciti.

</details>

<details>
<summary><strong>Domanda 3 — Qual è la differenza tra flussi premiscelati e non premiscelati?</strong></summary>

La distinzione riguarda **dove e quando** combustibile e ossidante vengono messi a contatto.

**Fiamme premiscelate** (*premixed*): combustibile e ossidante sono **già miscelati** a livello
molecolare **prima** di entrare nella zona di reazione (es. fiamma del fornello con aria primaria,
motori a benzina SI). La combustione avviene attraverso un **fronte di fiamma sottile** che si
propaga nella miscela fresca a velocità $S_L$. La variabile naturale è la **variabile di
avanzamento** (*progress variable*) $c$, che va da $0$ (gas fresco) a $1$ (gas combusto).

**Fiamme non premiscelate / diffusive** (*non-premixed*): combustibile e ossidante arrivano
**separati** e bruciano **dove si incontrano per diffusione** (es. candela, fiamma diesel, motori
a razzo). La reazione è confinata sulla **superficie stechiometrica** dove $\phi=1$. La variabile
naturale è la **frazione di miscela** (*mixture fraction*) $Z$, che vale $1$ nel getto di
combustibile e $0$ nell'ossidante; la fiamma sta dove $Z = Z_{st}$.

| Aspetto | Premiscelata | Non premiscelata |
|---|---|---|
| Miscelazione | a monte, prima della reazione | sul posto, per diffusione |
| Variabile chiave | progress variable $c$ | mixture fraction $Z$ |
| Posizione fiamma | si propaga ($S_L$) | ancorata su $Z=Z_{st}$ |
| Controllo | cinetica + propagazione | mixing/diffusione |
| Sicurezza | rischio **flashback/detonazione** | intrinsecamente più sicura |
| Esempi | SI engine, fornello Bunsen | diesel, candela, razzo |

Esiste anche il caso **parzialmente premiscelato**, in cui coesistono entrambi i meccanismi
(es. liftoff di getti, stratificazione di carica).

</details>

<details>
<summary><strong>Domanda 4 — Qual è il problema alla base? Cosa si vuole calcolare e perché?</strong></summary>

Il **problema di base** dei flussi reagenti è risolvere il **campo di moto accoppiato alla
chimica**: si vuole determinare simultaneamente **velocità, pressione, temperatura e
composizione** ($Y_k$) di un fluido in cui avvengono reazioni che **rilasciano calore** e
**cambiano la densità**.

**Cosa si vuole calcolare** (output di interesse ingegneristico):
- il **campo di temperatura** e il **calore rilasciato** → dimensionamento termico, raffreddamento;
- la **posizione e stabilità del fronte di fiamma** → evitare spegnimento, flashback, instabilità termoacustiche;
- la **composizione dei prodotti**, in particolare gli **inquinanti** (NOx, CO, soot) → normative ed emissioni;
- l'**efficienza di combustione** e la **spinta/potenza** del sistema propulsivo.

**Perché è difficile (e perché serve un trattamento dedicato):**
1. Il **termine sorgente chimico** $\dot\omega_k$ è **fortemente non lineare** (Arrhenius esponenziale) e introduce **stiffness** (scale temporali da $10^{-9}$ s a $1$ s nello stesso sistema).
2. Esiste un **accoppiamento bidirezionale**: la chimica scalda il fluido → cambia $\rho$ e il moto → cambia il mixing → cambia la chimica.
3. In regime **turbolento**, il termine medio $\overline{\dot\omega_k}$ **non** è funzione delle sole grandezze medie ($\overline{\dot\omega}(\bar T) \neq \overline{\dot\omega(T)}$ per la non linearità): nasce il **problema di chiusura** del termine di reazione, cuore della modellistica della combustione turbolenta.

In sintesi: si calcola un campo termo-fluidodinamico-chimico accoppiato perché **da esso dipendono prestazioni, sicurezza ed emissioni** del sistema propulsivo, e lo si fa con metodi speciali perché la chimica rende il problema stiff e non chiuso.

</details>

<details>
<summary><strong>Domanda 5 — Spiega i metodi presentati per la risoluzione dei flussi premiscelati e non: cosa si vuole calcolare, l'idea di base, l'implementazione e qualche formula.</strong></summary>

**Cosa si vuole calcolare:** il **termine sorgente medio di reazione** $\overline{\dot\omega}$ (e
quindi il calore rilasciato e la composizione) in modo da poter chiudere le equazioni RANS/LES
senza risolvere ogni dettaglio della chimica.

**Idea di base comune:** invece di trasportare tutte le specie con la loro cinetica completa
(costosissimo e stiff), si **riduce il problema a poche variabili scalari** che descrivono lo
stato della combustione, e si **pre-tabella** la chimica.

### A) Fiamme NON premiscelate — approccio a *mixture fraction* $Z$

- **Idea:** se la chimica è veloce ($\mathrm{Da}\gg1$), lo stato locale dipende solo da **quanto** combustibile e ossidante si sono mescolati, cioè da $Z$. Tutte le grandezze ($T$, $Y_k$) diventano **funzioni di $Z$**: $Y_k = Y_k(Z)$.
- **Implementazione:** si trasporta una sola equazione di convezione-diffusione per $Z$ (senza sorgente, perché $Z$ è un **invariante conservato**):

$$
\frac{\partial (\rho Z)}{\partial t} + \nabla\cdot(\rho \mathbf{u} Z) = \nabla\cdot(\rho D \nabla Z)
$$

- In turbolenza si introduce la **PDF** (Probability Density Function) di $Z$, spesso una **$\beta$-PDF** parametrizzata da media $\tilde Z$ e varianza $\widetilde{Z''^2}$, e si **mediano** le grandezze:

$$
\tilde Y_k = \int_0^1 Y_k(Z)\, \tilde P(Z)\, dZ
$$

- Modelli: **fiamma laminare congelata** (*flamelet*, modello SLFM), che tabula $Y_k(Z,\chi)$ in funzione anche dello *scalar dissipation rate* $\chi$ (effetto di stiramento/estinzione).

### B) Fiamme PREMISCELATE — approccio a *progress variable* $c$

- **Idea:** lo stato va da gas fresco ($c=0$) a combusto ($c=1$); si trasporta la **variabile di avanzamento** $c$. Il fronte si propaga a $S_L$.
- **Implementazione (Eddy Break-Up / Eddy Dissipation):** quando $\mathrm{Da}\gg1$ il rate è controllato dal **mixing turbolento**, quindi:

$$
\overline{\dot\omega}_c \approx C_{EBU}\, \frac{\bar\rho}{\tau_t}\, \tilde c\,(1-\tilde c), \qquad \tau_t = \frac{k}{\varepsilon}
$$

cioè la reazione procede alla velocità con cui i vortici (scala $k/\varepsilon$) mescolano fresco e combusto, **indipendentemente** dai dettagli cinetici.

- **Modelli a densità di superficie di fiamma** (*Flame Surface Density*) o **G-equation** (level-set): si traccia il fronte come un'isosuperficie che si propaga a $S_T$ (velocità turbolenta).

### Filo conduttore
In entrambi i casi si **disaccoppia** la chimica (pre-tabulata in funzione di $Z$ o $c$) dal
trasporto turbolento (risolto nel CFD). Questo trasforma un problema stiff e non chiuso in poche
equazioni di trasporto di scalari + una **look-up table**, riducendo enormemente il costo.

</details>

<details>
<summary><strong>Domanda 6 — Perché il metodo di Chorin si chiama "metodo di proiezione"? In cosa consiste?</strong></summary>

Il **metodo di Chorin** (1968) è un metodo per risolvere le **Navier–Stokes incomprimibili** (e
si usa nella combustione a basso Mach, dove la densità varia per il calore ma il flusso è
acusticamente incomprimibile). Si chiama **metodo di proiezione** perché si basa su un teorema di
**decomposizione ortogonale** dei campi vettoriali.

**Il problema:** nelle NS incomprimibili la pressione **non ha un'equazione di evoluzione
propria**; il suo ruolo è solo quello di **garantire il vincolo di incomprimibilità**
$\nabla\cdot\mathbf{u}=0$. Velocità e pressione sono accoppiate da questo vincolo, ed è difficile
trattarle insieme.

**Idea (decomposizione di Helmholtz–Hodge):** qualunque campo vettoriale si può scomporre in modo
**unico e ortogonale** nella somma di un campo **a divergenza nulla** (solenoidale) e del
**gradiente di uno scalare**:

$$
\mathbf{u}^* = \mathbf{u} + \nabla \phi, \qquad \nabla\cdot\mathbf{u}=0
$$

Il metodo "**proietta**" un campo di velocità provvisorio sullo **spazio dei campi a divergenza
nulla**, eliminando la sua parte irrotazionale (il gradiente). Da qui il nome.

**In cosa consiste (i tre passi):**

1. **Passo di predizione.** Si avanza la quantità di moto **ignorando** (o usando una stima vecchia del) gradiente di pressione, ottenendo una velocità intermedia $\mathbf{u}^*$ che in generale **non** è a divergenza nulla:

$$
\frac{\mathbf{u}^* - \mathbf{u}^n}{\Delta t} = -(\mathbf{u}^n\cdot\nabla)\mathbf{u}^n + \nu \nabla^2 \mathbf{u}^n
$$

2. **Passo di proiezione / correzione di pressione.** Si impone che la velocità finale $\mathbf{u}^{n+1}$ sia solenoidale. Prendendo la divergenza della relazione $\mathbf{u}^{n+1} = \mathbf{u}^* - \Delta t\,\nabla p$ e ponendo $\nabla\cdot\mathbf{u}^{n+1}=0$ si ottiene una **equazione di Poisson per la pressione**:

$$
\nabla^2 p = \frac{1}{\Delta t}\, \nabla\cdot \mathbf{u}^*
$$

3. **Correzione della velocità.** Si **proietta** $\mathbf{u}^*$ sottraendo il gradiente di pressione appena calcolato:

$$
\mathbf{u}^{n+1} = \mathbf{u}^* - \Delta t\, \nabla p
$$

ottenendo finalmente un campo **a divergenza nulla**.

**Perché funziona / vantaggio:** disaccoppia il calcolo di velocità e pressione. Il costo si
concentra nella **soluzione dell'equazione di Poisson** (ellittica) per la pressione, che è il
"prezzo" dell'incomprimibilità — coerente con il fatto che in regime incomprimibile/subsonico le
informazioni si propagano in **tutte le direzioni** (natura ellittica, vedi anche la domanda
sugli schemi centrati). La pressione agisce qui come un **moltiplicatore di Lagrange** che fa
rispettare il vincolo $\nabla\cdot\mathbf u=0$.

</details>
