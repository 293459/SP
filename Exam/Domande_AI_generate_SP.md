# Domande tipo — GENERATE DALL'IA (SP) — *non realmente proposte*

> ⚠️ **Attenzione**: queste domande **non sono state fatte all'esame**. Sono **generate dall'IA**
> a partire dalla teoria e dal report, come **esercizio** per anticipare possibili richieste.
> Le domande realmente proposte stanno nel file principale `Domande_Esame_SP.md`.

---

> ⚠️ **Attenzione**: le domande seguenti **non sono state effettivamente fatte all'esame**. Sono
> **generate dall'IA** a partire dalla teoria e dal report, come **esercizio** per anticipare possibili
> richieste. Usale per allenarti, ma non confonderle con quelle reali sopra.

## 🤖 Teoria (AI)

<details>
<summary><strong>🤖 [AI] Perché lo schema di Roe è più accurato di Lax–Friedrichs a parità di griglia? Lo è anche su un campo liscio come il bump?</strong></summary>

Roe **decompone il salto** $\mathbf{U}^R-\mathbf{U}^L$ nelle **onde caratteristiche** (autovettori
della matrice Jacobiana) e applica a ciascuna la **giusta** dissipazione $\propto|\lambda_k|$;
Lax–Friedrichs usa un'unica dissipazione $\propto\lambda_{max}$ per **tutte** le onde, quindi
sovradissipa quelle lente. Su **discontinuità** il vantaggio è netto (urti più nitidi). Su un campo
**liscio** come il bump il guadagno è **modesto** (i due campi sono quasi sovrapponibili), ma si vede
ancora nell'**errore** (norma entropia più bassa per Roe sulle griglie fini, $p$ più vicino a 1).

</details>

<details>
<summary><strong>🤖 [AI] Cos'è il Grid Convergence Index (GCI) e perché si introduce un fattore di sicurezza?</strong></summary>

Il GCI trasforma la stima d'errore di Richardson in una **banda d'incertezza conservativa**:
$\text{GCI} = F_s\,\dfrac{|u_h-u_{2h}|}{r^p-1}$, con $F_s=3$ (2 griglie) o $1.25$ (3 griglie in regime
asintotico). Non misura la convergenza iterativa, ma quanto la soluzione è ancora lontana dal valore
**grid-independent**. Il fattore $F_s$ rende la stima **prudente** (barra d'errore affidabile, non
ottimistica). Valori indicativi: $\lesssim 1\%$ ottimo, $1$–$5\%$ accettabile, $>5$–$10\%$ mesh
troppo rada. (cfr. `report_QA.md` Domanda 25.)

</details>

<details>
<summary><strong>🤖 [AI] Perché un solver esplicito "esplode" oltre il limite CFL, mentre un implicito no? Perché nel corso si è usato l'esplicito?</strong></summary>

Gli espliciti hanno **regione di assoluta stabilità limitata** (condizionatamente stabili): oltre
$\text{CFL}_{max}$ l'errore viene amplificato a ogni passo → crescita esponenziale. Gli impliciti
sono spesso **A-stabili** (incondizionatamente stabili), ammettono $\text{CFL}\gg 1$ al prezzo di
**risolvere un sistema** (Jacobiano) a ogni passo. Nel corso si è scelto l'esplicito per **semplicità
implementativa** e perché mostrare la **stabilità condizionata** (ruolo del CFL) è un **obiettivo
didattico**. Nel report si usa $\text{CFL}=0.3$, con margine di sicurezza rispetto al limite teorico.

</details>

<details>
<summary><strong>🤖 [AI] Perché il bump converge più lentamente (in iterazioni) della doppia rampa?</strong></summary>

Le velocità caratteristiche sono $u\pm a$ e $u$. Nel **supersonico** (rampa, $M=3$) tutte le onde
viaggiano **a valle** e i transitori attraversano il dominio **in una sola passata** → convergenza
rapida. Nel **subsonico** (bump, $M=0.3$) l'onda $u-a$ va **controcorrente**: le informazioni
**rimbalzano** tra inlet e outlet più volte prima di assestarsi → servono **più iterazioni**.
(cfr. `report_QA.md` Domanda 14.)

</details>

<details>
<summary><strong>🤖 [AI] Senso fisico dell'errore di troncamento e concetto di "equazione modificata"</strong></summary>

Sviluppando in **Taylor** lo schema discreto attorno alla soluzione esatta, i termini di troncamento
si raccolgono come **termini differenziali aggiuntivi**: lo schema risolve, di fatto, un'**equazione
modificata** che contiene **diffusione numerica** (termini pari, $\partial^2$, dissipano) e
**dispersione numerica** (termini dispari, $\partial^3$, sfasano le onde). Senso fisico: la
"viscosità numerica" che smussa gli urti è proprio il primo termine d'errore.

</details>

## 🤖 Turbolenza (AI)

> Domande vaste da orale ricavate dalle vecchie sezioni *Domande / Quiz / Domande aperte* di
> `teoria/turbolenza.md`. Sono **generate dall'IA**, non realmente proposte. Il dettaglio completo è
> nei toggle del file di teoria.

<details>
<summary><strong>🤖 [AI] Descrivi la cascata energetica di Kolmogorov e spiega la legge $E(k)\propto k^{-5/3}$.</strong></summary>

L'energia è **iniettata alle grandi scale** (produzione), **trasferita** attraverso la regione
inerziale verso scale via via più piccole, e infine **dissipata** alla scala di Kolmogorov. Nella
regione inerziale non c'è né produzione né dissipazione: l'energia transita a tasso costante
$\varepsilon$. Per argomenti dimensionali (Kolmogorov 1941) $E(k)\propto\varepsilon^{2/3}k^{-5/3}$:
la pendenza **−5/3** in scala log-log è la firma universale della cascata.

</details>

<details>
<summary><strong>🤖 [AI] Perché $\overline{u'v'}$ non è in generale nullo, anche se $\overline{u'}=\overline{v'}=0$?</strong></summary>

Perché $u'$ e $v'$ sono **statisticamente correlate**: i vortici trasportano in modo coerente
fluido veloce verso zone lente (es. $v'>0$ porta $u'<0$ vicino a parete). Anche se ogni fluttuazione
ha media nulla, la loro **covarianza** $\overline{u'v'}$ no, e misura il **trasporto turbolento di
quantità di moto** (lo sforzo di Reynolds). Due variabili a media nulla possono essere correlate.

</details>

<details>
<summary><strong>🤖 [AI] Qual è il problema di chiusura delle RANS e quali strategie esistono?</strong></summary>

Mediando le NS compare il tensore di Reynolds $-\rho\overline{u_i'u_j'}$ (**6** incognite nuove) non
esprimibile con le sole grandezze medie: il sistema è **aperto** (10 incognite, 4 equazioni → 6
mancanti). Strategie: **modelli a viscosità turbolenta** (Boussinesq → $\mu_T$ via modelli algebrici,
1 eq. Spalart-Allmaras, 2 eq. $k$-$\varepsilon$/$k$-$\omega$/SST) oppure **Reynolds Stress Models**
(7 equazioni, trasporto diretto delle componenti, nessuna ipotesi di isotropia).

</details>

<details>
<summary><strong>🤖 [AI] Universalità delle piccole scale: da cosa dipendono e perché?</strong></summary>

Le scale di Kolmogorov $\eta=(\nu^3/\varepsilon)^{1/4}$ dipendono **solo** da $\nu$ e $\varepsilon$:
geometria e condizioni al contorno fissano solo le **grandi** scale, che attraverso la cascata
impongono $\varepsilon$; le piccole si **auto-organizzano** per dissiparlo. Per questo la loro
struttura è universale (indipendente da forma del corpo e $Re$).

</details>

<details>
<summary><strong>🤖 [AI] Perché il costo della DNS scala come $Re^3$?</strong></summary>

$L/\eta\propto Re^{3/4}$ → in 3D $N_{celle}\propto Re^{9/4}$; il passo temporale aggiunge
$\propto Re^{3/4}$ → costo totale $\propto Re^{9/4}\cdot Re^{3/4}=Re^3$. Per $Re\sim10^6$ è proibitivo.

</details>

<details>
<summary><strong>🤖 [AI] RANS vs URANS: differenza concettuale.</strong></summary>

**RANS:** media temporale $T\to\infty$, tutta l'informazione temporale persa, per flussi stazionari
in media. **URANS:** media su finestra intermedia $T_{avg}$ con $\tau_{turb}\ll T_{avg}\ll\tau_{slow}$:
filtra le fluttuazioni turbolente rapide ma **mantiene l'evoluzione lenta** (es. vortex shedding).

</details>

<details>
<summary><strong>🤖 [AI] Cos'è la shielding function nel DDES e quale problema risolve?</strong></summary>

Nel DES lo switch RANS→LES avviene per $C_{DES}\Delta<d$; con mesh fini parallele alla parete scatta
**dentro** il boundary layer, dove non c'è contenuto turbolento risolto → **Modelled Stress
Depletion** (separazione precoce artificiale). Il DDES introduce $f_d$ che, basata su $r_d$ (alto nel
BL), **forza la RANS in tutto il boundary layer** a prescindere dalla mesh, attivando la LES solo
nella regione separata.

</details>

<details>
<summary><strong>🤖 [AI] Perché le turbine di bassa pressione sono un banco di prova critico per le RANS?</strong></summary>

Operano a **basso Reynolds**: lo strato limite resta laminare per gran parte della pala e la
**transizione indotta da separazione** (bolla laminare) governa le perdite. Le RANS a turbolenza
piena assumono il BL già turbolento e sbagliano molto; i modelli di transizione ($\gamma$-$Re_\theta$)
migliorano ma faticano su riattacco e perdite → spesso serve LES/DNS.

</details>

<details>
<summary><strong>🤖 [AI] Differenza tra short bubble e long bubble di separazione laminare.</strong></summary>

Il flusso laminare separa sul profilo; se transisce e **si riattacca rapidamente** la bolla resta
**corta** (short, riattacco turbolento), se la transizione è lontana o assente la bolla si **allunga**
e resta prevalentemente laminare (long). Rilevante per droni e turbine LP a basso $Re$.

</details>

## 🤖 Fluidodinamica ed equazioni di Eulero (AI)

<details>
<summary><strong>🤖 [AI] Classificazione delle PDE (ellittico/parabolico/iperbolico) e legame con il discriminante: perché conta in CFD?</strong></summary>

Per una PDE del 2° ordine il segno del **discriminante** $\Delta=B^2-4AC$ distingue **iperbolico** ($\Delta>0$, onde, dominio di dipendenza finito → flussi comprimibili/supersonici), **parabolico** ($\Delta=0$, diffusione/transitori) ed **ellittico** ($\Delta<0$, equilibrio, influenza in tutto il dominio → subsonico/incomprimibile). Conta perché determina **come si propaga l'informazione** e quindi schema numerico e **condizioni al contorno** ammissibili.

</details>

<details>
<summary><strong>🤖 [AI] Sistema di Eulero in forma quasi-lineare: Jacobiana, autovalori e loro significato.</strong></summary>

Scritto $\partial_t U+A\,\partial_x U=0$ con $A=\partial F/\partial U$ (Jacobiana del flusso), il sistema è **iperbolico** perché $A$ è diagonalizzabile con autovalori **reali** $\{u,\,u+c,\,u-c\}$: sono le **velocità delle caratteristiche** (onde di entropia/contatto e onde acustiche). Spiegano perché in supersonico ($u>c$) tutte le onde vanno a valle (niente influenza da monte).

</details>

<details>
<summary><strong>🤖 [AI] Cosa cambia numericamente tra flusso subsonico (ellittico) e supersonico (iperbolico)?</strong></summary>

Nel supersonico (iperbolico) l'informazione viaggia lungo caratteristiche a velocità finita → si usano schemi **upwind** che rispettano il verso di propagazione e le condizioni al contorno si impongono in base al **segno degli autovalori** (numero di condizioni = numero di caratteristiche entranti). Nel subsonico/ellittico l'informazione è globale → serve risolvere un problema accoppiato su tutto il dominio.

</details>

## 🤖 Meshing (AI)

<details>
<summary><strong>🤖 [AI] Metriche di qualità della mesh (skewness, aspect ratio, ortogonalità): perché contano?</strong></summary>

Misurano quanto le celle si discostano dalla forma ideale: **skewness** $\approx0$ (deviazione angolare), **aspect ratio** $\approx1$ (allungamento; $>1000$ mal condiziona), **ortogonalità** $\approx1$ (allineamento facce-congiungenti). Celle scadenti aumentano l'**errore di discretizzazione** (specie nei gradienti/termini diffusivi) e peggiorano la **convergenza**; $\det(J)\le0$ significa volume negativo (cella ribaltata) → calcolo non valido.

</details>

<details>
<summary><strong>🤖 [AI] Approccio ALE: differenza euleriano/lagrangiano e quando serve la velocità di griglia.</strong></summary>

Nella forma ALE il flusso convettivo usa la **velocità relativa** $(\mathbf v-\mathbf v_g)$, con $\mathbf v_g$ velocità della griglia: $\mathbf v_g=0$ → **euleriano** (griglia fissa), $\mathbf v_g=\mathbf v$ → **lagrangiano** (griglia segue il fluido). Serve quando il dominio si **deforma/muove** (palette mobili, superfici libere, FSI) mantenendo la conservazione (Reynolds transport).

</details>

## 🤖 Flussi rarefatti (AI)

<details>
<summary><strong>🤖 [AI] Numero di Knudsen: definizione, regimi e perché Navier-Stokes falliscono.</strong></summary>

$Kn=\lambda/L$ (libero cammino medio / scala caratteristica). Regimi: continuo ($Kn<0.01$, NS validi), **slip** ($0.01$–$0.1$, NS con condizioni di scorrimento), **transizionale** ($0.1$–$10$) e **molecolare libero** ($Kn>10$). NS falliscono quando $Kn$ cresce perché vengono meno l'ipotesi del continuo e la **vicinanza all'equilibrio** (distribuzione di Maxwell-Boltzmann) su cui si fondano le relazioni costitutive (viscosità, Fourier).

</details>

<details>
<summary><strong>🤖 [AI] DSMC: idea di base, perché Monte Carlo e quali vincoli numerici.</strong></summary>

Il **Direct Simulation Monte Carlo** segue **particelle rappresentative** (ognuna vale $F_{num}$ molecole reali) alternando **free-flight** deterministico e **collisioni stocastiche** campionate per cella. È statistico perché risolvere l'equazione di Boltzmann direttamente è proibitivo. Vincoli: cella $\Delta x\lesssim\lambda$, passo $\Delta t\lesssim\tau_c$ (tempo di collisione) e abbastanza particelle per cella ($N\sim$ decine) per ridurre il rumore statistico.

</details>

## 🤖 Turbomacchine (AI)

<details>
<summary><strong>🤖 [AI] Mixing plane vs sliding mesh: fedeltà, costo, cosa si conserva e cosa si perde.</strong></summary>

Il **mixing plane** media in direzione circonferenziale all'interfaccia statore-rotore: **stazionario** ed economico, ma **perde** le interazioni instazionarie (scie, potenziale) e introduce un *mixing* numerico. Lo **sliding mesh** fa scorrere realmente la griglia del rotore: **instazionario**, costoso, ma cattura le interazioni; richiede interfaccia non-conforme con connettività che cambia nel tempo.

</details>

<details>
<summary><strong>🤖 [AI] Condizioni corocroniche / phase-lag: idea, perché passi diversi danno risultati diversi, time-lag.</strong></summary>

Sfruttano la **periodicità spazio-temporale**: il canale adiacente vede la stessa fisica **sfasata nel tempo** di un *time-lag* legato al rapporto dei passi e alla velocità di rotazione, così si simula **un solo canale** invece di tutta la corona. Passi diversi (numero pale statore≠rotore) cambiano lo sfasamento e quindi il contenuto in frequenza dell'interazione; il costo è in **memoria** (storia temporale da salvare).

</details>

## 🤖 Modelli di ordine ridotto (AI)

<details>
<summary><strong>🤖 [AI] POD: cosa sono snapshot, modi ed energia catturata (RIC)?</strong></summary>

Si raccolgono **snapshot** (soluzioni a istanti/parametri diversi), se ne estrae una base ottima di **modi** (autovettori della matrice di correlazione) ordinati per **energia** (autovalori). Il **RIC** (Relative Information Content) $\sum_{i\le r}\lambda_i/\sum\lambda_i$ dice quanta energia cattura una base troncata a $r$ modi; tipicamente bastano pochi modi per il 99%.

</details>

<details>
<summary><strong>🤖 [AI] Come si costruisce il modello ridotto (proiezione di Galerkin) e quali sono i limiti?</strong></summary>

Si **proietta** il sistema completo sulla base POD (Galerkin), ottenendo poche ODE per i coefficienti modali → soluzione **online** rapidissima. Limiti: i ROM lineari faticano con **forti non linearità**, perdono accuratezza per **parametri fuori dal training**, e possono essere instabili; servono iperriduzione (DEIM) o ROM non lineari.

</details>

## 🤖 Flussi reagenti (AI)

<details>
<summary><strong>🤖 [AI] Mixing fraction: cos'è e perché si usa? Premiscelato vs diffusivo.</strong></summary>

La **mixing fraction** $Z$ misura la frazione di massa proveniente dal combustibile: è uno scalare **conservato** (senza termine sorgente) che disaccoppia mescolamento e chimica. Nelle fiamme **diffusive** (non premiscelate) combustibile e ossidante arrivano separati e bruciano dove si incontrano ($Z$ stechiometrico); nelle **premiscelate** sono già mescolati e il fronte di fiamma si propaga.

</details>

<details>
<summary><strong>🤖 [AI] Numero di Damköhler: definizione e regimi.</strong></summary>

$Da=\tau_{flow}/\tau_{chem}$ (scala dei tempi fluidodinamica / chimica). $Da\gg1$: chimica **veloce** rispetto al mescolamento → fronte sottile, regime *mixed-is-burnt* (flamelet); $Da\ll1$: chimica **lenta** → reattore ben mescolato. Governa quale modello di combustione usare.

</details>

## 🤖 Report / esercitazione (AI)

<details>
<summary><strong>🤖 [AI] Sul bump l'entropia "esatta" è nota: che vantaggio dà rispetto alle altre esercitazioni?</strong></summary>

Sul bump (subsonico, inviscido, no urti) il flusso è **isentropico**, quindi
$\|\bar S\|_2^{\,\rm esatto}=0$ è **noto a priori**. Questo permette di valutare l'**errore in modo
diretto** ($E=u_h-0=u_h$) e di leggere l'ordine dalla **pendenza log–log** senza estrapolare, e di
**validare** il codice contro i dati di riferimento del docente. Su paletta e presa, invece, la
soluzione esatta **non** è nota e serve l'estrapolazione di Richardson vera e propria.

</details>

<details>
<summary><strong>🤖 [AI] Perché sulla doppia rampa si mostra il campo di entropia e non la temperatura?</strong></summary>

In un flusso di Eulero $p,\rho,T,S$ sono legati da relazioni algebriche, quindi mostrare $p+M$ è già
sufficiente. Dove ci sono **urti** (doppia rampa) l'**entropia** è la grandezza **più informativa**:
"fotografa" dove e quanto si producono **perdite** (salto di $S$ attraverso gli urti), cosa che la
temperatura mostrerebbe meno chiaramente. Sul bump, isentropico, $\bar S\approx 0$ ovunque e mostrarla
serve solo come **misura d'errore**. (cfr. `report_QA.md` Domanda 20.)

</details>

<details>
<summary><strong>🤖 [AI] Come distingui, nei campi della presa, un'onda fisica da un artefatto numerico/di mesh?</strong></summary>

Criterio operativo: se la struttura (linea isomach sottile, gradino) **si sposta o sparisce
raffinando la mesh** o sistemando una discontinuità di griglia → è **numerica** (smearing,
riflessione spuria). Se **resta ancorata a uno spigolo geometrico** (labbro, ginocchio rampe) e scala
con la fisica → è **reale** (onda di Mach/compressione, urto riflesso). (cfr. `report_QA.md`
Domande 8–9, 11.)

</details>

<details>
<summary><strong>🤖 [AI] Eulero vs RANS sulla paletta: quali quantità integrali ti aspetti accurate e quali no?</strong></summary>

**Accurata con Eulero**: la **portanza/lift** e la distribuzione di **pressione** (dominati
dall'effetto inviscido). **Non accurata con Eulero**: la **resistenza/drag** (componente d'attrito e
di scia viscosa assente), lo **strato limite**, la **scia** e ogni effetto di **separazione**. Il
RANS recupera questi ultimi modellando la turbolenza, al prezzo dell'errore di modello (es. SA in
forte SBLI).

</details>
