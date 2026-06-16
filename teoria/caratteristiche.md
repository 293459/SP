# Metodo delle caratteristiche

> Regime tipicamente **supersonico/iperbolico**: l'informazione viaggia lungo le
> **linee caratteristiche** (cono di Mach), non ovunque. È il complemento del file
> [`bilancio.md`](bilancio.md) (leggi di conservazione e sistema di Eulero), da cui
> si eredita la forma quasi-lineare $\partial_t U + A(U)\,\partial_x U = 0$ con
> $A = L\Lambda L^{-1}$.

## Nomenclatura essenziale

<details>
<summary><strong>📖 Simboli e nomenclatura usati nel capitolo</strong></summary>

| Simbolo | Nome | Note |
|---|---|---|
| $\lambda_k,\ \Lambda$ | **autovalori** / matrice diagonale | velocità di propagazione delle onde |
| $L,\ L^{-1}$ | matrici di **autovettori** | $A=L\Lambda L^{-1}$ |
| $dx/dt=\lambda_k$ | **linea caratteristica** $k$-esima | curva nello spazio-tempo |
| $W_k$ | **variabile caratteristica** | $dW_k/dt=0$ lungo la caratteristica |
| $J^{\pm}=u\pm 2c/(\gamma-1)$ | **invarianti di Riemann** | costanti lungo $dx/dt=u\pm c$ |
| $c$ | **velocità del suono** | $c^2=\gamma p/\rho$ |
| $s$ | velocità dell'**urto** mobile | $s[\![U]\!]=[\![F]\!]$ |
| $[\![\cdot]\!]$ | **salto** monte ↔ valle | $[\![q]\!]=q_R-q_L$ |
| Rankine–Hugoniot | relazioni di **salto** attraverso l'urto | monte ↔ valle |

</details>

> **Idea chiave:** premoltiplicando il sistema iperbolico per $L^{-1}$ lo si
> **disaccoppia** in equazioni scalari; lungo ogni caratteristica $dx/dt=\lambda_k$
> una PDE diventa una **ODE** ($dW_k/dt=0$). Le discontinuità (urti) si trattano con
> le relazioni di salto di **Rankine–Hugoniot**.

---

## Equazioni di Eulero e metodo delle caratteristiche

<details>
<summary><strong>Equazioni di Eulero 1D (instazionario)</strong></summary>

</details>

<details>
<summary><strong>Rappresentazione nello schema spazio-tempo</strong></summary>

</details>

<details>
<summary><strong>Equazioni di compatibilità</strong></summary>

</details>

<details>
<summary><strong>Equazioni iperboliche</strong></summary>

</details>

<details>
<summary><strong>Linee caratteristiche:</strong></summary>

</details>

<details>
<summary><strong>Definizione fisica</strong></summary>

</details>

<details>
<summary><strong>Definizione matematica</strong></summary>

</details>

<details>
<summary><strong>Propagazione discontinuità con Rankine-Hugoniot</strong></summary>

</details>

---

## Formule da ricordare (memo)

<details>
<summary><strong>🧠 Tutte le formule chiave del capitolo, con hint per ricordarle</strong></summary>

> Specchietto: formule da tenere a memoria, con un gancio mnemonico e i collegamenti tra loro.

### Caratteristiche e compatibilità

| Formula | Hint / collegamento |
| --- | --- |
| $\dfrac{\partial U}{\partial t} + A(U)\dfrac{\partial U}{\partial x} = 0$ | **Forma quasi-lineare** ereditata da `bilancio.md`: il punto di partenza per diagonalizzare. |
| $A = L\,\Lambda\,L^{-1}$ | **Diagonalizzazione**: autovalori reali → sistema iperbolico → esistono le caratteristiche. |
| $\dfrac{dx}{dt}=\lambda_k$ | **Linea caratteristica**: curva lungo cui viaggia l'onda $k$-esima (per Eulero $\lambda=\{u,\ u+c,\ u-c\}$). |
| $\dfrac{dW_k}{dt}=0$ lungo $\dfrac{dx}{dt}=\lambda_k$ | **Equazione di compatibilità**: la PDE disaccoppiata diventa una ODE → $W_k$ è una *variabile caratteristica* trasportata. |

### Invarianti di Riemann (Eulero 1D isentropico)

| Formula | Hint / collegamento |
| --- | --- |
| $du\pm\dfrac{dp}{\rho c}=0$ lungo $\dfrac{dx}{dt}=u\pm c$ | Forma differenziale lungo le caratteristiche acustiche. |
| $J^{\pm}=u\pm\dfrac{2c}{\gamma-1}$ | **Invarianti di Riemann**: costanti lungo $dx/dt=u\pm c$ (isentropico, $c^2=\gamma p/\rho$). |

### Salto attraverso l'urto

| Formula | Hint / collegamento |
| --- | --- |
| $s\,[\![U]\!]=[\![F]\!]$ | **Rankine–Hugoniot**: condizione di salto coerente con la forma conservativa $\partial_t U+\partial_x F=0$. $s$ = velocità dell'urto, $[\![\cdot]\!]$ = salto monte↔valle. |

</details>

---

## Dimostrazioni (lista)

<details>
<summary><strong>📐 Dimostrazioni da saper fare</strong></summary>

| Dimostrazione | Punto di partenza → arrivo |
| --- | --- |
| Equazioni caratteristiche e di compatibilità | Da $U_t+A U_x=0$ con $A=L\Lambda L^{-1}$ → premoltiplico per $L^{-1}$ → lungo $dx/dt=\lambda_k$ la PDE diventa la ODE $dW_k/dt=0$ (invariante). |
| Invarianti di Riemann (Eulero 1D) | Da $du\pm dp/(\rho c)=0$ lungo $dx/dt=u\pm c$ (isentropica, $c^2=\gamma p/\rho$) → $J^{\pm}=u\pm 2c/(\gamma-1)$ costanti. |
| Rankine-Hugoniot dal bilancio integrale | Da $\frac{d}{dt}\int U\,dx+[F]=0$ con urto mobile a velocità $s$ → regola di Leibniz e limite sull'intervallo → $s[\![U]\!]=[\![F]\!]$. |

</details>
