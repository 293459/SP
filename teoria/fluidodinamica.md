# Fluid dynamics

## Nomenclatura essenziale

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

> **Natura del problema:** **ellittico** (subsonico) → informazione ovunque, schemi **centrati**;
> **iperbolico** (supersonico) → informazione lungo le **caratteristiche** (cono di Mach),
> schemi **upwind/marching**.

---

- Conservations laws
    
    
    | Grandezza | Massa | Momentum | Energia |
    | --- | --- | --- | --- |
    | Integrale Euleriana |  |  |  |
    | Differenziale conservativa Euleriana |  |  |  |
    | Differenziale NON conservativa Euleriana |  |  |  |
    | Lagrangiana |  |  |  |
    
    Fai le dimostrazioni per ciascuna equazione di ciascuna grandezza 
    
- Confronto formulazioni
    
    
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
- Entropy and viscous phenomena
- Problemi ellittici e iperbolici
    
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
    
- Problemi ellittici e iperbolici
    
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
- **Equazioni di Eulero 1D (instazionario)**
- **Rappresentazione nello schema spazio-tempo**
- **Equazioni di compatibilità**
- **Equazioni iperboliche**
- **Linee caratteristiche:**
- Definizione fisica
- Definizione matematica
- **Propagazione discontinuità con Rankine-Hugoniot**
- **Modelli:**
- **Scalare Lineare:** Utilizzato principalmente per lo studio della stabilità e diffusione numerica.
- **Scalare Non Lineare (Burgers):** Fondamentale per studiare la formazione di discontinuità (urti).
- Scalare lineare
- Scalare non lineare (**Burgers non viscosa**)
- Vettoriale lineare
- **Vettoriale Lineare:** Rappresenta sistemi di equazioni linearizzate (es. onde acustiche).
- I varianti di Riemann, problema di Riemann , tubo di sod

### Note Aggiuntive sui Modelli Scalari/Vettoriali

| Argomento | Descrizione | Pro | Contro |
| --- | --- | --- | --- |
| **Equazioni di Eulero 1D** | Modello per flussi comprimibili non viscosi (conservazione di massa, quantità di moto ed energia). | Fondamentali per l'aerodinamica; meno onerose delle Navier-Stokes. | Trascurano viscosità e conduzione termica (no strati limite). |
| **Linee Caratteristiche** | Percorsi nello spazio-tempo lungo i quali si propagano le onde di perturbazione. | Trasformano PDE in ODE; forniscono una comprensione fisica profonda. | Diventano matematicamente intrattabili in 2D/3D o con urti forti. |
| **Rankine-Hugoniot** | Relazioni algebriche che collegano le proprietà a monte e a valle di un urto. | Permettono di calcolare i salti di proprietà senza risolvere la struttura dell'urto. | Non forniscono dettagli sulla fisica interna alla zona d'urto. |
| **Equazione di Burgers** | Modello scalare non lineare ($\frac{\partial u}{\partial t} + u \frac{\partial u}{\partial x} = 0$) per lo studio delle onde d'urto. | Eccellente per testare schemi numerici e studiare la non-linearità. | Troppo semplificata per fluidi reali (manca il termine di pressione). |