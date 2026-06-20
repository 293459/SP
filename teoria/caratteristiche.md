# Metodo delle caratteristiche

<details>
<summary><strong>Come leggere questa pagina (legenda) — apri qui</strong></summary>

L'intera pagina è organizzata in **toggle** (menù a tendina). Ogni toggle è
etichettato in modo esplicito (niente emoji da decifrare):

- **Inquadramento —** il "minimo indispensabile" della sezione (equazioni, idea).
- **Concetto —** chiarimento/risposta a un dubbio teorico.
- **Approfondimento —** dettaglio extra (utile ma non essenziale alla prima lettura).
- **Dimostrazione —** passaggi da saper rifare.
- **Figura —** grafico con commento.
- **Formule —** specchietto delle formule chiave.
- **Nomenclatura —** simboli.
- **Codice/Esercitazioni —** collegamento al solutore `Euler2D` / writeup.

I tag tra parentesi quadre tipo **[4]** rimandano alle domande poste nelle
richieste; la mappa completa è nell'ultimo toggle.

</details>

<details>
<summary><strong>Inquadramento — di cosa parla il capitolo</strong></summary>

Regime tipicamente **iperbolico** (supersonico per Eulero): l'informazione viaggia
lungo le **linee caratteristiche**, non ovunque. È il complemento di
[`bilancio.md`](bilancio.md) (leggi di conservazione e sistema di Eulero), da cui si
eredita la forma quasi-lineare $\partial_t U + A\,\partial_x U = 0$, $A=L\Lambda L^{-1}$.

Contenuti basati sul **Cap. 2 "Linee caratteristiche"** (appunti CFD, P. Pantò) +
[`bilancio.md`](bilancio.md). Le figure a mano del capitolo sono state **ridisegnate
in Python/SVG** (script [`images/caratteristiche_plots.py`](images/caratteristiche_plots.py));
quelle di pistone/Sod/BC di Eulero/parete sono estratte dal PDF.

</details>

<details>
<summary><strong>Nomenclatura — simboli usati</strong></summary>

| Simbolo | Nome | Note |
|---|---|---|
| $a$ | velocità di propagazione (scalare lineare) | $a=\partial f/\partial u$; per $f=au$ è costante |
| $u$ | grandezza **trasportata** | non necessariamente una velocità |
| $U=(u,v,\dots)$ | **incognite** = componenti della **grandezza conservativa** | una legge di conservazione per componente |
| $A$ | **matrice dei coefficienti** / Jacobiana del flusso | $U_t+A\,U_x=0$, $A=\partial F/\partial U$ |
| $A'$ | matrice dei coefficienti in **variabili primitive** | Eulero con $V=(\rho,u,p)$ o $(a,u,S)$: $V_t+A'V_x=0$ (stessa fisica di $A$) |
| $\lambda_k$ | **autovalori** di $A$ (velocità d'onda) | reali ⟺ iperbolico; Eulero $\{u-a,\ u,\ u+a\}$ |
| $\boldsymbol{\ell}_k$ *(grassetto)* | **autovettori sinistri** | $\boldsymbol{\ell}_k^{T}A=\lambda_k\boldsymbol{\ell}_k^{T}$; sono le **righe** di $L^{-1}$ |
| $\Lambda$ | **matrice diagonale** degli autovalori | $\Lambda=L^{-1}A\,L=\mathrm{diag}(\lambda_k)$ |
| $L^{-1},\ L$ | matrice degli **autovettori sinistri** / sua inversa | $W=L^{-1}U$ |
| $\varepsilon,\ \alpha^2$ | **segno** $(\pm1)$ e **coefficiente** $(>0)$ del sistema 2×2 | $\lambda=\pm\alpha\sqrt{\varepsilon}$ |
| $W=L^{-1}U$ | **variabili caratteristiche** | $dW_k=0$ lungo $dx/dt=\lambda_k$ |
| $\phi=\tfrac{\gamma-1}{2}$ | costante del gas politropico | $a/\phi=2a/(\gamma-1)$ |
| $J^{\pm}=\tfrac{a}{\phi}\pm u$ | **invarianti di Riemann** (omoentropico) | cost. lungo $u\pm a$ |
| $D/Dt$ | **derivata sostanziale/materiale** | $\partial_t+a\,\partial_x$ (1D) |
| $c,\ s=[\![f]\!]/[\![u]\!]$ | velocità dell'**urto** (Rankine–Hugoniot) | salto flusso / salto grandezza |
| $[\![\cdot]\!]$ | **salto** monte ↔ valle | $[\![q]\!]=q_B-q_A$ |
| $M=u/a$ | numero di **Mach** | $<1$ subsonico, $>1$ supersonico |

</details>

## 1. Equazione scalare lineare

<details>
<summary><strong>Inquadramento — l'equazione scalare lineare</strong></summary>

Singola equazione di trasporto (non un sistema), coefficienti che **non dipendono** dalla soluzione:

$$\frac{\partial u}{\partial t} + a\,\frac{\partial u}{\partial x} = 0,\qquad a=\text{cost}.$$

In forma di divergenza $\partial_t u+\partial_x f=0$; con la chain rule $\partial_x f=\frac{\partial f}{\partial u}\partial_x u$,
si riconosce $a=\partial f/\partial u$ (per $f=au$, $a$ costante → lineare). **$u$ non è necessariamente
una velocità**: è la grandezza trasportata; $a$ è la velocità di propagazione del segnale.

</details>

<details>
<summary><strong>Dimostrazione [16] — la linea caratteristica (scalare → sistema → multi-D)</strong></summary>

Cerco una curva $x(t)$ lungo cui la PDE diventi una **ODE**. La derivata totale di $u$ lungo una curva è

$$\frac{du}{dt}=\frac{\partial u}{\partial t}+\frac{dx}{dt}\,\frac{\partial u}{\partial x}.$$

Confronto con $u_t+a\,u_x=0$: **scelgo** $\dfrac{dx}{dt}=a\Rightarrow\dfrac{du}{dt}=0$. Lungo la retta
$x=x_0+at$ la soluzione è **costante** → $u(x,t)=u_0(x-at)$. Estensioni:
- scalare non lineare $\dfrac{dx}{dt}=f'(u)$; sistema $\dfrac{dx}{dt}=\lambda_k$;
- multi-D: superfici caratteristiche da $\det(\phi_t I+\sum_d A_d\phi_{x_d})=0$ → **cono di Mach**; la
  riduzione esatta a ODE vale pulita solo in 1D.

</details>

<details>
<summary><strong>Concetto [2] — cosa significa "derivata materiale con velocità $a$"</strong></summary>

La derivata **materiale** non prende $a$ "come input": è la derivata temporale **vista da un osservatore
che si muove col flusso**. In 1D, $\dfrac{Du}{Dt}=\partial_t u+a\,\partial_x u$. L'equazione scalare
lineare è $\dfrac{Du}{Dt}=0$: seguendo un punto a velocità $a$, la grandezza trasportata non cambia.
$a$ non è arbitrario: è **la** velocità di propagazione che compare nell'equazione.

</details>

<details>
<summary><strong>Concetto [3] — riferimento solidale al segnale (serve un termine $-a\,u_x$?)</strong></summary>

Cambio di variabili **galileiano**: $\xi=x-at,\ \tau=t$. Allora
$\partial_t|_x=\partial_\tau-a\,\partial_\xi$, $\partial_x=\partial_\xi$. Sostituendo:
$(u_\tau-a u_\xi)+a u_\xi=u_\tau=0$. Il termine $-a u_\xi$ **non lo aggiungi a mano**: esce dal cambio di
coordinate e **cancella** il convettivo → nel riferimento mobile il segnale è **fermo** ($u_\tau=0$).
Il riferimento a velocità **costante** $a$ è **ancora inerziale** (nessuna forza apparente: è solo
trasporto, non la 2ª legge di Newton). Fisicamente non cambia nulla: cambia il punto di vista.

</details>

<details>
<summary><strong>Figura — piano spazio–tempo [5][6][10][11][13]</strong></summary>

![Advezione lineare: piano x-t con caratteristiche parallele, punti A,B e piano x-u con la traslazione rigida](images/lc_scalare_lineare.svg)

- **[6]** Per $a$ costante le caratteristiche hanno la **stessa pendenza** $1/a$ → sono **parallele**.
- **[5]** Le linee disegnate hanno lunghezza finita solo per comodità: a rigore sono **infinite**.
- **[10]** La **freccia** verticale indica $t$ crescente: si legge dal basso (dato iniziale) verso l'alto.
- **[11]** $t_1,x_1$ **non** sono i limiti del dominio: $t_1$ è un **istante di osservazione** (taglio
  orizzontale), $x_1$ una **stazione**. I limiti veri sono i lati del rettangolo.
- **[13]** A e B sull'asse $t=0$ diventano A′,B′ a $t_1$; nel piano $(x,u)$ hanno lo **stesso valore di
  $u$**, **spostato nello spazio** di $\Delta x=a t_1$. I punti non cambiano valore: si traslano.

</details>

<details>
<summary><strong>Concetto [4] — interpretazione matematica e equazioni di compatibilità</strong></summary>

*Una caratteristica è una curva lungo cui le derivate, pur potendo essere discontinue, restano ben
definite.* Mettendo a sistema il **differenziale** $du=u_t\,dt+u_x\,dx$ e l'equazione di governo:

$$\begin{pmatrix}1 & a\\ dt & dx\end{pmatrix}\begin{pmatrix}u_t\\ u_x\end{pmatrix}=\begin{pmatrix}0\\ du\end{pmatrix},$$

con **Cramer** le derivate sono determinate **tranne** se $\det=dx-a\,dt=0$, cioè lungo $dx/dt=a$: lì le
derivate possono "saltare". **$du=0$ (compatibilità)** non significa $\partial_t u=\partial_x u=0$
singolarmente, ma che la **derivata direzionale** lungo la caratteristica è nulla → $u$ costante lungo di
essa (per i sistemi: $dW_k=0$).

</details>

<details>
<summary><strong>Figura [15] — campi di $\partial u/\partial x$ e $\partial u/\partial t$ (onda periodica)</strong></summary>

![Mappe (x,t) di u, du/dx, du/dt: iso-valori paralleli alle caratteristiche](images/lc_derivate_2d.svg)

![Superfici 3D di du/dx e du/dt costanti lungo le caratteristiche](images/lc_derivate_3d.png)

Gli **iso-valori** sono **paralleli alle caratteristiche**: ogni caratteristica porta un valore (costante
lungo di essa, diverso da una all'altra). Vale $\partial_t u=-a\,\partial_x u$. Nel caso **lineare** le
derivate restano finite; la **discontinuità vera** appare quando le caratteristiche **convergono**
(Burgers/urto, §2).

</details>

<details>
<summary><strong>Concetto [7][8][12][18] — condizioni al contorno (caso scalare)</strong></summary>

![Condizioni al contorno: a>0 BC a sinistra, a<0 BC a destra](images/lc_condizioni_contorno.svg)

Per conoscere $u$ in un punto $P$ **risalgo** la sua caratteristica all'indietro:
- se torno a $t=0$ **dentro** $[0,L]$ → valore dato dal **dato iniziale** (nessuna BC);
- se esco dal **bordo sinistro** ($x<0$) → valore fissato da quel bordo → **serve BC a sinistra**
  $u(0,t)=g(t)$.

Il bordo **destro** non dà problemi: lì le caratteristiche **escono** (info dall'interno verso l'esterno),
$u$ si ottiene incrociando la caratteristica → **nessuna BC**.
- **[7]** $a>0$ → caratteristiche da sinistra a destra → BC a **sinistra**. $a<0$ → risalgono → BC a
  **destra**. Entrambi i segni hanno senso fisico ($a$ = direzione di propagazione).
- **[12]** Regola generale: *# BC su un bordo = # caratteristiche **entranti***. Per Eulero decide quali
  grandezze (p/u/T) imporre nei vari regimi → §8 e `report_QA.md` (Domande 12–13).

</details>

<details>
<summary><strong>Concetto [1] — perché si chiamano "iperboliche"? (e fuori dal caso iperbolico?)</strong></summary>

La classificazione dipende dal numero di **caratteristiche reali**:

| Tipo | Caratteristiche reali | Propagazione |
|---|---|---|
| **Iperbolica** | due famiglie reali | ondosa, velocità finita |
| Parabolica | una (degenere) | diffusiva |
| Ellittica | nessuna (complesse) | nessuna direzione privilegiata |

Per i sistemi 1° ordine: iperbolico ⟺ $A$ **diagonalizzabile con autovalori reali** ⟺ esistono $n$
famiglie di caratteristiche reali. Le caratteristiche reali **sono** la definizione di iperbolicità. Nel
caso **ellittico** gli autovalori sono complessi → niente caratteristiche reali (dominio di dipendenza
esteso). Quindi non puoi avere caratteristiche reali propagative in un problema genuinamente ellittico.

</details>

## 2. Equazione scalare non lineare (Burgers inviscida)

<details>
<summary><strong>Inquadramento — Burgers</strong></summary>

Si sostituisce $a$ con la **soluzione stessa** $u$ → velocità di propagazione **non costante**:

$$\frac{\partial u}{\partial t}+u\,\frac{\partial u}{\partial x}=0\;\Longleftrightarrow\;
\frac{\partial u}{\partial t}+\frac{\partial}{\partial x}\!\Big(\frac{u^2}{2}\Big)=0.$$

</details>

<details>
<summary><strong>Concetto [20] — perché ora urti ed espansioni? Quali altri fenomeni?</strong></summary>

Velocità d'onda $f'(u)=u$ **dipende dalla soluzione** → caratteristiche con inclinazioni diverse, che
possono **convergere** (urto) o **divergere** (espansione). Altri fenomeni da modello scalare non lineare:
**traffico** (LWR: ingorghi = urti), **shallow water** (bore/risalto idraulico), gasdinamica (compressione
→ urto), trasporto di sedimenti, cromatografia, dinamica delle folle.

</details>

<details>
<summary><strong>Figura [21][22] — compressione → urto: correlazione $x$–$t$ ↔ $x$–$u$</strong></summary>

![Burgers compressione: caratteristiche convergenti e snapshot x-u che si irripidiscono](images/lc_burgers_urto.svg)

Regione $u=u_A$ (alto) più veloce → caratteristiche più inclinate; $u=u_B$ (basso) più lente; le veloci
raggiungono le lente → **convergenza**. Nei profili $(x,u)$ il fronte si **irripidisce** fino al **salto**.

**[22] Matematica:** caratteristiche $x=\xi+u_0(\xi)t$; si incrociano a $t_b=-1/\min u_0'>0$ (serve
$u_0'<0$). Oltre $t_b$ la soluzione classica sarebbe **multivalore** → si sostituisce con una
**discontinuità** (urto) a velocità $s$ data da Rankine–Hugoniot + condizione di entropia.
**Fisica:** fino al breaking ogni caratteristica porta la **propria** informazione; quando convergono, le
informazioni **si fondono** in una sola (oltre l'urto un solo stato). Analogo: onde di compressione in gas
caldo che si accumulano in urto; auto che frenano e formano una coda.

</details>

<details>
<summary><strong>Concetto [24][25][26][28] — Rankine–Hugoniot: logica, monte/valle, ruolo, media</strong></summary>

**[26] Logica fisica:** bilancio **integrale** su un volumetto attorno alla discontinuità mobile (velocità
$s$): variazione del conservato = flusso netto → condizione di salto

$$s\,[\![u]\!]=[\![f]\!]\;\Rightarrow\; s=\frac{[\![f]\!]}{[\![u]\!]}=\frac{f(u_B)-f(u_A)}{u_B-u_A}.$$

La velocità del fronte è il **rapporto tra salto di flusso e salto del conservato**. Universale.

**[26] Monte/valle:** rispetto al verso del fronte, lo stato da cui il fronte "avanza ricevendo" è
**monte**, l'altro **valle**. Per caratteristiche convergenti, due famiglie portano $u_A,u_B$: il lato da
cui arriva l'informazione che alimenta il fronte è il monte.

**[24] Che modello è:** RH è del caso scalare **non lineare** (Burgers) ma, essendo proprietà delle leggi
di conservazione, **si estende ai sistemi** (Eulero): non è esclusiva del vettoriale.

**[25] Differenza tra equazioni:** sul lineare $f=au$ darebbe $s=a$ (nessun urto). Su **Burgers**
($f=u^2/2$): $s=\frac{u_B^2/2-u_A^2/2}{u_B-u_A}=\frac{u_A+u_B}{2}$. Applicarla allo scalare lineare è
teoricamente interessante ma non spiega gli urti, quindi non lo trattiamo (servirebbe un altro modello non
visto). RH–Burgers è una **dimostrazione da saper fare** (lista in fondo).

**[28] Attenzione:** $s=(u_A+u_B)/2$ (media) vale **solo per Burgers**; in generale $s$ è un valore
**intermedio**, non la media.

</details>

<details>
<summary><strong>Figura [29] — espansione (rarefazione) in Burgers</strong></summary>

![Burgers espansione: ventaglio di caratteristiche divergenti e snapshot x-u che si appiattiscono](images/lc_burgers_espansione.svg)

Dato iniziale **crescente** → caratteristiche **divergono**: a sinistra ($u=0$) verticali, a destra
($u=1$) pendenza $1/u$, in mezzo un **ventaglio**. Il salto **collassa subito** in onde rarefatte
(soluzione autosimile $u=x/t$). Nei profili il salto si **apre** (opposto dell'urto). Idem nelle Eulero.

</details>

## 3. Sistema di due equazioni (equazione d'onda)

<details>
<summary><strong>Inquadramento — sistema 1° ordine, iperbolico vs ellittico</strong></summary>

Due equazioni del 1° ordine (eq. delle onde come sistema), notazione $\varepsilon\,\alpha^2$:

$$\begin{cases}\partial_t u-\varepsilon\,\alpha^2\,\partial_x v=0\\[2pt] \partial_t v-\partial_x u=0\end{cases}
\Longrightarrow \partial_t U+A\,\partial_x U=0,\quad U=\begin{pmatrix}u\\ v\end{pmatrix},\
A=\begin{pmatrix}0 & -\varepsilon\alpha^2\\ -1 & 0\end{pmatrix}.$$

$\det(A-\lambda I)=\lambda^2-\varepsilon\alpha^2=0\Rightarrow\lambda=\pm\alpha\sqrt{\varepsilon}$:
$\varepsilon=+1$ reali → **iperbolico**; $\varepsilon=-1$ immaginari → **ellittico**.

</details>

<details>
<summary><strong>Concetto [Q1] — $u,v$ sono "incognite" ma anche le grandezze conservative</strong></summary>

$u,v$ si chiamano **incognite** (da determinare, $U=(u,v)$) e **sono** le **componenti** del vettore
conservato $U$: ogni riga è una legge di conservazione $\partial_t U_i+\partial_x F_i=0$. Stesso oggetto,
due nomi: *incognita* perché va risolta, *conservativa* perché obbedisce a un bilancio. (Eulero:
$\rho,\rho u,\rho E$.)

</details>

<details>
<summary><strong>Concetto [Q2][Q4][Q5] — il coefficiente $\varepsilon\,\alpha^2$ e le soluzioni complesse</strong></summary>

- **[Q2] Perché due variabili.** Si separa il **segno** $\varepsilon$ (che decide la natura della PDE) dal
  **modulo** $\alpha^2$ (la scala della velocità). $\alpha^2>0$ **sempre** perché è un quadrato (velocità²);
  il segno lo porta $\varepsilon$. Così $\lambda=\pm\alpha\sqrt\varepsilon$ ha $\alpha$ = velocità.
- **[Q4] Perché $\varepsilon=\pm1$ (non la funzione segno).** È un **parametro di selezione del caso**, non
  una grandezza continua: un generico $\varepsilon>0$ sarebbe riassorbibile in $\alpha$ → conta solo il
  segno. La funzione segno non serve perché $\varepsilon$ non è il segno di una variabile, è una costante
  fissata a priori. Serve **a distinguere iperbolico da ellittico**, e $\pm1$ fa uscire $\lambda=\pm\alpha$.
- **[Q5] Soluzioni.** $\varepsilon=+1$ → due autovalori reali $\pm\alpha$ = le **due velocità** (due onde,
  destra/sinistra). $\varepsilon=-1$ → $\pm i\alpha$ **complessi** → nessuna velocità reale, nessuna
  caratteristica reale → **ellittico** (info ovunque). Autovalori complessi ⟺ $A$ non diagonalizzabile su
  $\mathbb{R}$.

</details>

<details>
<summary><strong>Concetto [Q3] — "sistema accoppiato": significato e implicazioni</strong></summary>

- **Logico:** $A$ ha termini **fuori diagonale** non nulli → l'equazione per $u$ contiene $v$ e viceversa:
  vanno trattate **insieme** (più complesso).
- **Conseguenza:** serve la **diagonalizzazione** (§4) per disaccoppiarle.
- **Fisica:** $u,v$ descrivono **un unico fenomeno ondoso**; l'onda scambia tra le due componenti.
  Disaccoppiando, lo stesso fenomeno = **due onde indipendenti** a $\pm\alpha$.

</details>

## 4. Variabili caratteristiche e diagonalizzazione

<details>
<summary><strong>Inquadramento — disaccoppiamento via $L^{-1}$</strong></summary>

Autovettori **sinistri** $\boldsymbol{\ell}_k$ ($\boldsymbol{\ell}_k^{T}A=\lambda_k\boldsymbol{\ell}_k^{T}$),
messi **per righe** in $L^{-1}$; si premoltiplica il sistema per $L^{-1}$ inserendo $I=L\,L^{-1}$:

$$L^{-1}U_t+L^{-1}A(L L^{-1})U_x=0\Rightarrow L^{-1}U_t+\Lambda L^{-1}U_x=0
\xrightarrow{W=L^{-1}U}\frac{\partial W_k}{\partial t}+\lambda_k\frac{\partial W_k}{\partial x}=0.$$

Equazioni di trasporto **indipendenti**; lungo $dx/dt=\lambda_k$ vale $dW_k=0$ (compatibilità).

</details>

<details>
<summary><strong>Concetto [Q8] — com'è fatta $L^{-1}$</strong></summary>

$L^{-1}$ ha per **righe** gli autovettori sinistri:
$L^{-1}=\begin{pmatrix}\boldsymbol{\ell}_1^{T}\\ \boldsymbol{\ell}_2^{T}\end{pmatrix}$. Ogni
$\boldsymbol{\ell}_k=(\ell_{k,1},\ell_{k,2},\dots)$ è **a sua volta un vettore** (riga); impilandoli si
ottiene **per l'appunto una matrice** ($2\times2$, o $3\times3$ per Eulero). Per costruzione $L^{-1}A L=\Lambda$.

</details>

<details>
<summary><strong>Concetto [Q6] — perché autovettori SINISTRI e non destri</strong></summary>

In $U_t+A\,U_x=0$ la $A$ moltiplica **da sinistra**. Gli autovettori **sinistri** soddisfano
$\boldsymbol{\ell}_k^{T}A=\lambda_k\boldsymbol{\ell}_k^{T}$: premoltiplicando per $\boldsymbol{\ell}_k^{T}$,
$\partial_t(\boldsymbol{\ell}_k^{T}U)+\lambda_k\partial_x(\boldsymbol{\ell}_k^{T}U)=0$ → scalare in
$W_k=\boldsymbol{\ell}_k^{T}U$. Gli autovettori **destri** ($A r_k=\lambda_k r_k$) servono invece a
**ricostruire** $U=\sum_k W_k r_k$. È legato alla **direzione in cui agisce $A$**; ogni
$\boldsymbol{\ell}_k$ è poi associato a $\lambda_k$ (e alla sua direzione di propagazione).

</details>

<details>
<summary><strong>Concetto [Q9-mat] — far comparire $I=LL^{-1}$ ("come moltiplicare per 1")</strong></summary>

$A=A\cdot I=A\,(LL^{-1})$: inserire $I$ **non cambia nulla**, come moltiplicare per $1$ nello scalare. Ma
il prodotto matriciale **non è commutativo** → conta **dove** lo metti; lo si mette nel punto comodo:
$L^{-1}A\,U_x=\underbrace{(L^{-1}AL)}_{\Lambda}\underbrace{(L^{-1}U_x)}_{\partial_x W}$.

</details>

<details>
<summary><strong>Concetto [Q11] — perché $\Lambda$ è diagonale</strong></summary>

$\Lambda=L^{-1}AL$ è diagonale **per costruzione**: mettendo gli autovettori (destri) per colonne in $L$,
l'operazione $L^{-1}AL$ porta $A$ **nella base dei suoi autovettori**, dove agisce come **riscalamento**
lungo ogni asse → sulla diagonale gli autovalori, zero altrove. È la definizione di **diagonalizzabile**.

</details>

<details>
<summary><strong>Concetto [Q12] — perché si possono introdurre le variabili caratteristiche, e a che serve</strong></summary>

Si può portare $L^{-1}$ dentro/fuori dalle derivate **solo perché $L^{-1},A$ non dipendono da $x,t$**
(coefficienti **costanti**). Se $A=A(U)$ (non lineare) o $A(x,t)$ comparirebbero termini extra. **Vantaggio:**
da sistema accoppiato a $n$ scalari **indipendenti** $\partial_t W_k+\lambda_k\partial_x W_k=0$, ognuno
risolubile col metodo delle caratteristiche. In breve: **problema vettoriale difficile → tanti scalari facili**.

</details>

<details>
<summary><strong>Concetto [Q13] — "equazioni indipendenti": significato fisico</strong></summary>

Indipendenza **matematica** ⟺ indipendenza **fisica** dei segnali: ogni $W_k$ è un'**onda che viaggia per
conto suo** a velocità $\lambda_k$, senza scambiare informazione con le altre (disaccoppiate). La procedura
**serviva proprio a questo**, ma centra anche: (1) dimostrare l'**iperbolicità**; (2) ottenere le
**compatibilità** $dW_k=0$; (3) produrre gli **invarianti di Riemann** (Eulero) costanti lungo le
caratteristiche, utili per problemi e BC.

</details>

## 5. Equazioni di Eulero 1D non stazionarie

<details>
<summary><strong>Inquadramento — il sistema di Eulero</strong></summary>

Forma differenziale conservativa (vedi `bilancio.md`):

$$\frac{\partial}{\partial t}\begin{pmatrix}\rho\\ \rho u\\ \rho E\end{pmatrix}
+\frac{\partial}{\partial x}\begin{pmatrix}\rho u\\ p+\rho u^2\\ u(p+\rho E)\end{pmatrix}=0.$$

Centrali perché la parte **convettiva** dei problemi 3D compressibili si riconduce a Eulero, e molte
tecniche riducono il problema a 1D nella direzione **normale** all'interfaccia.

</details>

<details>
<summary><strong>Concetto [Q1] — variabili primitive vs conservative (teoria + codice)</strong></summary>

Stesso sistema, due **scelte di incognite**:
- **Conservative** $U=(\rho,\rho u,\rho E)$: forma di **divergenza** $\partial_t U+\partial_x F=0$. È la
  forma "robusta": garantisce le **velocità d'urto corrette** (Rankine–Hugoniot), perché il salto è
  consistente col bilancio integrale.
- **Primitive** $V=(\rho,u,p)$ (o $(a,u,S)$): forma quasi-lineare $\partial_t V+A'\partial_x V=0$. Più
  **intuitive** e comode per diagonalizzare/leggere lo stato e imporre le BC, **ma** in forma non
  conservativa darebbero urti a velocità sbagliata.

La fisica (autovalori $u,u\pm a$) è identica: cambia solo la base. **Regola:** il *bilancio* si scrive in
conservative; le primitive servono per analisi/BC.

**Codice/Esercitazioni:** in `Euler2D` lo stato **evoluto** è conservative (`ucons` = $\rho E,\rho,\rho
u,\rho v$); le primitive ($u,v,a,P,T,S$) sono **ricavate localmente** per flussi e BC. È la scelta giusta
per un solutore a volumi finiti con urti. (Commento aggiunto in `strutture.f90` e in `Latex/Codice_CFD.tex`.)

</details>

<details>
<summary><strong>Approfondimento [Q2] — come si ricava $A'$ (variabili primitive). DIMOSTRAZIONE</strong></summary>

*(Approfondimento, utile per capire come funziona la diagonalizzazione.)* Partendo dalla forma
conservativa e passando alle primitive $V=(\rho,u,p)$ con la chain rule:

- **massa:** $\rho_t+(\rho u)_x=0\Rightarrow \rho_t+u\rho_x+\rho u_x=0$;
- **q. di moto:** $(\rho u)_t+(\rho u^2+p)_x=0$, usando la massa $\Rightarrow u_t+u u_x+\tfrac1\rho p_x=0$;
- **energia → pressione** (gas ideale, $a^2=\gamma p/\rho$): $p_t+u p_x+\rho a^2 u_x=0$.

In forma matriciale $\partial_t V+A'\partial_x V=0$ con

$$A'=\begin{pmatrix} u & \rho & 0\\[2pt] 0 & u & 1/\rho\\[2pt] 0 & \rho a^2 & u \end{pmatrix},\qquad
\det(A'-\lambda I)=(u-\lambda)\big[(u-\lambda)^2-a^2\big]=0\Rightarrow \lambda=u,\ u\pm a.$$

(Il capitolo usa la base $(a,u,S)$: stessi autovalori, ma le variabili caratteristiche risultano
**direttamente** gli invarianti di Riemann $a/\phi\pm u$ e l'entropia — comodo per il pistone/BC.)

</details>

<details>
<summary><strong>Concetto [Q3] — $A'$ non è simmetrica: ha un significato?</strong></summary>

Sì, ma non è un problema. $A'$ **non è simmetrica** (es. $A'_{12}=\rho\neq A'_{21}=0$) perché è scritta in
variabili **non conservative/non "entropiche"**. Conseguenze:
- gli **autovettori destri e sinistri sono diversi** (non l'uno il trasposto dell'altro) → servono
  entrambi (sinistri per proiettare in $W$, destri per ricostruire $U$);
- gli autovettori **non sono ortogonali**.

Per l'**iperbolicità** la simmetria **non serve**: bastano autovalori **reali** + insieme **completo** di
autovettori (qui garantito da autovalori reali distinti). Esiste comunque una scelta di variabili
(variabili di **entropia**/Roe) che **simmetrizza** Eulero: comoda in teoria (stime di energia), ma non
necessaria. Quindi la non-simmetria è una proprietà della **base scelta**, non un ostacolo fisico.

</details>

<details>
<summary><strong>Concetto [Q4] — "reali e distinti ⇒ iperbolico": basta? E il significato fisico</strong></summary>

**Matematica:** per la **classificazione** non servono i *valori*, basta che gli autovalori siano **reali**
e che ci sia un **insieme completo di autovettori**. Autovalori **reali e distinti** garantiscono
automaticamente la diagonalizzabilità → **iperbolicità stretta**. Quindi per dire "è iperbolico" basta
real+distinti; i *valori* in sé non servono alla classificazione.

**Ma i valori contano per la fisica:** sono le **velocità d'onda**, e i loro **segni** decidono BC e regime
(sub/supersonico). **Autovalori diversi = velocità di propagazione diverse**: tre onde distinte (due
acustiche $u\pm a$, una entropica/di contatto $u$) che **si separano** nel tempo → è il ventaglio del
problema di Riemann.

</details>

<details>
<summary><strong>Concetto [Q5] — e se gli autovalori coincidessero?</strong></summary>

Dipende dagli **autovettori**:
- se l'autovalore ripetuto ha ancora **abbastanza autovettori indipendenti** (matrice diagonalizzabile) →
  il sistema è ancora iperbolico, ma **non strettamente** (iperbolicità "non stretta");
- se è **difettivo** (blocco di Jordan, autovettori insufficienti) → solo **debolmente iperbolico**: il
  problema ai valori iniziali può essere **mal posto**.

**Fisica:** autovalori coincidenti = due onde alla **stessa velocità** (degenerazione).
**È possibile?** In Eulero **1D** le tre velocità $u,u\pm a$ coincidono solo se $a\to0$ (gas senza
pressione/suono: caso degenere, *pressureless Euler*, con "delta-shock"). In **2D/3D** invece l'autovalore
$u$ ha **molteplicità** $>1$ (onde di entropia e di vorticità viaggiano entrambe a $u$): caso reale e ben
posto perché resta diagonalizzabile (non strettamente iperbolico).

</details>

<details>
<summary><strong>Concetto [Q6] — perché è iperbolico ANCHE in subsonico (non solo supersonico)</strong></summary>

Il punto chiave è **stazionario vs non stazionario**.
- Le equazioni di Eulero **stazionarie** (o l'eq. del potenziale) sono di **tipo misto** rispetto allo
  **spazio**: ellittiche in subsonico, iperboliche in supersonico (è da lì che nasce l'aspettativa
  "iperbolico solo supersonico"). Vedi `bilancio.md` (discriminante).
- Le equazioni **non stazionarie** in $(x,t)$ sono **sempre iperboliche**, perché gli autovalori
  $u,u\pm a$ sono **reali per qualunque Mach** ($a>0$ sempre). Il tempo è la direzione "timelike".

Quindi nel subsonico cambia **solo il segno** di $\lambda_1=u-a$ (la caratteristica risale invece di
scendere), non il fatto che sia reale. Il regime sub/supersonico determina **quante** caratteristiche
entrano (→ BC), **non** la natura iperbolica. Il tuo ragionamento confondeva il caso **stazionario** (misto)
con quello **non stazionario** (sempre iperbolico).

</details>

<details>
<summary><strong>Figura [Q7] — dominio di dipendenza/influenza (sub/super) e la "linea che va indietro nel tempo"</strong></summary>

![Dominio di dipendenza (giallo) e influenza (verde) di P, casi subsonico e supersonico](images/lc_dominio_dipendenza_xt.svg)

Da $P$ passano **tre** caratteristiche. Il **dominio di dipendenza** (giallo, verso il **passato**) è
delimitato dalle due caratteristiche estreme tracciate **all'indietro**; il **dominio di influenza**
(verde, **futuro**) da quelle in avanti. Subsonico: $\lambda_1=u-a<0$ pende a sinistra. Supersonico:
tutte $\lambda>0$ → il cono si **inclina a valle**.

**[Q7] "Va indietro nel tempo"?** No: **nessuna caratteristica torna indietro nel tempo**. Ogni
caratteristica è una **retta intera** che passa per $P$ sia nel futuro sia nel passato; per il dominio di
**dipendenza** la si percorre **all'indietro** ($t<t_P$) fino a dove il dato è noto. Il segno di
$\lambda_1<0$ indica solo la **direzione spaziale** (verso sinistra, in $x$), **non** una direzione
temporale. "Influenza il passato" è una lettura sbagliata: il tempo va sempre avanti; $P$ **dipende** dal
passato lungo $\lambda_1$, non lo **influenza**. (L'annotazione "PASSATO/FUTURO" si riferisce a quale metà
della caratteristica — passata o futura — entra nel rispettivo cono.)

</details>

<details>
<summary><strong>Approfondimento [Q8] — urto curvo staccato: zone sub+supersoniche insieme</strong></summary>

Davanti a un corpo tozzo c'è un **urto curvo staccato**: dietro di esso una **tasca subsonica**, altrove
**supersonico**. Nel problema **stazionario** servirebbero metodi **ellittici** (tasca subsonica) e
**iperbolici** (zone supersoniche) **insieme** → scomodo.

**Cosa si fa:** si passa al problema **non stazionario** e si **marcia nel tempo** fino allo stato
stazionario (*time-marching*). Come visto in **[Q6]**, le Eulero **non stazionarie in $(x,t)$ sono
iperboliche ovunque** (autovalori $u,u\pm a$ reali per qualunque Mach). Quindi:
1. aggiungo $\partial_t U$ → il sistema diventa **globalmente iperbolico**;
2. uso **un solo** schema esplicito (time-marching) su tutto il dominio, sub e supersonico;
3. a convergenza ($\partial_t U\to0$) recupero la soluzione stazionaria mista.

Non è un'incongruenza logica: il tipo (ellittico/iperbolico) dipende dall'**operatore** e dalle **variabili
indipendenti**; cambiando da $(x)$ stazionario a $(x,t)$ non stazionario, l'operatore cambia e diventa
iperbolico. Si "scioglie" il problema misto in uno **interamente trattabile** con metodi iperbolici.

> Nota: se i tuoi appunti dicono "totalmente **ellittico**", è probabilmente un lapsus o si riferisce alla
> **tasca subsonica stazionaria**; la riformulazione **non stazionaria** in $(x,t)$ è **iperbolica**
> ovunque — ed è proprio questo che risolve il problema. Se la lezione intendeva un'altra cosa, mandami la
> frase esatta e riallineo.

</details>

<details>
<summary><strong>Approfondimento [Q9] — logica del calcolo degli autovettori (e perché ora sì)</strong></summary>

**Cosa stiamo facendo:** calcoliamo gli **autovettori sinistri** di $A'$ per costruire $L^{-1}$ e quindi le
**variabili caratteristiche** $W=L^{-1}V$, cioè le combinazioni di $da,du,dS$ **conservate lungo ciascuna
caratteristica** (le equazioni di compatibilità).

**Con che obiettivo:** non solo provare l'iperbolicità (quella basta da real+distinti), ma ottenere le
**relazioni concrete** — gli **invarianti di Riemann** $a/\phi\pm u$ e l'entropia — che servono a
**risolvere** problemi reali (pistone, condizioni al contorno).

**Perché non prima:** nei casi scalari (§1–2) c'è **una sola** equazione, niente da disaccoppiare; nel
sistema 2×2 (§3) bastava mostrare la **diagonalizzabilità** (esistenza degli autovalori reali). Per
**Eulero** invece servono le combinazioni **esplicite** trasportate lungo $u,u\pm a$ → si devono calcolare
gli autovettori.

</details>

<details>
<summary><strong>Concetto [Q4-fis] — autovalori $u-a,\ u,\ u+a$: significato fisico</strong></summary>

In variabili $(a,u,S)$, $\det(A'-\lambda I)=0\Rightarrow(\lambda-u)(\lambda-u-a)(\lambda-u+a)=0$. Fisica:
- $\lambda_2=u$: **trasporto delle particelle** (entropia/contatto);
- $\lambda_{1,3}=u\mp a$: onde **acustiche** indietro/avanti. Se $u=0$ → $\pm a$ (acustica in mezzo statico);
  se il fluido si muove, le onde combinano $u$ e $a$.

</details>

<details>
<summary><strong>Concetto/Dimostrazione [Q9-Q10] — variabili caratteristiche di Eulero e omoentropico</strong></summary>

Risolvendo $\boldsymbol{\ell}^i A'=\lambda_i\boldsymbol{\ell}^i$ si ottengono i differenziali delle
variabili caratteristiche $dW=L^{-1}dV$:

$$dW_1=\frac{da}{\phi}-du-\frac{a}{\gamma R}\,dS,\quad dW_2=dS,\quad dW_3=\frac{da}{\phi}+du-\frac{a}{\gamma R}\,dS,
\qquad \phi=\frac{\gamma-1}{2}.$$

Le **compatibilità** sono $dW_i=0$ lungo $\lambda_i$. La seconda ($dS=0$ lungo $\lambda_2=u$) è il
**trasporto dell'entropia** $DS/Dt=0$. Nel caso **omoentropico** ($S$ uniforme) la prima/terza danno gli
**invarianti di Riemann**

$$J^{\pm}=\frac{a}{\phi}\pm u=u\pm\frac{2a}{\gamma-1}=\text{cost lungo }\lambda_{3,1}=u\pm a.$$

</details>

<details>
<summary><strong>Concetto [N1] — che tipi di onde sono, e quanti tipi esistono</strong></summary>

Le tre famiglie di Eulero **non sono tre copie della stessa onda**, sono **fenomeni diversi**:
- $\lambda_{1,3}=u\mp a$ → **onde acustiche** (pressione/suono): campi *genuinamente non lineari* → possono
  diventare **urti** o **ventagli di rarefazione**;
- $\lambda_2=u$ → **onda di entropia / contatto**: campo *linearmente degenere* → trasporta un salto di
  densità/entropia a **pressione e velocità costanti** (non si irripidisce).

**Autovalori coincidenti ≠ due onde identiche.** Possono essere onde **fisicamente diverse** che
viaggiano alla **stessa** velocità: in 2D/3D, ad esempio, l'autovalore $u$ ha molteplicità perché vi
"convivono" l'onda di **entropia** e quella di **vorticità/taglio**, distinte ma entrambe trasportate a
$u$. La tua intuizione è corretta solo per onde **dello stesso tipo**: due onde identiche alla stessa
velocità si **sovrappongono** (somma lineare) in una sola più intensa; la degenerazione nei *sistemi* è
invece l'esistenza di **autodirezioni distinte** con lo stesso autovalore (modi diversi, stessa velocità).

**Tipi di onde (in generale, per i fluidi):** acustiche (compressione/espansione, $u\pm a$), entropiche
(contatto, $u$), vorticità/taglio ($u$, in 2D/3D). In magnetofluidodinamica se ne aggiungono altre
(Alfvén, magnetosoniche). Per Eulero 1D le famiglie sono **3**.

</details>

<details>
<summary><strong>Concetto [N2] — tabella iperbolico/ellittico e caratteristiche entranti (sub vs super)</strong></summary>

| Regime | Eq. **stazionarie** (vs $x$) | Eq. **non stazionarie** $(x,t)$ | Segni di $\lambda$ | Caratt. che **entrano** a un ingresso |
|---|---|---|---|---|
| **Subsonico** $M<1$ | **ellittico** (tipo misto) | **iperbolico** | $\lambda_1=u-a<0;\ \lambda_2=u>0;\ \lambda_3=u+a>0$ | **2** entrano ($\lambda_2,\lambda_3$), 1 risale dall'interno ($\lambda_1$) → **2 BC** |
| **Supersonico** $M>1$ | **iperbolico** | **iperbolico** | tutti $>0$ | **3** entrano → **3 BC** |

Nel **non stazionario** è **sempre iperbolico**: il regime cambia solo i **segni** (quindi quante
caratteristiche entrano), non la natura. La "natura mista" (ellittico in subsonico) appartiene al problema
**stazionario**. In subsonico $\lambda_1=u-a<0$ **non esce dal tempo**: rientra dall'**interno** del
dominio (è l'informazione che risale la corrente).

</details>

<details>
<summary><strong>Concetto [N3] — come leggere i coni: avanti nel tempo, "indietro" nello spazio</strong></summary>

Nelle figure i coni ora hanno **frecce**: nere = direzione di lettura verso il **futuro** (alto), grigie =
verso il **passato** (basso). Il punto chiave: **il tempo va sempre avanti**. $\lambda_1=u-a<0$ significa
che quella **onda si propaga indietro nello spazio** (verso $x$ minori = **monte**), pur avanzando nel
tempo. Quindi $P$ **dipende da** ciò che sta a monte/valle lungo le sue caratteristiche e **influenza**
monte tramite $\lambda_1$: in subsonico un'onda acustica **risale la corrente** (per questo serve una BC al
contorno di valle). Non c'è nessun viaggio nel passato: solo propagazione **spaziale** verso sinistra.

</details>

<details>
<summary><strong>Approfondimento [N4] — perché passare al non stazionario conviene (e quanto costa)</strong></summary>

Sì: anche se un problema **stazionario** è in genere più economico, davanti a un campo **misto**
(sub+supersonico, es. urto staccato) conviene rendere tutto **non stazionario** e **marciare nel tempo**.
Vantaggio: si evita di **dividere il dominio** e accoppiare un solutore ellittico (zone subsoniche) con uno
iperbolico (zone supersoniche) — operazione complessa e fragile. Con il time-marching si usa **un solo**
schema iperbolico ovunque.

**Costo:** sì, c'è un sovrapprezzo: si aggiunge la **dimensione tempo** e si **itera** (in tempo fisico o
*pseudo-tempo*) fino a $\partial_t U\to0$ → molte iterazioni per arrivare alla soluzione stazionaria. Si
paga **robustezza e semplicità** con più iterazioni. È il motivo per cui in CFD compressibile il
time-marching / *pseudo-transient continuation* è lo standard.

</details>

<details>
<summary><strong>Concetto [N5] — tabella: variabili conservative vs primitive vs caratteristiche</strong></summary>

| Tipo | Variabili (Eulero 1D) | Forma | Pro / a cosa servono |
|---|---|---|---|
| **Conservative** | $U=(\rho,\ \rho u,\ \rho E)$ | divergenza $\partial_t U+\partial_x F=0$ | **urti corretti** (Rankine–Hugoniot); è ciò che si **evolve** numericamente |
| **Primitive** | $V=(\rho,u,p)$ o $(a,u,S)$ | quasi-lineare $\partial_t V+A'\partial_x V=0$ | **intuitive**; comode per leggere lo stato, **imporre le BC**, diagonalizzare |
| **Caratteristiche** | $W=L^{-1}V$ | disaccoppiata $\partial_t W_k+\lambda_k\partial_x W_k=0$ | ogni $W_k$ **costante lungo $\lambda_k$**; **invarianti di Riemann**, BC non riflettenti, analisi delle onde |

Stessa fisica, tre "lenti": si **evolve** in conservative, si **analizza/impone** in primitive, si
**capisce la propagazione** in caratteristiche.

</details>

<details>
<summary><strong>Concetto [N6] — perché le compatibilità chiedono che $W_k$ non vari</strong></summary>

Non è un'ipotesi aggiuntiva: è **ciò che dice l'equazione** una volta diagonalizzata. Lungo la
caratteristica $dx/dt=\lambda_k$ la PDE $\partial_t W_k+\lambda_k\partial_x W_k=0$ diventa la **ODE**
$\dfrac{dW_k}{dt}=0$. Quindi $W_k$ è proprio la combinazione **compatibile** con la propagazione lungo
quella curva: l'equazione **permette** che sopravviva solo se resta **costante**. "Equazione di
compatibilità" = la relazione che deve valere **lungo** la caratteristica perché la soluzione sia coerente.

</details>

<details>
<summary><strong>Concetto [N7] — tabella dei 3 invarianti</strong></summary>

| Famiglia | $\lambda$ | Variabile/invariante | Significato |
|---|---|---|---|
| 1 | $u-a$ | $J^{-}=u-\dfrac{2a}{\gamma-1}$ (omoentropico) | onda **acustica all'indietro** |
| 2 | $u$ | $S$ (entropia) | **trasporto** entropia / superficie di **contatto** |
| 3 | $u+a$ | $J^{+}=u+\dfrac{2a}{\gamma-1}$ (omoentropico) | onda **acustica in avanti** |

Tre invarianti ($J^{+},\,J^{-},\,S$), uno per famiglia: noti due acustici da lati opposti si ricavano $u$ e
$a$ in un punto; $S$ chiude la termodinamica.

</details>

<details>
<summary><strong>Concetto [N8] — gli invarianti di Riemann valgono solo nell'omoentropico?</strong></summary>

Le **equazioni di compatibilità** $dW_i=0$ lungo $\lambda_i$ valgono **sempre**. Ma diventano gli
**invarianti di Riemann semplici** $J^{\pm}=u\pm 2a/(\gamma-1)$ solo se l'**entropia è uniforme**
(omoentropico): allora le relazioni acustiche si **disaccoppiano** dall'entropia e sono integrabili in una
funzione costante lungo la caratteristica. Nel caso **non omoentropico** le relazioni acustiche contengono
anche $dS$ (compaiono i *Generalized Riemann Invariants*): restano valide in forma **differenziale** ma
**non** sono più i semplici $J^{\pm}$. In pratica: attraverso un **urto** l'entropia salta → di là si
ridefiniscono $J^{\pm}$ con la nuova entropia.

</details>

## 6. Metodo delle caratteristiche: il pistone

<details>
<summary><strong>Figura — pistone accelerato e invarianti di Riemann</strong></summary>

![Pistone in moto accelerato: traiettoria e caratteristiche](images/lc_pistone_a.png)
![Pistone: costruzione dello stato in P con le caratteristiche](images/lc_pistone_b.png)

Pistone fermo che accelera: traiettoria $(x,t)$ inizialmente verticale ($u=0$) poi inclinata. Genera
perturbazioni lungo $\lambda_3=u+a$; accelerando, onde successive **più veloci** comprimono il gas (verso
un urto). Per lo stato in $P$ servono **3** grandezze (2 termodinamiche + 1 cinematica) → 3 compatibilità.
Nel caso omoentropico, con $W_1$ (lungo $\lambda_1$, collega $P$ a un punto del dato iniziale) e $W_3$
(lungo $\lambda_3$, collega $P$ al pistone), più $S$ lungo $\lambda_2$, si chiude il sistema:
$W_1(P)=W_1(B)$, $W_3(P)=W_3(A)$.

</details>

<details>
<summary><strong>Concetto [27] — Rankine–Hugoniot per Eulero: perché il flusso $\rho u$? E le altre</strong></summary>

RH per Eulero (massa e q. di moto):

$$c=\frac{[\![\rho u]\!]}{[\![\rho]\!]}=\frac{\rho_2 u_2-\rho_1 u_1}{\rho_2-\rho_1},\qquad
c=\frac{(p_2+\rho_2u_2^2)-(p_1+\rho_1u_1^2)}{\rho_2 u_2-\rho_1 u_1}.$$

**Perché $\rho u$?** Perché l'esempio parte dalla **conservazione della massa** (la più semplice): lì il
conservato è $\rho$ e il flusso è $\rho u$. **Non** è speciale; RH vale **componente per componente**:

| Equazione | Conservato $U$ | Flusso $F$ | Salto RH |
|---|---|---|---|
| Massa | $\rho$ | $\rho u$ | $s[\![\rho]\!]=[\![\rho u]\!]$ |
| Q. di moto | $\rho u$ | $p+\rho u^2$ | $s[\![\rho u]\!]=[\![p+\rho u^2]\!]$ |
| Energia | $\rho E$ | $u(p+\rho E)$ | $s[\![\rho E]\!]=[\![u(p+\rho E)]\!]$ |

Le tre **insieme** legano monte/valle (Hugoniot). La massa è solo l'esempio più immediato.

</details>

<details>
<summary><strong>Concetto [N9] — le due figure del pistone danno informazioni diverse</strong></summary>

Sì, sono complementari:
- **1ª figura** (setup generale): traiettoria del pistone, onde $\lambda_3$ **emesse nel gas**, formazione
  dell'**urto** (rosso) dove convergono, e un **punto generico $K$** (a destra) con le sue **tre** famiglie
  $\lambda_1,\lambda_2,\lambda_3$ → mostra che *ogni* punto del gas ha 3 caratteristiche.
- **2ª figura** (costruzione operativa): **come si calcola** lo stato in un punto $P$ vicino al pistone,
  collegandolo con $\lambda_1,\lambda_3$ a punti **noti** (4, 5) e alla **zona gialla** delle condizioni
  iniziali.

Una è "qualitativa" (cosa succede), l'altra "quantitativa" (come si risolve).

</details>

<details>
<summary><strong>Concetto [N10] — la legge di moto del pistone (linea nera) e perché questa</strong></summary>

La **linea nera continua** è la **traiettoria del pistone** nel piano $(x,t)$; la sua **pendenza è la
velocità** (è un grafico $x$–$t$). Quindi:
- tratto **verticale** in basso → pistone **fermo** ($v=0$, posizione costante);
- tratto **curvo** → **moto accelerato** (pendenza che cresce = velocità che aumenta);
- tratto **rettilineo** → **velocità costante** (pendenza costante).

**Perché questa legge?** Soprattutto per **semplicità** didattica, ma è anche **fisicamente
rappresentativa**: un pistone che parte da fermo, accelera e poi va a regime. La **fase accelerata** è
ciò che genera onde di compressione via via più veloci → **urto**. **Applicazioni:** tubi d'urto
(*shock tube*), fase di compressione nei motori, transitori di valvole, avviamento di prese d'aria.

</details>

<details>
<summary><strong>Concetto [N11] — pistone al punto morto e a tenuta stagna</strong></summary>

Si immagina il pistone che parte dal **punto morto** (estremità chiusa del tubo): solo così ha senso dire
che **a sinistra del pistone non c'è gas** (vuoto). Inoltre si assume **tenuta stagna**: nessuna
infiltrazione d'aria oltre il pistone. Il gas è tutto **a destra** e viene **compresso** man mano che il
pistone avanza.

</details>

<details>
<summary><strong>Concetto [N12] — moto accelerato ⇒ pendenze diverse ⇒ urto (come Burgers)</strong></summary>

Nella fase **accelerata** il pistone emette onde $\lambda_3=u+a$ a velocità **crescente** (il gas dietro è
sempre più veloce e caldo). Caratteristiche con **inclinazioni diverse** → **convergono** → **urto**. È lo
stesso meccanismo di **Burgers** (caratteristiche non parallele che collidono), solo che qui la velocità
caratteristica è $u+a$ (acustica) invece di $u$.

</details>

<details>
<summary><strong>Concetto [N13] — invarianti di Riemann prima e dopo l'urto</strong></summary>

**Prima** dell'urto la compressione è **isentropica/omoentropica** (regolare) → si possono usare gli
**invarianti di Riemann** $J^{\pm}$ per propagare lo stato lungo le caratteristiche. **Attraverso** l'urto
l'**entropia salta** (l'urto genera entropia) → di là il gas ha entropia **diversa** e non è più
omoentropico con la regione di monte: **non** si possono trasportare $J^{\pm}$ attraverso l'urto. Si usa
allora **Rankine–Hugoniot** per "saltare" l'urto, e si riprende con $J^{\pm}$ **nella nuova regione** (con
la sua entropia).

</details>

<details>
<summary><strong>Concetto [N14] — perché un punto $K$ "arbitrario"</strong></summary>

È una scelta **fisica di generalità**, non solo grafica: si prende un punto **qualunque** del gas per far
vedere che **in ogni** punto passano **tre** caratteristiche. La posizione (a destra, dove le linee non si
sovrappongono) è scelta per **leggibilità**, ma il messaggio vale per tutti i punti.

</details>

<details>
<summary><strong>Concetto [N15] — perché dal pistone partono solo $\lambda_3$ (e il "vuoto" non propaga suono)</strong></summary>

Dalla **faccia del pistone** le onde che entrano **nel gas** sono quelle **acustiche in avanti**
$\lambda_3=u+a$: il pistone spinge → manda una compressione che corre **in avanti** nel gas. Per questo le
linee dal pistone sono $\lambda_3$.
- **A sinistra del pistone non c'è gas** (vuoto): **niente mezzo → niente suono**, quindi lì non esistono
  onde. La faccia del pistone è il **bordo sinistro** del gas; le onde vivono **solo nel gas** (a destra).
- $\lambda_1$ ($u-a$) e $\lambda_2$ ($u$) esistono **dentro** il gas (info che risale / percorso
  particellare), ma non sono "emesse" dal pistone come la $\lambda_3$; seguiamo le $\lambda_3$ perché sono
  le onde che il pistone **genera** e che formano l'urto.
- Nel punto $K$, che è **interno al gas**, passano **tutte e 3** perché il mezzo supporta tutte le famiglie
  (informazione che arriva da più direzioni).

</details>

<details>
<summary><strong>Concetto [N16] — perché la zona delle condizioni iniziali è quella gialla</strong></summary>

La **zona gialla** è il **gas indisturbato** davanti, **non ancora raggiunto** dalle perturbazioni del
pistone (sta "sotto" le prime onde/l'urto). Conserva quindi lo **stato iniziale noto** (uniforme): da lì
si leggono i **dati noti** per propagarli lungo le caratteristiche e chiudere i conti negli altri punti.

</details>

<details>
<summary><strong>Concetto [N17] — le altre linee nella seconda figura del pistone</strong></summary>

Sono la **costruzione caratteristica** per trovare lo stato in $P$: la $\lambda_1$ da $P$ scende a un punto
**noto** (4) nella zona iniziale; la $\lambda_3$ collega $P$ al **pistone**; la $\lambda_2$ è il percorso
**particellare**; i punti **4, 5** sono riferimenti nella zona iniziale usati per propagare gli invarianti
($W_1(P)=W_1(4)$, ecc.). Le **tratteggiate** in alto a sinistra marcano solo la zona **senza gas**.

</details>

## 7. Problema di Riemann e tubo d'urto di Sod

<details>
<summary><strong>Figura [21] — Sod: dato iniziale, struttura $x$–$t$ e profili</strong></summary>

Problema di Riemann = sistema iperbolico con dato iniziale **discontinuo** tra due stati costanti. Sod:
$(\rho_A,p_A,u_A)=(1,1,0)$ e $(\rho_B,p_B,u_B)=(0.125,0.1,0)$.

![Dato iniziale di Sod: due stati costanti A e B](images/lc_sod_dato_iniziale.png)

Rimossa la membrana: **fascio di espansione** (sinistra), **superficie di contatto** (centro), **onda
d'urto** (destra).

![Diagramma x-t di Sod: espansione, superficie di contatto, urto](images/lc_sod_xt.png)
![Profilo di pressione p(x,t1): solo espansione + urto](images/lc_sod_pressione.png)
![Profilo di densità ρ(x,t1): espansione + salto di contatto + urto](images/lc_sod_densita.png)

</details>

<details>
<summary><strong>Approfondimento [Q10] — invarianti di Riemann, struttura di Sod, casistiche</strong></summary>

**Invarianti di Riemann (omoentropico).** $J^{\pm}=u\pm 2a/(\gamma-1)$ costanti lungo $u\pm a$; l'entropia
$S$ costante lungo $u$. Servono a "trasportare" lo stato lungo le caratteristiche e chiudere i problemi
(pistone, BC): conoscendo $J^{+}$ da un lato e $J^{-}$ dall'altro si ricavano $u$ e $a$ nel punto.

**Struttura del problema di Sod (3 onde, 4 stati).** Stati $A$ (sx) e $B$ (dx) iniziali; in mezzo nascono
due stati "star" $A^\*$ e $B^\*$ separati dalla **superficie di contatto**:
- a sinistra: **ventaglio di espansione** (collega $A$ ad $A^\*$, isentropico → uso $J^{+}$);
- al centro: **superficie di contatto** ($A^\*\!\mid\!B^\*$): **pressione e velocità continue**
  ($p_{A^\*}=p_{B^\*}$, $u_{A^\*}=u_{B^\*}$), **densità/temperatura/entropia discontinue**; viaggia a $u$
  (2ª famiglia);
- a destra: **onda d'urto** (collega $B$ a $B^\*$, RH).

**Perché la pressione "non vede" il contatto.** La pressione è **continua** attraverso il contatto →
nel profilo $p(x,t_1)$ compaiono **solo** espansione e urto; il contatto è **invisibile**. La **densità**
(o temperatura) invece **salta** sul contatto → il profilo $\rho(x,t_1)$ mostra **tutte e tre** le
strutture. Per questo, sperimentalmente, il contatto si vede in densità/temperatura ma non in pressione.

**Casistiche** (dipendono dal segno/intensità del salto iniziale): si possono avere espansione+contatto+
urto (Sod classico), oppure due urti, o due espansioni, a seconda degli stati $A,B$. La velocità del fluido
all'interfaccia è positiva (il gas va da alta a bassa pressione).

</details>

<details>
<summary><strong>Concetto [N18] — il problema di Riemann in generale, e cosa aggiunge Sod</strong></summary>

![Problema di Riemann: soluzione autosimile, 3 onde dalla discontinuità iniziale](images/lc_riemann_generale.svg)

**Problema di Riemann (generale):** un sistema **iperbolico** con dato iniziale fatto di **due stati
costanti** $U_L,U_R$ separati da **una sola discontinuità** in $x=0$. La soluzione è **autosimile**
(dipende solo da $x/t$) ed è composta da **un'onda per ogni famiglia** che parte dall'origine. Per Eulero
(3 famiglie): una **1-onda** (acustica indietro: urto *o* rarefazione), una **2-onda** (contatto), una
**3-onda** (acustica avanti: urto *o* rarefazione); fra di esse le regioni "star" $L^\*,R^\*$.

**Tubo di Sod = un Riemann problem *specifico*, con ipotesi aggiuntive:**
1. **stesso gas ideale** sui due lati (stesso $\gamma$);
2. gas inizialmente **fermo** su entrambi i lati ($u_L=u_R=0$);
3. valori scelti $(\rho_L,p_L)=(1,1)$, $(\rho_R,p_R)=(0.125,0.1)$ con $p_L>p_R$;
4. 1D, non viscoso, senza forze di volume.

Con queste ipotesi la soluzione è **esattamente** espansione (sx) + contatto + urto (dx). Il Riemann
problem **generale** potrebbe invece dare **due urti**, **due rarefazioni**, o perfino il **vuoto**, a
seconda degli stati. *(Distinguere i due evita di confonderli: Sod è un caso particolare.)*

</details>

<details>
<summary><strong>Concetto [N19] — il "background matematico" che produce espansione+contatto+urto</strong></summary>

È **lo stesso** Eulero 1D non stazionario (autovalori $u,u\pm a$): **non** serve un'altra equazione. Ciò
che produce i tre tipi d'onda è la **natura di ciascun campo caratteristico** + il dato **discontinuo**:
- campi **1 e 3** (acustici) **genuinamente non lineari** ($\nabla\lambda\!\cdot r\neq0$) → la loro onda è
  un **urto** (compressione) **o** un **ventaglio di rarefazione** (espansione);
- campo **2** (entropia) **linearmente degenere** ($\nabla\lambda\!\cdot r=0$) → **contatto** (né si
  irripidisce né si apre).

Quindi: **stesse equazioni + dato discontinuo + autosimilarità** → 3 onde; il **tipo** dipende da
genuina-nonlinearità vs degenerazione lineare e dal **segno del salto**. Risolvere Sod = trovare la
regione star imponendo $p^\*$ e $u^\*$ **uguali** ai due lati del contatto, poi collegare $L\!\to\!L^\*$
(1-onda) e $R\!\to\!R^\*$ (3-onda).

</details>

<details>
<summary><strong>Figura [N20] — profili di $\rho,\ p,\ u,\ T$ a $t=t_1$ (commentati)</strong></summary>

![Profili di densità, pressione, velocità, temperatura nel tubo di Sod](images/lc_sod_profili.svg)

Lettura (sx → dx: stato L, ventaglio, $L^\*$, contatto, $R^\*$, urto, stato R):
- **Pressione $p$** e **velocità $u$**: **continue** attraverso il **contatto** (quindi lì **invisibile**);
  variano dolcemente nel **ventaglio** e saltano solo all'**urto**. Mostrano **espansione + urto**.
- **Densità $\rho$** e **temperatura $T$**: **saltano** sul **contatto** (visibile) **e** sull'urto, oltre
  a variare nel ventaglio. Mostrano **tutte e tre** le strutture.
- Perché $T$ "vede" il contatto: $T=p/(\rho R)$; sul contatto $p$ è continua ma $\rho$ salta → $T$ salta.

**Pratica:** per **localizzare il contatto** si guarda la **densità/temperatura** (es. tecniche ottiche
sulla densità), **non** la pressione.

</details>

<details>
<summary><strong>Approfondimento [N21] — le caratteristiche partono da OGNI punto: come si gestisce</strong></summary>

*(Approfondimento, molto utile.)* Finora un solo punto e una sola fenomenologia; in realtà il "ventaglio"
di 3 caratteristiche parte da **ogni** punto → il piano $(x,t)$ è **coperto da tre famiglie** di
caratteristiche (una rete):

![Tre famiglie di caratteristiche che coprono il piano; ogni punto ha il suo ventaglio](images/lc_caratteristiche_ovunque.svg)

Ogni punto è l'**intersezione** di una curva per famiglia; la soluzione si costruisce propagando gli
invarianti lungo **tutte**. Analiticamente è **intrattabile** in generale (le curve si incurvano,
interagiscono, formano urti). **In pratica si discretizza:** i metodi a **volumi finiti / Godunov**
risolvono un **problema di Riemann locale a ogni interfaccia** tra celle, a ogni passo temporale — cioè
"tengono conto di tutte e 3 le caratteristiche in ogni punto" **numericamente**. È così che il metodo
delle caratteristiche **motiva** gli schemi **upwind/Godunov** (vedi `schemi_volumi_finiti.md`).

</details>

## 8. Condizioni al contorno per Eulero 1D non stazionario

<details>
<summary><strong>Inquadramento — la regola delle caratteristiche entranti [12]</strong></summary>

**# condizioni da imporre su un bordo = # caratteristiche entranti** in quel bordo. In 1D le famiglie sono
3 ($u-a,\ u,\ u+a$); il loro **segno** (regime sub/supersonico) decide quante entrano. È la logica delle
**esercitazioni** quando si impongono pressione/velocità/temperatura ai contorni nei vari regimi.

</details>

<details>
<summary><strong>Approfondimento [N22] — le condizioni al contorno in dettaglio (ricetta + tabella)</strong></summary>

**Ricetta generale (vale per qualsiasi bordo e regime):**
1. Sul bordo traccia le 3 caratteristiche e guarda i **segni** di $\lambda_1=u-a,\ \lambda_2=u,\ \lambda_3=u+a$ (dipendono dal regime e dal verso del flusso).
2. Conta quante **entrano** nel dominio (portano informazione da **fuori**): tante quante sono = **numero di BC da imporre**.
3. Le caratteristiche **uscenti** portano informazione **dall'interno** → le grandezze corrispondenti si **estrapolano** dall'interno (compatibilità $W_k=W_k^{\text{interno}}$), **non** si impongono.
4. BC imposte + compatibilità uscenti = sistema completo → si ricava lo **stato al bordo**.

**Tabella riassuntiva** (flusso entrante con $u>0$):

| Bordo / regime | $\lambda$ entranti | # BC | Cosa si **impone** (tipico) | Cosa si **estrapola** dall'interno |
|---|---|---|---|---|
| Ingresso **supersonico** | 3 (tutte) | **3** | $p_0,\ T_0,\ M$ (o $u,S$ + 1 termodinamica) | nulla |
| Ingresso **subsonico** | 2 ($\lambda_2,\lambda_3$) | **2** | $p_0,\ T_0$ (o $S$ e $h_0$) | $W_1=\tfrac{a}{\phi}-u$ |
| Uscita **supersonica** | 0 | **0** | nulla | tutto ($W_1,W_2,W_3$) |
| Uscita **subsonica** | 1 ($\lambda_1$) | **1** | $p$ statica (riflettente) **o** $W_1$ (non riflettente) | $W_2,W_3$ |
| **Parete** solida | — | $u_n=0$ | velocità normale nulla | resto via Riemann/RH |

**Note pratiche:**
- Le **due grandezze termodinamiche** imposte devono essere **indipendenti** (non $T$ e $a$ insieme: sono legate da $a^2=\gamma R T$).
- **Riflettente vs non riflettente:** imporre la **pressione statica** a un'uscita subsonica è *riflettente* (le onde acustiche incidenti rimbalzano → disturbi artificiali); imporre l'**invariante entrante** $W_1$ è *non riflettente*. In LES si usano **strati assorbenti** per evitare riflessioni.
- **Collegamento esercitazioni:** in pratica (es. turbomacchine) si impone **pressione/temperatura totali a monte** e **pressione statica a valle** (subsonico) — è esattamente il conteggio delle caratteristiche entranti.
- **Numerica:** al bordo l'informazione "interna" arriva dalla **prima cella**; si risolve un piccolo problema di **Riemann/compatibilità** al contorno.

</details>

<details>
<summary><strong>Figura — ingresso e uscita supersonici</strong></summary>

![Ingresso supersonico: 3 caratteristiche entranti](images/lc_bc_ingresso_supersonico.png)
![Uscita supersonica: 3 caratteristiche uscenti](images/lc_bc_uscita_supersonica.png)

- **Ingresso supersonico** ($u>a$): tutte e 3 $\lambda>0$ → entrano → **3 condizioni** (2 termodinamiche
  indipendenti + 1 cinematica).
- **Uscita supersonica:** tutte uscenti → **nessuna BC** (imporne darebbe risultati non fisici; eccezione:
  un urto che risale).

</details>

<details>
<summary><strong>Figura — uscita subsonica e riflessioni acustiche</strong></summary>

![Uscita subsonica: λ1=u-a rientra](images/lc_bc_uscita_subsonica.png)

In subsonico $\lambda_1=u-a<0$ → **una** caratteristica rientra → **1** BC: *non riflettente* (impongo
l'invariante $W_1=a/\phi-u$) oppure *pressione statica* (comoda ma **riflettente**).

![Analogia riflessione: corda fissata al muro](images/lc_riflessione_onda.png)

Analogia corda fissata al muro → onda riflessa uguale e opposta. La pressione statica genera riflessioni
artificiali; per evitarle si usano **strati assorbenti** (utile in LES).

</details>

<details>
<summary><strong>Figura — ingresso subsonico (caso più complesso)</strong></summary>

![Ingresso subsonico: λ1 risale, λ2,λ3 entrano](images/lc_bc_ingresso_subsonico.png)

$\lambda_3,\lambda_2>0$ entrano; $\lambda_1=u-a<0$ **risale** → **2** BC (tipicamente $T_0$ e $p_0$, o
entropia + entalpia totale) con $W_1=a/\phi-u$ noto dall'interno. Si ricava $a$ (eq. 2° grado, radice
positiva), poi $u,T,p,\rho$.

</details>

<details>
<summary><strong>Figura — parete solida</strong></summary>

![Parete solida: condizione di velocità normale nulla](images/lc_parete_solida.png)

Parete impermeabile → velocità normale nulla; analogo a un pistone: $\lambda_2$ verso la parete diventa
**verticale** ($u=0$). Si genera **urto** (fluido verso la parete) o **espansione**. Nel limite isentropico
si usa l'invariante: $\{u=0,\ a/\phi+u=W_{3L},\ S=S_L\}$ → $a$, poi $T,p,\rho$. Collega Eulero a
**Navier–Stokes** (no-slip).

</details>

## 9. Modelli a confronto e ruolo delle Rankine–Hugoniot

<details>
<summary><strong>Figura [24] — mappa dei modelli (mermaid)</strong></summary>

```mermaid
graph TD
    PDE["Legge di conservazione<br/>dU/dt + dF/dx = 0"] --> SCAL["SCALARE<br/>(1 equazione)"]
    PDE --> VETT["VETTORIALE<br/>(sistema)"]
    SCAL --> SL["Scalare LINEARE<br/>advezione: f = a*u<br/>vel. d'onda a = cost<br/>caratteristiche parallele"]
    SCAL --> SNL["Scalare NON lineare<br/>Burgers: f = u^2/2<br/>vel. d'onda f'(u) = u<br/>urti / espansioni"]
    VETT --> VL["Vettoriale LINEARE<br/>eq. d'onda / acustica<br/>A costante, lambda = +/- alpha*sqrt(epsilon)"]
    VETT --> VNL["Vettoriale NON lineare<br/>Eulero: lambda = u, u+a, u-a<br/>urto + contatto + espansione"]
    SL -. "niente urti<br/>(non si irripidisce)" .-> NORH["RH dà s = a (banale)"]
    SNL --> RH["RANKINE-HUGONIOT<br/>s = salto(f) / salto(U)<br/>salto flusso / salto cons."]
    VNL --> RH
    RH --> BUR["Burgers: s = (uA+uB)/2<br/>(media SOLO qui)"]
    RH --> EUL["Eulero: salti di<br/>massa, q.moto, energia"]
    style RH fill:#ffe0b2,stroke:#e65100,stroke-width:2px
    style SNL fill:#e8f5e9
    style VNL fill:#e8f5e9
```

Le **Rankine–Hugoniot** non sono un modello a sé: sono la **condizione di salto** che attraversa tutti i
modelli **con discontinuità** (scalare non lineare *e* sistemi). Sul lineare degenerano in $s=a$.

</details>

## Formule e dimostrazioni

<details>
<summary><strong>Formule — specchietto del capitolo</strong></summary>

**Scalare lineare**

| Formula | Hint |
| --- | --- |
| $u_t+a u_x=0,\ u=u_0(x-at)$ | profilo traslato a velocità $a$ |
| $a=\partial f/\partial u$ | velocità d'onda = derivata del flusso |
| $\frac{Du}{Dt}=u_t+a u_x=0$ | derivata materiale nulla lungo $dx/dt=a$ |
| $du=0$ lungo la caratteristica | compatibilità (derivata direzionale) |

**Burgers e Rankine–Hugoniot**

| Formula | Hint |
| --- | --- |
| $u_t+u u_x=0,\ f=u^2/2$ | vel. d'onda $f'(u)=u$ → urti/espansioni |
| $t_b=-1/\min u_0'$ | tempo di breaking |
| $s=[\![f]\!]/[\![u]\!]$ | RH (universale) |
| $s=(u_A+u_B)/2$ | **solo** Burgers |
| $u=x/t$ | rarefazione autosimile |

**Sistemi ed Eulero**

| Formula | Hint |
| --- | --- |
| $\partial_t W_k+\lambda_k\partial_x W_k=0$ | $W=L^{-1}U$, scalari disaccoppiati |
| $\lambda=\{u-a,u,u+a\}$ | autovalori Eulero |
| $A'=\left(\begin{smallmatrix}u&\rho&0\\0&u&1/\rho\\0&\rho a^2&u\end{smallmatrix}\right)$ | matrice primitiva $(\rho,u,p)$ |
| $\lambda=\pm\alpha\sqrt\varepsilon$ | sistema 2×2: $\varepsilon=\pm1$ iperb./ellitt. |
| $J^{\pm}=u\pm\frac{2a}{\gamma-1}$ | invarianti di Riemann ($\phi=\frac{\gamma-1}{2}$) |
| $s[\![\rho]\!]=[\![\rho u]\!]$, … | RH per Eulero (massa, q.moto, energia) |

</details>

<details>
<summary><strong>Dimostrazione — lista da saper fare</strong></summary>

| Dimostrazione | Da → a |
| --- | --- |
| Linea caratteristica (scalare → sistema → multi-D) | $\frac{du}{dt}=u_t+\frac{dx}{dt}u_x$ vs $u_t+au_x=0$ → $\frac{dx}{dt}=a$; $f'(u)$; $\lambda_k$; cono multi-D |
| Linea caratteristica via differenziale + Cramer | $\det=dx-a\,dt=0\Rightarrow dx/dt=a$ |
| **[25] Rankine–Hugoniot per Burgers** | $f=u^2/2\Rightarrow s=(u_A+u_B)/2$ |
| Rankine–Hugoniot dal bilancio integrale | $\frac{d}{dt}\int U+[\![F]\!]=0\Rightarrow s[\![U]\!]=[\![F]\!]$ |
| Compatibilità (sistema) | $L^{-1}(U_t+AU_x)=0\Rightarrow dW_k/dt=0$ lungo $\lambda_k$ |
| **[Q2] Matrice $A'$ di Eulero (primitive)** | da massa/q.moto/energia → $A'(\rho,u,p)$; $\det(A'-\lambda I)=0\Rightarrow\lambda=u,u\pm a$ |
| Autovalori di Eulero 1D | $(\lambda-u)(\lambda-u-a)(\lambda-u+a)=0$ |
| Invarianti di Riemann (omoentropico) | $dW_{1,3}=\frac{da}{\phi}\mp du=0\Rightarrow J^{\pm}=u\pm\frac{2a}{\gamma-1}$ |

</details>

<details>
<summary><strong>Mappa — domande → sezioni (tracciabilità)</strong></summary>

**Batch precedente (1–30):** 1 → §1 "iperboliche"; 2,3,4 → §1; 5,6,10,11,13 → §1 figura $(x,t)$;
7,8,12,18 → §1 BC + §8; 9,23 → figure SVG + script; 15 → §1 derivate; 16 → §1 derivazione; 14,19 → onda
periodica/PDF; 20,21,22,24,25,26,28,29 → §2; 27 → §6; 30 → flashcard.

**Batch §5 (questo, 1–11):** 1 → §5 "primitive vs conservative" (+ codice/Latex); 2 → §5 "come si ricava
$A'$" (+ Dimostrazioni + flashcard); 3 → §5 "$A'$ non simmetrica"; 4 → §5 "reali e distinti" + "autovalori
$u,u\pm a$"; 5 → §5 "autovalori coincidenti"; 6 → §5 "iperbolico anche in subsonico"; 7 → §5 figura
dominio + "indietro nel tempo"; 8 → §5 "urto curvo staccato"; 9 → §5 "calcolo autovettori"; 10 → §5/§7
"invarianti di Riemann + Sod"; 11 → riorganizzazione in toggle + legenda (questo).

**Batch §5–§8 (tag [N1]–[N22]):** N1 tipi di onde · N2 tabella sub/super · N3 lettura coni (frecce) ·
N4 costo non stazionario · N5 tabella conservative/primitive/caratteristiche · N6 perché compatibilità ·
N7 tabella 3 invarianti · N8 omoentropico vs no → tutti in **§5**. N9–N17 (pistone: due figure, legge di
moto, punto morto, urto, invarianti pre/post urto, punto $K$, onde $\lambda_3$, zona gialla, altre linee)
→ **§6**. N18 Riemann generale vs Sod · N19 background matematico · N20 profili $\rho,p,u,T$ · N21
caratteristiche da ogni punto → **§7**. N22 condizioni al contorno in dettaglio → **§8**.

</details>
