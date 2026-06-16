# Leggi di conservazione e sistema di Eulero

## Nomenclatura essenziale

<details>
<summary><strong>📖 Simboli e nomenclatura usati nel capitolo</strong></summary>

| Simbolo | Nome | Note |
|---|---|---|
| $U$ | vettore delle **variabili conservative** | massa, q. di moto, energia |
| $F(U)$ | vettore di **flusso** | $\partial_t U+\partial_x F=0$ |
| $A(U)=\partial F/\partial U$ | **matrice Jacobiana** del flusso | governa la propagazione |
| $\lambda,\ \Lambda$ | **autovalori** / matrice diagonale | Eulero 1D: $\{u,\ u+c,\ u-c\}$ |
| $L,\ L^{-1}$ | matrici di **autovettori** | $A=L\Lambda L^{-1}$ |
| $u$ | velocità del fluido | — |
| $c$ | **velocità del suono** | $c=\sqrt{\gamma R T}$ |
| $M=u/c$ | numero di **Mach** | $<1$ subsonico, $>1$ supersonico |
| $\phi$ | **potenziale** di velocità | $(1-M^2)\phi_{xx}+\phi_{yy}=0$ |
| $\Delta=B^2-4AC$ | **discriminante** della PDE 2° ordine | $<0$ ellittica, $>0$ iperbolica |
| $A,B,C$ | coefficienti della PDE quasi-lineare | classificazione matematica |
| Rankine–Hugoniot | relazioni di **salto** attraverso l'urto | monte ↔ valle |

</details>

> **Natura del problema:** **ellittico** (subsonico) → informazione ovunque, schemi **centrati**;
> **iperbolico** (supersonico) → informazione lungo le **caratteristiche** (cono di Mach),
> schemi **upwind/marching**.

---

## Leggi di conservazione

<details>
<summary><strong>Conservations laws</strong></summary>

| Grandezza | Massa | Momentum | Energia |
| --- | --- | --- | --- |
| Integrale Euleriana |  |  |  |
| Differenziale conservativa Euleriana |  |  |  |
| Differenziale NON conservativa Euleriana |  |  |  |
| Lagrangiana |  |  |  |

Fai le dimostrazioni per ciascuna equazione di ciascuna grandezza

</details>

<details>
<summary><strong>Confronto formulazioni</strong></summary>

| Formulazione  | Ipotesi | Conservativa | Peculiarità  |
| --- | --- | --- | --- |
| Integrale Euleriana | Integrabilitá | SÌ | Robusta |
| Differenziale Conservativa Euleriana | Derivabilitá (debole) | SÌ | Forma di divergenza |
| Differenziale non conservativa Euleriana | Differenziabilitá (forte) | NO | Fisicamente intuitiva, problemi con le onde d’urto  |
| Differenziale Lagrangiana | Traiettoria | SÌ | Ottima per flussi rarefatti |

> La derivabilitá è definita debole poiché si chiede solo che la derivata esista ma non si dice nulla sul fatto che questa sia continua o meno. Invece per il teorema del differenziale totale se è differenziabile allora esistono le derivate parziale e queste sono continue (funzione di classe C^1). Fintanto che ho la forma conservativa compare solo un termine nella divergenza (quindi solo derivate parziali è derivabilitá ovvero forma debole) mentre in quella non conservativa compaiono gradienti e divergenze delle singole variabili (che potrebbero non esistere o esplodere ad infinito e per evitarlo serve che le loro derivate siano continue quindi si richiede la differenziabilitá)
> 

> La formulazione Lagrangiana è intrinsecamente conservativa perché segue le particelle e “non può perdersele” ma non viene usata per i flussi densi perché sarebbe computazionalmente troppo dispendioso.
> 

</details>

<details>
<summary><strong>Entropy and viscous phenomena</strong></summary>

</details>

## Problemi ellittici e iperbolici

<details>
<summary><strong>Problemi ellittici e iperbolici — classificazione matematica</strong></summary>

## Classificazione Matematica

La natura del flusso dipende dal discriminante delle equazioni alle derivate parziali (PDE) del secondo ordine:

$$

Au_{xx} + Bu_{xy} + Cu_{yy} + \dots = 0 \longrightarrow \Delta = B^2 - 4AC
$$

### Caso specifico: Equazione del Potenziale Linearizzato

Per un fluido comprimibile, l'equazione è:

$$

(1 - M^2)\phi_{xx} + \phi_{yy} = 0
$$

- **Regime Subsonico ($M < 1$):** $(1 - M^2) > 0 \implies \Delta < 0$.
    - **Natura:** Ellittica.
    - **Fisica:** Le perturbazioni si propagano ovunque. Serve un solutore implicito globale.
- **Regime Supersonico ($M > 1$):** $(1 - M^2) < 0 \implies \Delta > 0$.
    - **Natura:** Iperbolica.
    - **Fisica:** L'informazione viaggia lungo le **Caratteristiche** (direzione limitata dal cono di Mach). Si usano schemi "marching" espliciti.

---

## 2. Il Sistema di Eulero e il Flux Vector Splitting (FVS)

Le equazioni di Eulero 1D instazionarie in forma divergente sono:

$$

\frac{\partial U}{\partial t} + \frac{\partial F}{\partial x} = 0
$$

Introducendo la matrice Jacobiana $A(U) = \frac{\partial F}{\partial U}$:

$$

\frac{\partial U}{\partial t} + A(U)\frac{\partial U}{\partial x} = 0
$$

### Proprietà di Iperbolicità

Il sistema è **iperbolico** perché la matrice $A$ è diagonalizzabile con autovalori reali $(\lambda_1, \lambda_2, \lambda_3)$:

$$

A = L \Lambda L^{-1}
$$

Dove gli autovalori per Eulero sono: $\lambda = \{u, u+c, u-c\}$.

</details>

<details>
<summary><strong>Problemi ellittici e iperbolici — schemi numerici</strong></summary>

La classificazione dipende dal discriminante delle equazioni alle derivate parziali del secondo ordine: 

$$
A u_{xx} + B u_{xy} + C u_{yy} + \dots = 0\to \Delta = B^2 - 4AC
$$

Per un fluido comprimibile, l'equazione del potenziale linearizzata è:

$$(1 - M^2)\,\phi_{xx} + \phi_{yy} = 0$$

1. **Subsonico (**M < 1**):** (1 - M^2) > 0. Il segno è concorde. \Delta < 0. **Equazione Ellittica**.

- Matematica: Le perturbazioni si propagano **ovunque**. Serve un solutore "**implicito**" **globale**.

2. **Supersonico (**M > 1**):** (1 - M^2) < 0. Il segno è discorde. \Delta > 0. **Equazione Iperbolica**.

- Matematica: Esistono le **Caratteristiche**. L'informazione viaggia solo in una **direzione** (cono di Mach). Usiamo solutori "marching" (**espliciti**).

**Cosa cambia nel modello numerico?**

- **Ellittico:** Servono schemi centrati (l'informazione viene da destra e sinistra).
- **Iperbolico:** Servono schemi **Upwind** (l'informazione viene solo da "monte"). Usare uno schema centrato in un flusso supersonico senza correzioni causerebbe instabilità totale.

</details>

> 🔗 Il **metodo delle caratteristiche** (linee caratteristiche, equazioni di
> compatibilità, invarianti di Riemann, Rankine–Hugoniot) è trattato nel file
> dedicato [`caratteristiche.md`](caratteristiche.md), perché è il regime
> tipicamente **supersonico/iperbolico**.

## Modelli scalari e vettoriali

<details>
<summary><strong>Scalare Lineare (advezione lineare): perché "scalare", e il significato di $a$</strong></summary>

$$\frac{\partial u}{\partial t} + a\,\frac{\partial u}{\partial x} = 0 \qquad\Longleftrightarrow\qquad \frac{\partial u}{\partial t} + \frac{\partial (a\,u)}{\partial x} = 0\quad(a=\text{cost})$$

Modello-giocattolo fondamentale per studiare **stabilità e diffusione/dispersione numerica** degli schemi.

**Perché "scalare"?** Perché la variabile conservata $u$ è **una sola grandezza scalare** → c'è **una sola equazione**. Le due cose sono **collegate** (la tua intuizione è corretta): se la grandezza conservata fosse un **vettore** $\mathbf u$ avresti un **sistema** $\partial_t\mathbf u + A\,\partial_x\mathbf u=0$ (modello *vettoriale*, un'equazione per componente). Quindi "scalare ↔ una incognita / una equazione", "vettoriale ↔ vettore di incognite / sistema". L'aggettivo **"lineare"** è invece **indipendente**: riguarda il fatto che il **flusso** $f(u)=a\,u$ è lineare in $u$ (il coefficiente $a$ non dipende da $u$). Le quattro combinazioni esistono: scalare-lineare (advezione), scalare-non lineare (Burgers, $f=u^2/2$), vettoriale-lineare (acustica linearizzata), vettoriale-non lineare (Eulero).

**Il coefficiente $a$ è una velocità di propagazione anche in forma conservativa, o solo con la derivata materiale?** È velocità di propagazione in **entrambe** le forme. Per una legge di conservazione scalare $u_t+f(u)_x=0$ la **velocità d'onda/caratteristica** è $f'(u)=\dfrac{df}{du}$, proprietà **intrinseca** dell'equazione. Per il flusso lineare $f=a\,u$ si ha $f'(u)=a$ (costante): quindi $a$ è la velocità di propagazione **sia** nella forma con derivata materiale $\frac{Du}{Dt}=0$ lungo $\frac{dx}{dt}=a$, **sia** in forma conservativa $\partial_t u+\partial_x(a\,u)=0$. Anzi, essendo $a$ costante, $\partial_x(a\,u)=a\,\partial_x u$: le due forme sono **identiche** e la soluzione $u(x,t)=u_0(x-at)$ è il profilo iniziale **traslato rigidamente** a velocità $a$. La derivata materiale **non** conferisce il significato ad $a$, lo rende solo **manifesto**.

> ⚠️ La distinzione tra le due forme conta solo nel **non lineare**: con $f=u^2/2$ (Burgers) la velocità d'onda è $f'(u)=u$ (dipende da $u$ → urti), e la forma **conservativa** è quella fisicamente corretta per gli urti (dà la velocità giusta via Rankine-Hugoniot $s=[\![f]\!]/[\![u]\!]$), mentre quella advettiva vale solo per soluzioni regolari. La velocità d'onda locale resta però $f'(u)$ in entrambe.

</details>

<details>
<summary><strong>Scalare Non Lineare (Burgers):</strong></summary>

$$\frac{\partial u}{\partial t} + u\,\frac{\partial u}{\partial x} = 0 \qquad\Longleftrightarrow\qquad \frac{\partial u}{\partial t} + \frac{\partial}{\partial x}\Big(\frac{u^2}{2}\Big)=0$$

Fondamentale per studiare la formazione di discontinuità (urti): velocità d'onda $f'(u)=u$ → le creste viaggiano più veloci dei ventri → ripidità del fronte → urto.

</details>

<details>
<summary><strong>Vettoriale lineare</strong></summary>

Rappresenta sistemi di equazioni linearizzate (es. onde acustiche): $\partial_t\mathbf u+A\,\partial_x\mathbf u=0$, con $A$ matrice costante diagonalizzabile (autovalori = velocità d'onda).

</details>

<details>
<summary><strong>Note Aggiuntive sui Modelli Scalari/Vettoriali</strong></summary>

| Argomento | Descrizione | Pro | Contro |
| --- | --- | --- | --- |
| **Equazioni di Eulero 1D** | Modello per flussi comprimibili non viscosi (conservazione di massa, quantità di moto ed energia). | Fondamentali per l'aerodinamica; meno onerose delle Navier-Stokes. | Trascurano viscosità e conduzione termica (no strati limite). |
| **Linee Caratteristiche** | Percorsi nello spazio-tempo lungo i quali si propagano le onde di perturbazione. | Trasformano PDE in ODE; forniscono una comprensione fisica profonda. | Diventano matematicamente intrattabili in 2D/3D o con urti forti. |
| **Rankine-Hugoniot** | Relazioni algebriche che collegano le proprietà a monte e a valle di un urto. | Permettono di calcolare i salti di proprietà senza risolvere la struttura dell'urto. | Non forniscono dettagli sulla fisica interna alla zona d'urto. |
| **Equazione di Burgers** | Modello scalare non lineare ($\frac{\partial u}{\partial t} + u \frac{\partial u}{\partial x} = 0$) per lo studio delle onde d'urto. | Eccellente per testare schemi numerici e studiare la non-linearità. | Troppo semplificata per fluidi reali (manca il termine di pressione). |

</details>

---

## Formule da ricordare (memo)

<details>
<summary><strong>🧠 Tutte le formule chiave del capitolo, con hint per ricordarle</strong></summary>

> Specchietto: formule da tenere a memoria, con un gancio mnemonico e i collegamenti tra loro.

### Classificazione delle PDE (ellittico vs iperbolico)

| Formula | Hint / collegamento |
| --- | --- |
| $A u_{xx} + B u_{xy} + C u_{yy} + \dots = 0$ | Forma generale della **PDE quasi-lineare del 2° ordine**: i coefficienti $A,B,C$ alimentano il discriminante qui sotto. |
| $\Delta = B^2 - 4AC$ | **Discriminante** (come per le coniche!): $\Delta<0$ → **ellittica** (subsonico, schemi centrati), $\Delta>0$ → **iperbolica** (supersonico, upwind/marching). |
| $(1 - M^2)\,\phi_{xx} + \phi_{yy} = 0$ | Equazione del **potenziale linearizzato**: qui $A=(1-M^2)$, $C=1$, $B=0$ → $\Delta=-4(1-M^2)$. Il segno di $(1-M^2)$ decide tutto: $M<1$ ellittica, $M>1$ iperbolica. |

### Numero di Mach e velocità del suono

| Formula | Hint / collegamento |
| --- | --- |
| $c = \sqrt{\gamma R T}$ | **Velocità del suono**: dipende solo dalla temperatura (gas ideale). È il $c$ che compare negli autovalori di Eulero $u\pm c$. |
| $M = u/c$ | **Mach** = velocità su velocità del suono. È la soglia $M=1$ che fa cambiare natura alla PDE del potenziale ($1-M^2$). |

### Sistema di Eulero e iperbolicità

| Formula | Hint / collegamento |
| --- | --- |
| $\dfrac{\partial U}{\partial t} + \dfrac{\partial F}{\partial x} = 0$ | **Eulero 1D in forma divergente (conservativa)**: $U$ variabili conservative, $F(U)$ flusso. È la forma robusta per gli urti. |
| $A(U) = \dfrac{\partial F}{\partial U}$ | **Matrice Jacobiana** del flusso: linearizza il flusso e governa la propagazione. Ponte tra forma divergente e quasi-lineare. |
| $\dfrac{\partial U}{\partial t} + A(U)\dfrac{\partial U}{\partial x} = 0$ | **Forma quasi-lineare**: ottenuta da quella divergente via chain rule con $A=\partial F/\partial U$. |
| $A = L\,\Lambda\,L^{-1}$ | **Diagonalizzazione**: il sistema è iperbolico perché $A$ è diagonalizzabile con autovalori reali. $L$ = autovettori, $\Lambda$ = autovalori. |
| $\lambda = \{u,\ u+c,\ u-c\}$ | **Autovalori di Eulero 1D**: tre velocità di propagazione (entropia + due onde acustiche $u\pm c$). Reali → iperbolicità. Usano il $c$ della velocità del suono. |

### Modelli scalari

| Formula | Hint / collegamento |
| --- | --- |
| $\dfrac{\partial u}{\partial t} + u\,\dfrac{\partial u}{\partial x} = 0$ | **Burgers non viscosa**: caso scalare non lineare ($F(u)=u^2/2$). È l'analogo "giocattolo" di Eulero per studiare la formazione di urti. |

</details>

---

## Dimostrazioni (lista)

<details>
<summary><strong>📐 Dimostrazioni da saper fare</strong></summary>

| Dimostrazione | Punto di partenza → arrivo |
| --- | --- |
| Classificazione ellittico/parabolico/iperbolico dal discriminante | Da $A u_{xx}+B u_{xy}+C u_{yy}+\dots=0$ → equazione caratteristica $A\,(y')^2-B\,y'+C=0$ → segno di $\Delta=B^2-4AC$ ($\Delta<0$ ellittica, $\Delta=0$ parabolica, $\Delta>0$ iperbolica). |
| Forma quasi-lineare dalla forma conservativa | Da $U_t+F(U)_x=0$ → chain rule $F_x=(\partial F/\partial U)U_x$ → $U_t+A(U)U_x=0$ con $A=\partial F/\partial U$. |
| Autovalori del sistema di Eulero | Da $A(U)=\partial F/\partial U$ → polinomio caratteristico $\det(A-\lambda I)=0$ → $\lambda=\{u,\,u+c,\,u-c\}$ reali → iperbolicità ($A=L\Lambda L^{-1}$). |

> Le dimostrazioni su **caratteristiche/compatibilità, invarianti di Riemann e
> Rankine–Hugoniot** sono nel file [`caratteristiche.md`](caratteristiche.md).

</details>
