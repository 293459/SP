# Report — Domande & Risposte (Simulazione d'esame)

> Risposte alle 26 domande sul report delle esercitazioni (bump, paletta LS59, presa a doppia
> rampa, Fluent, convergenza). Formato toggle Notion (`<details>`), **parole chiave** in grassetto.
> Molte di queste osservazioni sono state riportate anche come commenti/aggiunte nei file LaTeX
> del report.

---

## Indice tematico
- **Paletta LS59:** domande 1–4
- **Presa a doppia rampa (fisica del campo):** domande 5–12
- **Condizioni al contorno e convergenza:** domande 13–14
- **Confronto sperimentale / Eulero / Fluent:** domande 15–20
- **Teoria della convergenza (Richardson, GCI, CFL):** domande 21–26

---

## Paletta LS59

<details>
<summary><strong>Domanda 1 — È rilevante che ci siano valori di y⁺ differenti tra upper e lower surface della paletta?</strong></summary>

Sì, è **fisicamente atteso** e non è un errore. Il **y⁺** dipende dallo **sforzo di parete**
$\tau_w$ (tramite la velocità d'attrito $u_\tau=\sqrt{\tau_w/\rho}$): dove il flusso è **più
veloce** e i **gradienti** sono più intensi, $\tau_w$ è maggiore e quindi $y^+$ cresce, a parità
di altezza della prima cella.

Sulla paletta **estradosso (dorso)** ed **intradosso (ventre)** hanno carichi diversi: sul
**dorso** il flusso **accelera** molto (massima velocità, massimo $\tau_w$ → $y^+$ più alto),
sul **ventre** il flusso è più lento (→ $y^+$ più basso). Quindi una **differenza di y⁺ tra le
due superfici riflette la differente distribuzione di velocità/carico** del profilo, ed è
**coerente** con il fatto che la paletta è caricata in modo asimmetrico. È rilevante solo nel
senso che **conferma** la fisica: l'importante è che **entrambe** restino sotto la soglia
($y^+ \lesssim 5$) per risolvere il sottostrato viscoso.

</details>

<details>
<summary><strong>Domanda 2 — Come si interpreta il campo di Mach della paletta in scia? Cosa sono le strutture di forma strana? È una zona vorticosa?</strong></summary>

L'interpretazione che proponi è corretta. Sul **dorso** il flusso accelera più che sul ventre
(ragionevole), e **rimane attaccato a lungo** prima di separare (buon profilo). Al **bordo di
fuga** il Mach **scende**: questo è il sintomo della **scia** (*wake*).

Le **strutture strane in scia** sono la **regione di scia viscosa**: dietro al bordo di fuga,
i due strati limite (dorso e ventre) si **uniscono** in uno strato di taglio (*shear layer*) a
**bassa velocità/basso Mach**. Se il bordo di fuga è a **cuneo** o smussato, si forma una
piccola **zona di ricircolo** (coppia di **vortici contro-rotanti**) immediatamente a valle:
ecco perché il **Mach scende** lì (fluido quasi fermo/ricircolante). Le forme "a goccia" o
asimmetriche sono il **deficit di quantità di moto** della scia che viene **convetto e diffuso**
a valle, allargandosi.

Quindi sì: **basso Mach in scia = deficit di velocità + possibile ricircolo vorticoso** dietro al
trailing edge. È una struttura **fisica** legata alla separazione al bordo di fuga, ben colta dal
modello viscoso (RANS) e solo parzialmente da Eulero.

</details>

<details>
<summary><strong>Domanda 3 — Incrociando Mach e pressione sulla paletta, in scia la pressione si comporta diversamente dal Mach: ha senso? E la struttura strana nella parte bassa del bordo di fuga è un effetto di bordo del dominio?</strong></summary>

**Ha senso** che pressione e Mach si comportino diversamente in scia. Nella scia il **Mach è
basso** (deficit di velocità), ma la **pressione tende a ri-uniformarsi** (*pressure recovery*):
una scia, a differenza della velocità, vede la pressione statica tornare verso il valore della
corrente esterna perché la scia è una zona a **pressione quasi costante** trasversalmente
(condizione tipica degli strati di taglio liberi). Quindi **Mach e pressione sono disaccoppiati**
in scia: il Mach segue la velocità, la pressione segue il bilancio con l'esterno. Comportamenti
"diversi" sono coerenti.

Per la **struttura nella parte bassa del bordo di fuga**: va distinto se è (a) un effetto fisico
o (b) un **effetto di bordo del dominio / della periodicità**. Indizi:
- se la struttura è **ancorata al trailing edge** e si allunga lungo la direzione della scia → è
  **fisica** (scia + eventuale onda al bordo di fuga in transonico);
- se compare **vicino al bordo del dominio periodico** o all'**outlet**, e cambia spostando il
  confine, → è un **artefatto numerico/di bordo** (riflessione all'outlet, interazione con la
  condizione periodica). Per la LS59 in cascata, la **periodicità** può creare strutture apparenti
  dove la scia di una pala interagisce con il bordo periodico.

**Verifica pratica:** controllare se la struttura si modifica allontanando l'outlet o raffinando
lì la mesh; se sparisce/cambia molto, è di bordo. Nel report conviene **segnalare l'ambiguità** e
attribuirla con cautela alla scia, non escludendo un contributo della condizione al contorno.

</details>

<details>
<summary><strong>Domanda 4 — Per il profilo di strato limite della paletta, bisogna specificare a quale wall appartiene? L'andamento dovrebbe essere autosimile a prescindere dallo snapshot?</strong></summary>

**Sì, va specificato a quale parete e in quale stazione (x/c) è estratto.** Il motivo: il profilo
di strato limite **non è universale in valore assoluto** — lo **spessore** $\delta$, lo
**spessore di quantità di moto** $\theta$ e il **fattore di forma** $H$ **crescono lungo la corda**
e **differiscono tra dorso e ventre** (gradienti di pressione opposti).

L'idea di **autosimilarità** vale solo in forma **normalizzata** e **sotto ipotesi precise**:
se si plotta $u/u_e$ in funzione di $y/\delta$ (variabili di similarità), i profili di strato
limite **laminari** con gradiente di pressione nullo (Blasius) **collassano** su un'unica curva.
Ma:
- in presenza di **gradiente di pressione** (favorevole sul dorso in accelerazione, avverso verso
  il TE) la forma **cambia** (Falkner–Skan);
- in **regime turbolento** o vicino a **separazione**, l'autosimilarità si **rompe**;
- l'**interazione con onde d'urto** (transonico) altera completamente il profilo.

Quindi: **in forma adimensionale e in zone "tranquille"** l'andamento è circa lo stesso, ma
**bisogna comunque dichiarare wall e stazione** perché (i) lo spettatore deve sapere se è
estradosso/intradosso, (ii) proprio le **eccezioni** (separazioni, SBLI, transizione) sono la
parte interessante e dipendono da **dove** si è preso lo snapshot. Nel report va aggiunta la
dicitura "estratto sull'estradosso a $x/c = \dots$".

</details>

## Presa a doppia rampa (fisica del campo)

<details>
<summary><strong>Domanda 5 — Perché sulla presa a doppia rampa il y⁺ si richiede solo sulla superficie inferiore? È legato alla condizione di simmetria invece che di strato limite?</strong></summary>

In parte sì, ma il motivo principale è **dove serve risolvere lo strato limite**. Il $y^+$ è una
metrica significativa **solo su pareti viscose** (no-slip), dove esiste uno strato limite da
risolvere. Lungo la **parete inferiore** (le rampe + fondo canale) si sviluppa lo strato limite
**fisicamente importante** e avviene l'**interazione urto–strato limite (SBLI)**: lì il $y^+$ è
cruciale.

Sugli **altri bordi** non ha senso (o non serve) calcolarlo:
- un bordo di **simmetria / far-field** non è una parete: **non c'è strato limite**, quindi il
  $y^+$ è privo di significato fisico;
- la **parete superiore** del condotto è una parete viscosa, ma — come dice esplicitamente il
  report — **non è stata raffinata** perché la sua gestione è complicata dalla presenza dello
  **spigolo** (labbro), e risolverne lo strato limite **esula dagli obiettivi**; quindi non se ne
  riporta il $y^+$.

Quindi: si riporta il $y^+$ **solo dove si è scelto di risolvere lo strato limite con
l'inflazione**, cioè la parete inferiore. La tua intuizione (simmetria → niente strato limite →
niente $y^+$) è corretta per i bordi non-parete; per la parete superiore è invece una **scelta di
modellazione** dichiarata.

</details>

<details>
<summary><strong>Domanda 6 — Perché nella doppia rampa si usa una p_tot "locale" mentre per il Mach isentropico della LS59 si usa la p_tot all'ingresso? La p_tot in ingresso è più comoda per il Mach isentropico a parete?</strong></summary>

La differenza dipende da **se la pressione totale si conserva o no**, cioè dalla **presenza di
urti**.

**LS59 (subsonico, niente urti):** il flusso è **isentropico** dall'ingresso fino a parete. In
un flusso isentropico la **pressione totale si conserva** ($p^\circ = \text{cost}$), quindi la
$p^\circ$ all'**ingresso** è anche la $p^\circ$ **locale** ovunque. Si può allora definire il
**numero di Mach isentropico a parete** dalla pressione statica locale:

$$
M_{is} = \sqrt{\frac{2}{\gamma-1}\left[\left(\frac{p^\circ}{p_w}\right)^{\frac{\gamma-1}{\gamma}} - 1\right]}
$$

usando $p^\circ = p^\circ_{in}$. È **comodo e corretto** perché $p^\circ_{in}$ è nota, costante e
fisicamente quella giusta.

**Doppia rampa (supersonico, con urti):** attraverso ogni **urto obliquo** la pressione totale
**diminuisce** (generazione di entropia): $p^\circ_{locale} < p^\circ_{in}$ a valle degli urti.
Quindi **non** si può usare $p^\circ_{in}$ per definire un Mach isentropico a parete: il risultato
sarebbe **fisicamente sbagliato** (sovrastimerebbe il Mach, perché ignora la perdita di $p^\circ$).
Per questo nella doppia rampa **non** si parla di $M_{is}$ ma si riporta semplicemente il
**rapporto di pressione** $p_w/p^\circ_{in}$ come **normalizzazione** (per confrontare i dati),
oppure si userebbe la $p^\circ$ **locale** post-urto se si volesse un Mach isentropico locale.

**In sintesi:** $p^\circ_{in}$ è valida come riferimento **solo se conservata** (caso isentropico
LS59). Con urti (doppia rampa) la $p^\circ$ "vera" è quella **locale**, ridotta dalle perdite, e
$p^\circ_{in}$ resta utile **solo come fattore di normalizzazione**, non come $p^\circ$ isentropica.

</details>

<details>
<summary><strong>Domanda 7 — Alcuni punti del y⁺ della doppia rampa sono leggermente sopra 5. Dobbiamo preoccuparci del valore in sé? Come si interpreta l'andamento e i picchi di y⁺? Che informazioni fisiche dà?</strong></summary>

**Il valore in sé non è un dramma** se di poco sopra 5: la soglia $y^+\lesssim5$ serve a garantire
che il baricentro della prima cella stia nel **sottostrato viscoso** (dove vale $u^+=y^+$), così
da risolvere lo strato limite senza *wall functions*. Punti leggermente sopra 5 (zona *buffer*,
$5<y^+<30$) implicano una risoluzione **localmente** meno accurata, ma **non invalidano** la
simulazione; per rigore si aumenterebbero i layer di inflazione (come nota il report).

**Interpretazione fisica dell'andamento di y⁺:** poiché $y^+ \propto u_\tau \propto \sqrt{\tau_w}$,
il $y^+$ è una **mappa dello sforzo di parete**. Quindi:
- **picchi di y⁺** ↔ **massimo sforzo a parete** ↔ flusso **localmente molto accelerato** o forte
  gradiente. Sulle rampe i picchi si trovano **dove passa l'urto obliquo** o dove la corrente
  accelera: l'urto comprime e accelera localmente il flusso aumentando $\tau_w$;
- **cali di y⁺** ↔ basso $\tau_w$ ↔ flusso **rallentato o separato** (in una **bolla di
  separazione** lo sforzo di parete si annulla/inverte, $y^+ \to 0$).

Quindi dal $y^+$ si **leggono** indirettamente: posizione degli **urti** (picchi), zone di
**separazione** (minimi), e in generale la distribuzione di **carico viscoso** a parete. I picchi
"proprio lì" segnalano dove l'**interazione urto–strato limite** è più intensa.

</details>

<details>
<summary><strong>Domanda 8 — Le curve isomach della doppia rampa mostrano due urti obliqui. Perché non sono linee esatte? È interazione con lo strato limite o una questione numerica? (Non il Knudsen dei flussi rarefatti.)</strong></summary>

Hai ragione: **non è il Knudsen** (lo spessore d'urto fisico in regime continuo è di pochi liberi
cammini medi, invisibile a questa scala). Gli urti obliqui non appaiono come **linee
matematicamente sottili** per **due ragioni concomitanti**:

1. **Spalmamento numerico (smearing):** lo schema ai volumi finiti **diffonde** la discontinuità
   su **alcune celle** (la dissipazione numerica, più marcata in Lax–Friedrichs, minore in Roe).
   L'urto "vero" è una discontinuità, ma sulla griglia diventa una **rampa ripida spessa qualche
   cella**. Raffinando la mesh l'urto si **assottiglia** (il report lo dice esplicitamente). Questa
   è la causa **dominante** dello spessore apparente.

2. **Interazione con lo strato limite (caso viscoso):** vicino a parete l'urto **non può restare
   rettilineo** perché incontra lo strato limite subsonico: si **curva** (forma a $\lambda$),
   genera onde di compressione e una zona di interazione SBLI. Questo rende la linea isomach
   **incurvata e ispessita** in prossimità della parete.

Inoltre, anche idealmente, un urto **obliquo** non è del tutto rettilineo se il Mach a monte
**varia** lungo l'urto (es. il secondo urto attraversa un campo già non uniforme post-primo-urto):
una **piccola curvatura** è quindi anche **fisica**.

**Conclusione:** lo spessore/non-rettilineità è soprattutto **numerico** (smearing, riducibile
raffinando), con un contributo **fisico** vicino a parete (interazione con lo strato limite nel
caso RANS). Il Knudsen non c'entra.

</details>

<details>
<summary><strong>Domanda 9 — C'è una piccola linea isomach simile a un urto obliquo ma più sottile/debole. Cos'è? Un'onda di compressione elementare? È dovuta al fatto che la mesh aveva un pezzetto separato? Ha valenza fisica?</strong></summary>

Le ipotesi sono entrambe plausibili e vanno distinte.

**Se ha valenza fisica:** una linea isomach **sottile e debole** è tipicamente un'**onda di Mach /
onda di compressione (o espansione) elementare**: una perturbazione **debole** generata da una
**piccola deflessione** della parete (uno spigolo minore, il **labbro** della presa, o il
ginocchio tra le rampe). A differenza di un urto obliquo "forte" (grande deflessione, grande salto
di proprietà), un'onda di Mach produce variazioni **infinitesime** → linea isomach **tenue**.
Vicino al **labbro/cuneo** è proprio dove ci si aspetta il **terzo urto** debole o un **ventaglio
di espansione** (espansione di Prandtl–Meyer) all'angolo convesso: le sue linee caratteristiche
appaiono come **sottili linee isomach**. Questo **ha senso fisico** e rappresenta come la presa
gestisce la deflessione vicino all'imbocco del canale.

**Se è un artefatto:** se quella linea **coincide** con una **discontinuità della mesh** (un
pezzetto separato, un cambio brusco di dimensione cella, una linea di transizione del campo
Threshold), allora può essere un **artefatto numerico**: il salto di risoluzione genera una
**riflessione spuria** o un gradino di dissipazione che si manifesta come falsa isolinea. Il fatto
che l'elemento di mesh fosse **separato** dagli altri è un campanello d'allarme in questo senso.

**Come distinguere:** se la linea **scompare/si sposta** raffinando o sistemando la mesh → era
**numerica**; se **resta ancorata** a uno spigolo geometrico → è **fisica** (onda di Mach/debole
compressione). Nel report conviene mostrarla e **commentarla come probabile onda di compressione
elementare al labbro**, segnalando però la possibile origine di mesh da verificare.

</details>

<details>
<summary><strong>Domanda 10 — C'è un'interazione tra gli urti obliqui nella zona finale vicino alla parte verticale? Come influenza il campo di moto?</strong></summary>

Sì, è proprio uno dei fenomeni centrali della doppia rampa (e il motivo della geometria
semplificata). I **due urti obliqui** (primo dalla rampa 1, secondo dalla rampa 2) **convergono** e
**si intersecano** in un punto a valle; oltre a essi, il **labbro/cuneo** della presa genera un
**terzo urto**. Nella **zona finale** questi urti **interagiscono**.

L'interazione urto–urto produce, a seconda dei Mach e degli angoli:
- un **punto triplo** con un **urto riflesso** e una **linea di scorrimento** (*slip line*,
  contatto tra flussi a uguale pressione ma diversa velocità/entropia);
- un possibile **urto normale/forte** localizzato, dietro cui può comparire una **tasca subsonica**;
- un aumento locale di **pressione e temperatura** e una **perdita di pressione totale** maggiore
  (gli urti multipli/interagenti dissipano di più).

**Effetto sul campo di moto:** la corrente viene **ulteriormente rallentata e compressa**, il campo
diventa **disuniforme** (zone a Mach diverso separate da slip line), e — se nasce un tratto
subsonico — cambia **localmente la natura delle equazioni** (da iperbolica a ellittica). È esatto
questo rischio che ha motivato il **taglio del dominio** nella geometria semplificata, per
mantenere tutto supersonico ed evitare di dover gestire condizioni al contorno ellittiche
all'interno. Quindi la tua impressione è corretta e l'interazione è **significativa**.

</details>

<details>
<summary><strong>Domanda 11 — La zona blu in basso alla parete orizzontale vicino all'uscita è una bolla di ricircolo? E le geometrie triangolari sono riflessioni a parete? Di urti o di espansioni? Cosa accade nella regione superiore del tratto orizzontale?</strong></summary>

**Zona blu (basso Mach) sul fondo vicino all'uscita:** sì, coerente con una **bolla di ricircolo**
da **separazione** indotta dall'interazione urto–strato limite (il report la mostra esplicitamente
per il caso viscoso, fig. bolla di ricircolo). Nella bolla la velocità è bassa/invertita → **Mach
basso** → blu. È un fenomeno **viscoso**, colto da RANS e non da Eulero.

**Geometrie triangolari:** sono molto probabilmente le **riflessioni delle onde a parete**. In un
condotto supersonico un'onda (urto o espansione) che colpisce una parete **si riflette**, e le
riflessioni successive tra parete inferiore e superiore creano un **pattern a "diamanti"/triangoli**
(la tipica struttura a celle dei getti/condotti supersonici). Si tratta di:
- **riflessione di urti obliqui** (un urto incidente si riflette come urto), e/o
- **riflessione di ventagli di espansione** all'angolo convesso del labbro.
Spesso coesistono: urto → riflesso → poi espansione → riflessa, generando il reticolo triangolare.

**Regione superiore del tratto orizzontale:** il piccolo **calo di pressione** con **basso Mach**
che osservi è la firma del passaggio di queste onde. Va interpretato come **qualcosa in più di un
semplice rallentamento**: è il risultato del **sistema di urti/espansioni riflessi** che
ridistribuisce pressione e velocità. Un **calo di pressione + basso Mach** localizzato indica
tipicamente il passaggio attraverso un **ventaglio di espansione** (accelera, abbassa $p$) seguito
o preceduto da compressioni; in zona di **separazione** il basso Mach è invece dovuto al
ricircolo. La regione superiore "sente" le riflessioni della parete inferiore e viceversa: il campo
è un **mosaico di compressioni ed espansioni** in equilibrio.

</details>

<details>
<summary><strong>Domanda 12 — Come faccio a sapere a priori che il flusso in uscita dalla doppia rampa è supersonico? E perché si fornisce la pressione di uscita se non è applicata? (Suggerimento: aggiungere in teoria le CC in base a velocità e regime.)</strong></summary>

**Come si sa a priori:** in una **presa supersonica a compressione esterna** la finalità di
progetto è proprio **rallentare** il flusso ipersonico/supersonico (qui $M=3$) tramite **urti
obliqui deboli**, mantenendolo **ancora supersonico** all'uscita (es. $M\approx1.5$) per poi, a
valle, decelerarlo ulteriormente. Due livelli di ragionamento:
1. **Progettuale:** si **vuole** un'uscita supersonica perché la presa alimenta a valle un
   componente (es. ulteriore diffusione, o un combustore di uno **scramjet**) che lavora in
   supersonico; la geometria a doppia rampa è dimensionata con la **teoria degli urti obliqui**
   (relazioni $\theta$–$\beta$–$M$) in modo che **dopo i due urti** $M$ resti $>1$.
2. **Stima teorica:** noti $M_{in}=3$ e gli angoli delle rampe ($\sim10°$ e $\sim21°$), dalle
   **tabelle/relazioni degli urti obliqui** si calcola $M$ dietro ciascun urto e si **verifica**
   che resti supersonico, **senza** simulare. Solo se gli angoli fossero troppo grandi si avrebbe
   **distacco dell'urto** (detached) e tasca subsonica.

**Perché si fornisce $P_{exit}$ se non è applicata:** è una questione di **come tratta le CC il
codice in base al regime**:
- In **outlet supersonico** **tutte** le caratteristiche escono dal dominio → **nessuna**
  informazione entra da fuori → si **estrapolano tutte** le variabili dall'interno e la $P_{exit}$
  imposta viene **ignorata**.
- In **outlet subsonico** una caratteristica **rientra** → bisogna imporre **una** condizione
  (tipicamente la **pressione statica** $P_{exit}$).

Il valore $P_{exit}=0.001$ è quindi un **placeholder**: serve a riempire l'input file e a far
funzionare il codice **in caso** il flusso fosse (o diventasse) subsonico all'uscita, ma in regime
supersonico **non ha effetto**. È buona norma — come suggerisci — **aggiungere nel capitolo
teorico (cap. 3)** una tabella delle **condizioni al contorno in funzione del regime**
(sub/supersonico, inlet/outlet), che chiarisce perché certe variabili si impongono e altre si
estrapolano. *(Questa tabella è già presente nella sezione "Condizioni al Contorno" di teoria.tex;
la si richiama esplicitamente.)*

</details>

## Condizioni al contorno e convergenza

<details>
<summary><strong>Domanda 13 — Nella sezione 6.5 si dice che, essendo il Mach in ingresso supersonico, "si inseriscono tutte le caratteristiche da sinistra". Cosa significa? "Caratteristiche" = linee caratteristiche?</strong></summary>

Sì, **"caratteristiche" = linee caratteristiche** (le direzioni lungo cui si propaga
l'informazione nelle equazioni iperboliche). Per le equazioni di Eulero 1D le velocità
caratteristiche sono $u-a$, $u$, $u+a$ (e per 2D le corrispondenti onde).

L'affermazione significa questo: il **numero di condizioni al contorno** da imporre su un bordo è
pari al **numero di caratteristiche entranti** nel dominio da quel bordo.
- All'**inlet supersonico** ($M>1$, cioè $u>a$), **tutte** le velocità caratteristiche sono
  **positive** ($u-a>0$, $u>0$, $u+a>0$): tutte le onde **entrano** nel dominio **da sinistra**.
  Nessuna informazione viaggia da dentro verso l'inlet. Quindi si devono **imporre tutte e quattro
  le variabili** (le 4 conservative): il flusso a monte è **completamente determinato** dall'esterno.
- Se invece l'inlet fosse **subsonico** ($u<a$), la caratteristica $u-a$ sarebbe **negativa**
  (esce dal dominio): una variabile va **estrapolata** dall'interno e solo 3 si impongono.

Quindi "inserire tutte le caratteristiche da sinistra" è un modo per dire: **in inlet supersonico
tutte le onde entrano, perciò si fissano tutte le variabili al bordo** (coerente con la tabella
delle CC del cap. teorico). È la traduzione operativa della **natura iperbolica direzionale** del
flusso supersonico.

</details>

<details>
<summary><strong>Domanda 14 — Nella 6.5 si dice che con K_inf = 100 (anziché 1000) i transitori convergono più rapidamente. Va specificato il Mach del bump (0.3). Cosa vuol dire "converge più veloce"? È solo il flusso più veloce, o è la velocità di propagazione delle caratteristiche che dipende anche dalla velocità del flusso?</strong></summary>

Prima un chiarimento sui due ruoli: **K_inf** è solo la **frequenza di stampa/output a schermo**,
non cambia la fisica; un $K_{inf}$ più piccolo (100) si usa **perché** la simulazione converge in
**meno iterazioni**, quindi si vuole vedere l'output più spesso. La domanda vera è **perché**
converge prima.

**Specifica utile (da aggiungere al report):** il **bump** ha $M_{in}=0.3$ (**subsonico**), mentre
la **doppia rampa** ha $M_{in}=3$ (**supersonico**). È questa differenza a spiegare la diversa
velocità di convergenza.

**Cosa vuol dire "converge più veloce":** una simulazione stazionaria si raggiunge quando i
**transitori** (le onde che trasportano l'informazione delle condizioni al contorno) hanno
**attraversato** il dominio abbastanza volte da assestare il campo. Il numero di iterazioni
necessarie scala con il **tempo di attraversamento** del dominio diviso il **passo temporale**.

La tua intuizione è **corretta**: le **velocità caratteristiche** sono $u\pm a$ e $u$, cioè
dipendono **sia dalla velocità del suono $a$ sia dalla velocità del flusso $u$**. In regime
**supersonico** ($M=3$): tutte le onde viaggiano **a valle** ad alta velocità ($u+a$ grande,
$u-a>0$), quindi il segnale **attraversa il dominio in una sola passata** e **molto in fretta** →
**convergenza rapida**. In regime **subsonico** ($M=0.3$): l'onda $u-a$ viaggia **all'indietro**
(controcorrente), quindi le informazioni **rimbalzano avanti e indietro** più volte tra inlet e
outlet prima di assestarsi → servono **più iterazioni**.

Inoltre il passo $\Delta t$ è limitato dal **CFL** ($\Delta t \propto h/\lambda_{max}$): non è
tanto che "il flusso è più veloce e quindi finisce prima", ma che **la struttura iperbolica
supersonica fa propagare e uscire i transitori in un solo verso e in poche traversate**, mentre nel
subsonico la natura quasi-ellittica (onde in entrambi i versi) rallenta l'assestamento. Quindi:
**sì, è la velocità di propagazione delle caratteristiche** (funzione di $u$ e $a$) **e la loro
direzionalità** a determinare la convergenza più rapida nel caso supersonico.

</details>

## Confronto sperimentale / Eulero / Fluent

<details>
<summary><strong>Domanda 15 — Nel confronto sperimentale, l'assenza di valori sperimentali di pressione a parete vicino a parete è dovuta all'incapacità dell'apparato di fare sonde abbastanza piccole?</strong></summary>

In parte sì, ma più precisamente è una **limitazione di accesso e risoluzione spaziale** delle
misure a parete, non tanto di "dimensione della sonda nello strato limite". La pressione a parete
si misura tipicamente con **prese di pressione statica** (piccoli fori collegati a trasduttori),
non con sonde immerse: la difficoltà è quindi:
- **densità di prese limitata:** non si possono praticare infiniti fori sulla parete; dove i
  **gradienti sono fortissimi** (a cavallo di un urto, o vicino a spigoli/labbro) la **spaziatura
  delle prese** è troppo grossolana per catturare il salto → **mancano punti** proprio lì;
- **zone inaccessibili:** vicino agli **spigoli**, al **labbro** o all'**uscita** è fisicamente
  difficile collocare prese o farle comunicare con i trasduttori;
- **disturbo della misura:** vicino a urti/separazioni la presa stessa e il foro perturbano il
  campo, rendendo il dato poco affidabile, perciò viene **omesso**.

Quindi l'assenza di dati in certi tratti riflette **limiti pratici dell'apparato sperimentale**
(risoluzione/accesso delle prese e affidabilità in zone a forte gradiente), più che l'incapacità
di "miniaturizzare la sonda". È anche il motivo per cui il **CFD** è prezioso: **riempie** le
regioni dove l'esperimento non arriva (vedi Domanda 19).

</details>

<details>
<summary><strong>Domanda 16 — Perché il solver di Eulero dà valori costanti per x/L molto piccoli? Cosa porta Roe ad avere valori fissati? E perché c'è una regione x/L < 0? Ha senso fisico o conviene tagliarla?</strong></summary>

**Valori costanti a x/L piccolo:** la regione a monte delle rampe è il **flusso indisturbato**
($M=3$ uniforme), che **non ha ancora incontrato alcun urto**. Lì la pressione a parete è
semplicemente la **pressione statica di freestream**, **costante**. Il solutore di **Roe** (come
qualsiasi schema corretto) restituisce quindi un **plateau costante** finché non arriva il **primo
urto obliquo**, dopo il quale la pressione **salta**. Non è un artefatto: è il **tratto di
ingresso uniforme**.

**Perché x/L < 0:** dipende da **dove è posta l'origine** $x=0$ nella parametrizzazione della
parete. Nella geometria, l'origine è al **piede della prima rampa** (punto 3), ma il dominio
include un **tratto piano a monte** (punti 1–2, da $x=-0.5$ a $x=0$). Quindi $x/L<0$ è il
**tratto di parete a monte della rampa**, **fisicamente reale** (la superficie inferiore prima
dell'inizio della compressione). Non è un errore di dominio.

**Tagliarla o no:** ha senso fisico, quindi **conviene tenerla** (come suggerisci tu stesso), ma
**commentandola**: è la zona di **flusso indisturbato** che fa da **riferimento** ($p/p^\circ$ di
monte). Se si volesse comunque restringere il plot alla sola zona delle rampe, lo si fa **in
post-processing** filtrando $x \ge 0$ (es. una maschera sui dati estratti dalle celle di parete),
**non** modificando il solver. Mantenerla aiuta a **mostrare il salto** del primo urto rispetto al
livello di monte.

</details>

<details>
<summary><strong>Domanda 17 — Spalart–Allmaras in Fluent sovrastima i dati reali. Vorrei spiegazioni teoriche sul perché certi metodi sovrastimino/sottostimino. Inoltre Fluent sembra avere una curva traslata rispetto a Eulero 2D.</strong></summary>

Premessa: **non avendo il dettaglio del setup altrui non si può dire "chi ha ragione"**; si
possono però dare le **ragioni teoriche** delle deviazioni.

**Perché un modello sovrastima o sottostima la pressione a parete:**
- **Modelli inviscidi (Eulero):** ignorano lo **strato limite** e la **separazione**. A valle di
  un urto tendono a **sottostimare** la pressione perché non riproducono l'**ispessimento/
  separazione** che ridistribuisce la pressione (manca la SBLI). Predicono urti **più netti** e
  posizionati in modo idealizzato.
- **Modelli RANS (Spalart–Allmaras):** introducono la **viscosità turbolenta**. SA è un modello a
  **una equazione** tarato su flussi **aerodinamici attaccati**: in presenza di **forte SBLI e
  separazione** può **sovrastimare** o **sottostimare** a seconda di come predice il **punto di
  separazione** e l'**estensione della bolla**. Se SA **ritarda** la separazione (tipico dei
  modelli a viscosità turbolenta troppo "diffusivi"), tiene il flusso attaccato più a lungo e può
  **sovrastimare** la pressione di ricompressione a valle. Inoltre una **viscosità turbolenta
  eccessiva** ispessisce lo strato limite e **alza** la pressione a parete.
- **Posizione dell'urto:** piccole differenze nel predire **dove** cade l'urto causano grandi
  differenze locali di $p_w$ (un urto leggermente spostato sposta tutto il salto).

**Curva "traslata" di Fluent rispetto a Eulero 2D:** una **traslazione sistematica** suggerisce
una differenza di **normalizzazione** o di **riferimento**, più che di fisica:
- diversa **pressione di riferimento/totale** usata per adimensionalizzare ($p_w/p^\circ$ con
  $p^\circ$ leggermente diverso tra i due → shift verticale);
- diverso **allineamento della coordinata $x/L$** (origine/scala della parete) → shift orizzontale;
- l'effetto **viscoso** che alza uniformemente la pressione (strato limite) → shift verso l'alto.

**Cosa farne nel report:** verificare **prima** che la **normalizzazione** ($p^\circ=100000$ Pa) e
la **coordinata** siano identiche nei due dataset; se la traslazione resta, attribuirla
all'**effetto viscoso/turbolento** di SA. Il fatto che rispetto all'anno precedente il segno sia
opposto **non è di per sé indice di errore**: dipende dal modello e dal setup usati allora (ignoti),
quindi va commentato come **differenza attesa tra modelli**, non come contraddizione.

</details>

<details>
<summary><strong>Domanda 18 — Vorrei capire l'andamento di pressione: i salti repentini sono gli urti (1° salto = 1° urto, 2° salto = 2° urto)? Il crollo di pressione a parete è l'espansione vicino all'outlet? La risalita "a singhiozzi" sono le riflessioni?</strong></summary>

La lettura che proponi è sostanzialmente **corretta**. Andamento tipico di $p_w/p^\circ$ lungo la
parete inferiore della doppia rampa:

1. **Plateau iniziale** — flusso indisturbato di monte (vedi Domanda 16).
2. **Primo salto repentino** — **primo urto obliquo** (piede della prima rampa): la pressione
   **sale bruscamente** (compressione). ✔️ corrisponde al 1° urto.
3. **Secondo salto** — **secondo urto obliquo** (ginocchio tra le rampe): ulteriore **gradino di
   compressione**. ✔️ corrisponde al 2° urto.
4. **Crollo di pressione** — sì, tipicamente un **ventaglio di espansione** (Prandtl–Meyer) a un
   **angolo convesso** (fine della seconda rampa / imbocco del fondo canale o vicino all'uscita),
   dove il flusso **accelera** e la **pressione cala**. Vicino all'**outlet** può combinarsi con
   l'espansione di scarico.
5. **Risalite rapide "a singhiozzi"** — sì, sono coerenti con le **riflessioni d'onda** a parete:
   ogni urto **riflesso** che reincide sulla parete inferiore produce un **nuovo gradino di
   compressione**; poiché le riflessioni tra le due pareti del condotto sono **ravvicinate**, i
   gradini appaiono **fitti e ravvicinati** (il pattern a "diamanti" della Domanda 11). Tra una
   riflessione e l'altra possono intervallarsi piccole espansioni → l'aspetto "a singhiozzo".

Quindi: **salti = urti (incidenti e riflessi)**, **cali = espansioni**, **oscillazioni ravvicinate
= riflessioni multiple** nel condotto. È utile sovrapporre il plot di $p_w$ alle **isomach** per
associare ogni salto alla struttura d'onda corrispondente.

</details>

<details>
<summary><strong>Domanda 19 — Ci si può fidare delle stime di Eulero/Fluent nella zona finale dove l'apparato sperimentale non arriva? Come spiegare le predizioni? L'incremento di pressione è legato allo scarico in ambiente? Essendo lo scarico supersonico, cosa aspettarsi post-outlet?</strong></summary>

**Affidabilità nella zona finale:** con cautela. In quella regione il campo è dominato da
**interazioni urto–urto e urto–strato limite** e possibili **separazioni**:
- **Eulero** è **inaffidabile** lì perché ignora la separazione (che è viscosa) — utile solo per la
  struttura d'urto ideale;
- **RANS (SA)** è **più rappresentativo** perché modella la turbolenza e la separazione, ma resta
  soggetto a **errore di modello** (SA non è eccellente in forte SBLI). In assenza di dati
  sperimentali, **non si può validare**, quindi le predizioni vanno presentate come
  **qualitativamente attendibili** (specie RANS) ma **non garantite** quantitativamente.

**Incremento di pressione finale:** può avere due origini:
- **ricompressione** dovuta a urti riflessi / riattacco dello strato limite dopo la bolla;
- effetto della **condizione di scarico**. Attenzione però: se l'uscita è **supersonica**, la
  pressione ambiente a valle **non risale a monte** (nessuna caratteristica rientra), quindi un
  incremento *dentro* il dominio è dovuto alla **struttura d'onda interna**, non allo scarico.

**Cosa aspettarsi post-outlet (scarico supersonico):** dipende dal rapporto tra pressione di uscita
$p_e$ e pressione ambiente $p_a$:
- se $p_e > p_a$ (**getto sotto-espanso**): all'uscita parte un **ventaglio di espansione** di
  Prandtl–Meyer (il getto si **espande** e accelera);
- se $p_e < p_a$ (**getto sovra-espanso**): si formano **urti obliqui di ricompressione** all'uscita;
- in entrambi i casi il getto sviluppa la classica struttura a **celle/diamanti** (shock-cell
  structure) con riflessioni alternate, esattamente come nei getti supersonici di ugello.

Quindi post-outlet ci si aspetta un **getto supersonico con celle d'urto/espansione**, non un
ricircolo. Nel report conviene **dichiarare** che la zona finale è meglio descritta da RANS, che
**Eulero lì va preso con riserva**, e che a valle dell'uscita (non simulata) si avrebbe un **getto
supersonico** sotto/sovra-espanso a seconda di $p_e/p_a$.

</details>

<details>
<summary><strong>Domanda 20 — Nel materiale di riferimento per la doppia rampa compaiono pressione e Mach ma non la temperatura; è però indicato il campo di entropia. Sono equivalenti? Come si passa dall'uno all'altro?</strong></summary>

Non sono "la stessa cosa", ma in un flusso di Eulero sono **legati da relazioni algebriche**,
quindi spesso si mostra **una** grandezza rappresentativa al posto delle altre. Mostrare
**pressione + Mach** (o velocità) è di solito sufficiente perché, con l'**equazione di stato** e le
**relazioni isentropiche/di gas perfetto**, le altre grandezze si **ricavano**.

Relazioni utili (gas perfetto, $\gamma=1.4$):
- temperatura da pressione e densità: $T = p/(\rho R)$;
- entropia (adimensionale, come nel report): $\bar S = \gamma \ln \bar T - (\gamma-1)\ln \bar P$,
  cioè l'entropia è funzione **solo di $p$ e $T$**;
- in un flusso **isentropico** $p/\rho^\gamma=\text{cost}$, $T/T^\circ$ e $p/p^\circ$ legati a $M$.

Quindi:
- **dove non ci sono urti** (isentropico, come il bump): $\bar S \approx 0$ ovunque, e la
  **temperatura** è ricavabile dal Mach via relazioni isentropiche → mostrarla sarebbe **ridondante**;
- **dove ci sono urti** (doppia rampa): l'**entropia** diventa la grandezza **più informativa**
  perché evidenzia **dove e quanto** si producono **perdite** (salto di entropia attraverso gli
  urti). Il **campo di entropia** "fotografa" gli urti e le perdite meglio della temperatura.

**Come passare dall'uno all'altro:** noti due qualsiasi tra $p, T, \rho$ (più il Mach per la
velocità), tutte le altre seguono dall'equazione di stato e dalla definizione di entropia sopra.
Quindi la scelta di mostrare **entropia invece di temperatura** non implica una traccia diversa:
è una **scelta di rappresentazione**, perché l'entropia rende **immediatamente visibili gli urti e
le perdite**, mentre la temperatura aggiungerebbe poco rispetto a $p$ e $M$ già mostrati. Nel
report conviene esplicitare questa equivalenza e, volendo, aggiungere il campo di temperatura
ricavandolo da $p$ e $\rho$.

</details>

## Teoria della convergenza (Richardson, GCI, CFL)

<details>
<summary><strong>Domanda 21 — Si usa una "norma L2 dell'entropia" particolare, non la norma 2 geometrica classica. Perché questa scelta? (Da spiegare e aggiungere nel capitolo teorico.)</strong></summary>

La norma usata è una **norma $L_2$ pesata sul volume** (RMS integrale), non la norma euclidea dei
componenti del vettore:

$$
\|\bar S\|_2 = \sqrt{\frac{\sum_i \bar S_i^{\,2}\,|\Omega_i|}{\sum_i |\Omega_i|}}
$$

mentre la norma 2 "classica" (geometrica) sarebbe $\|\bar S\|_2 = \sqrt{\sum_i \bar S_i^2}$.

**Perché questa scelta (motivi fisici/numerici):**
1. **Pesatura con l'area di cella $|\Omega_i|$:** su una **mesh non uniforme** le celle hanno
   dimensioni diverse. La norma classica darebbe lo **stesso peso** a una cella grande e a una
   piccola, falsando la misura: tante piccole celle in una zona raffinata "peserebbero" troppo. La
   pesatura con $|\Omega_i|$ rende la norma una vera **approssimazione dell'integrale**
   $\int_\Omega \bar S^2\, d\Omega$, **indipendente dalla discretizzazione**.
2. **Normalizzazione per l'area totale $\sum_i|\Omega_i|$:** rende la norma un **valore quadratico
   medio (RMS)**, **indipendente dalle dimensioni del dominio** e dal **numero di celle**. Così si
   possono **confrontare griglie diverse** (l'analisi di convergenza ha senso solo se la metrica
   non dipende dal numero di nodi).
3. **Significato di errore:** poiché in flusso isentropico $\bar S_{esatto}=0$, questa norma misura
   direttamente l'**errore RMS di entropia** = stima dell'**errore numerico** distribuito sul
   dominio.

In breve: è una **norma $L_2$ discreta pesata sul volume e mediata**, scelta perché è **coerente
con l'integrale continuo**, **indipendente da mesh e dominio**, e quindi **adatta a confrontare
l'errore tra griglie**. Questa motivazione va aggiunta nel capitolo teorico subito dopo la
definizione della norma (Eq. norma_entropia).

</details>

<details>
<summary><strong>Domanda 22 — Per Richardson si dice di usare l'ordine teorico "se si ha confidence di essere nel regime asintotico". Spiegazione + grafico dell'ordine di convergenza numerico per Roe e Lax–Friedrichs (regione iniziale con ordine diverso da quello atteso, poi assestamento).</strong></summary>

**Cosa significa "regime asintotico":** l'errore di discretizzazione si sviluppa come
$E = k\,h^{p} + (\text{termini di ordine superiore})$. Solo quando la griglia è **abbastanza
fine**, il termine dominante $k\,h^p$ **prevale** sugli altri: lì la pendenza in scala log–log
**tende all'ordine formale** $p$ dello schema. Questa è la **regione asintotica**. Se invece la
mesh è **troppo grossolana**, i **termini di ordine superiore** non sono trascurabili e l'ordine
**misurato** $p_{eff}$ **differisce** da quello teorico (di solito **più basso**, perché
dissipazione ed effetti di bordo dominano).

**Quindi:** si può imporre $p=p_{teorico}$ (1° ordine per Roe/LF base) **solo se** si è confidenti
di essere in regime asintotico; **altrimenti** va stimato l'**ordine effettivo** con tre griglie
(come fa il report). I dati del report lo confermano:
- bump Roe: $p_{eff}\approx0.86$ (sol. esatta) e $0.35$ (3 griglie) — **sotto** l'ordine 1 → non
  ancora asintotico;
- bump LF: $p_{eff}\approx0.60$ / $0.23$ — ancora più basso (più dissipativo);
- doppia rampa Roe: $p_{eff}\approx1.46$ — **sopra** 1, altro sintomo di **non-asintoticità**
  (termini di ordine superiore con segno tale da gonfiare l'ordine apparente).

**Grafico (LaTeX/TikZ, da inserire nel cap. teorico):** andamento qualitativo dell'**ordine
locale** $p(h)$ in funzione di $h$ (o del livello di raffinamento), che parte **lontano** dal
valore teorico per $h$ grande e **converge** a $p_{teorico}=1$ per $h\to0$:

```latex
\begin{figure}[H]
  \centering
  \begin{tikzpicture}[scale=1.0]
    \begin{axis}[
        width=11cm, height=7cm,
        xlabel={raffinamento $\rightarrow$ ($h$ decrescente)},
        ylabel={ordine di convergenza osservato $p$},
        xmin=0, xmax=4, ymin=0, ymax=1.4,
        xtick={0,1,2,3,4},
        xticklabels={$4h$,$2h$,$h$,$h/2$,$h/4$},
        legend pos=south east, grid=both, thick]
      % ordine teorico
      \addplot[black, dashed, domain=0:4] {1.0};
      \addlegendentry{ordine teorico $p=1$}
      % Roe: si avvicina a 1 dal basso
      \addplot[blue, mark=*] coordinates {(0,0.35)(1,0.55)(2,0.75)(3,0.88)(4,0.96)};
      \addlegendentry{Roe (upwind)}
      % Lax-Friedrichs: più basso, converge più lentamente
      \addplot[red, mark=square*] coordinates {(0,0.22)(1,0.35)(2,0.50)(3,0.63)(4,0.78)};
      \addlegendentry{Lax--Friedrichs}
      % zona asintotica
      \draw[gray, <->] (axis cs:3,1.25) -- (axis cs:4,1.25)
        node[midway, above, font=\footnotesize]{regione asintotica};
    \end{axis}
  \end{tikzpicture}
  \caption{Ordine di convergenza osservato in funzione del raffinamento. Per griglie grossolane
    l'ordine effettivo è \emph{inferiore} a quello teorico ($p=1$, tratteggiato); solo
    raffinando si entra nella regione asintotica e l'ordine tende al valore formale. Lo schema di
    Roe (upwind, meno dissipativo) si avvicina più rapidamente di Lax--Friedrichs.}
  \label{fig:ordine_convergenza}
\end{figure}
```

Il messaggio del grafico: **l'ordine "vero" si vede solo asintoticamente**; lontano da lì usare
l'ordine teorico in Richardson è **rischioso**, ed è perciò che il report calcola anche l'ordine
effettivo.

</details>

<details>
<summary><strong>Domanda 23 — Cos'è il "rapporto di diradamento" (introdotto senza definizione)? Serve a infittire o diradare? È minore o maggiore di 1? La griglia h₂ è più o meno fitta di h₁?</strong></summary>

Il **rapporto di diradamento** (*grid refinement ratio*) è il **fattore $r$** tra le lunghezze
caratteristiche di due griglie:

$$
r = \frac{h_2}{h_1}
$$

Nel report (e in generale) si pone $h_2 = r\,h_1$ con **$r > 1$**. Significato:
- **$r > 1$** ⟹ $h_2 > h_1$ ⟹ la griglia con $h_2$ ha celle **più grandi** ⟹ è **più rada (più
  diradata / coarse)**;
- la griglia con $h_1$ (più piccolo) è quindi quella **più fitta (fine)**.

Quindi il termine "**diradamento**" indica che, partendo dalla griglia fine $h_1$, si **dirada**
moltiplicando per $r>1$ per ottenere $h_2$. **Non** serve a infittire: descrive di **quanto** una
griglia è più grossolana dell'altra. Tipicamente si usa $r=2$ (ogni griglia ha celle **doppie**
della precedente, cioè si **dimezza** il numero di nodi per direzione).

Riassumendo: **$r=h_2/h_1>1$**, **$h_2$ è più rada di $h_1$**, e $r$ quantifica il **salto di
risoluzione** tra i livelli di griglia usati nell'estrapolazione di Richardson. Va aggiunta una
riga di definizione nel capitolo teorico.

</details>

<details>
<summary><strong>Domanda 24 — Mostra tutti i passaggi che portano a esprimere u_esatto in funzione dei termini di destra (estrapolazione di Richardson).</strong></summary>

Si parte dall'ipotesi che l'errore segua l'andamento asintotico $E = k\,h^p$ su **due** griglie con
$h_1$ (fine) e $h_2 = r\,h_1$ (rada, $r>1$):

$$
\text{(1)}\quad u_{h_1} - u_{esatto} = k\,h_1^{p}
$$
$$
\text{(2)}\quad u_{h_2} - u_{esatto} = k\,(r h_1)^{p} = r^{p}\,k\,h_1^{p}
$$

**Passo 1 — eliminare la costante $k$.** Sottraggo la (1) dalla (2):

$$
u_{h_2} - u_{h_1} = r^{p} k h_1^{p} - k h_1^{p} = k h_1^{p}\,(r^{p} - 1)
$$

da cui:

$$
k\,h_1^{p} = \frac{u_{h_2} - u_{h_1}}{r^{p} - 1}
$$

**Passo 2 — sostituire in (1) per isolare $u_{esatto}$.** Dalla (1): $u_{esatto} = u_{h_1} -
k h_1^{p}$, quindi:

$$
u_{esatto} = u_{h_1} - \frac{u_{h_2} - u_{h_1}}{r^{p} - 1}
$$

**Passo 3 — forma compatta.** Mettendo a denominatore comune:

$$
u_{esatto} = \frac{u_{h_1}(r^{p}-1) - (u_{h_2}-u_{h_1})}{r^{p}-1}
= \frac{r^{p} u_{h_1} - u_{h_1} - u_{h_2} + u_{h_1}}{r^{p}-1}
$$

$$
\boxed{\,u_{esatto} \approx \dfrac{r^{p}\,u_{h_1} - u_{h_2}}{r^{p} - 1}\,}
$$

che è esattamente la formula del report. Forma equivalente (utile con $r=2$):

$$
u_{esatto} \approx u_{h_1} + \frac{u_{h_1} - u_{h_2}}{r^{p}-1}
$$

Il termine correttivo $\frac{u_{h_1}-u_{h_2}}{r^p-1}$ è la **stima dell'errore** $E_1$ della griglia
fine: Richardson lo **somma** alla soluzione fine per "estrapolare" verso $h\to0$.

</details>

<details>
<summary><strong>Domanda 25 — Chiarisci il Grid Convergence Index (GCI): è l'errore di troncamento in valore assoluto moltiplicato per un fattore di sicurezza, ma perché dà un indice di convergenza? L'obiettivo è minimizzarlo? Quali valori sono accettabili?</strong></summary>

**Cos'è:** il **GCI** trasforma la stima dell'errore di Richardson in una **banda di incertezza
conservativa** sulla soluzione numerica:

$$
\text{GCI} = F_s \cdot |u_h - u_{esatto}| = F_s\,\frac{|u_h - u_{2h}|}{r^p - 1}
$$

con $F_s$ **fattore di sicurezza** ($F_s=3$ per 2 griglie, $1.25$ se si usano 3 griglie nel regime
asintotico). Hai ragione: è essenzialmente l'**errore stimato per eccesso**.

**Perché è un "indice di convergenza":** non misura la convergenza **iterativa** (residui), ma la
**convergenza di griglia** — cioè **quanto la soluzione è ancora lontana dal valore a griglia
infinita**. Un GCI piccolo significa che **raffinando ulteriormente la mesh la soluzione cambierebbe
poco**: sei vicino alla soluzione **indipendente dalla griglia** (*grid-independent*). Quindi il
GCI risponde alla domanda "**di quanto mi posso fidare di questo numero, vista la mesh usata?**".
È una **barra d'errore** numerica: $u_{vero} \in [u_h - \text{GCI},\; u_h + \text{GCI}]$ (in termini
relativi, $\text{GCI}\%$).

**Obiettivo:** sì, **minimizzarlo** raffinando la mesh (o usando schemi di ordine più alto)
**finché il costo computazionale lo giustifica**. L'obiettivo non è azzerarlo (impossibile) ma
**ridurlo sotto una soglia accettabile** e dimostrare che si è **vicini alla grid-independence**.

**Valori accettabili (regola pratica):** il GCI si esprime in **percentuale**:
- $\text{GCI} \lesssim 1\%$ → soluzione **molto affidabile**, sostanzialmente grid-independent;
- $1\%$–$5\%$ → **accettabile** per la maggior parte delle applicazioni ingegneristiche;
- $> 5\%$–$10\%$ → mesh **troppo grossolana**, serve raffinare.

I valori del report (es. $\text{GCI}\approx3\times10^{-3}$ per Roe, cioè $\sim0.3\%$ in termini
della norma dell'entropia) sono **bassi → buona affidabilità**. Importante: il GCI è **piccolo e
significativo solo se si è nel regime asintotico**; con ordini effettivi anomali (Domanda 22) va
interpretato con cautela.

</details>

<details>
<summary><strong>Domanda 26 — Sul grafico residui/entropia vs CFL: una CFL oltre il limite teorico fa esplodere la soluzione. È tipico solo degli espliciti o anche degli impliciti? Roe e Lax–Friedrichs a che categoria appartengono? Perché non si è implementato un solver implicito? Spiega il compromesso CFL e il margine di sicurezza pratico.</strong></summary>

**Espliciti vs impliciti e stabilità:** il comportamento "**CFL oltre il limite → esplosione**" è
**tipico degli schemi espliciti**. La loro **regione di assoluta stabilità** è **limitata**, quindi
sono **condizionatamente stabili**: esiste un $\text{CFL}_{max}$ (per Eulero esplicito 1D
$\approx1$) oltre il quale l'errore viene **amplificato** a ogni passo → crescita esponenziale dei
residui. Gli schemi **impliciti** hanno regioni di stabilità molto più ampie (spesso
**A-stabili**, **incondizionatamente stabili**): possono usare **CFL ≫ 1** senza esplodere (al
prezzo di risolvere un **sistema** a ogni passo e di perdere accuratezza temporale se il CFL è
enorme). Quindi: **la "esplosione" è una firma degli espliciti**.

**Roe e Lax–Friedrichs:** attenzione a non confondere due assi. **Roe** e **Lax–Friedrichs** sono
**schemi di flusso spaziale** (come si calcola $\mathbf{F}_{ij}$ all'interfaccia). Nel codice del
corso sono accoppiati a un'**integrazione temporale esplicita** (Eulero in avanti, vedi
teoria.tex): è **questa** parte esplicita a imporre il vincolo CFL e a far esplodere la soluzione
oltre il limite. Quindi, **nell'implementazione del report, sono usati in modo esplicito** (come la
tua intuizione suggerisce dai risultati).

**Perché non un solver implicito:** ragioni didattiche e pratiche:
- **complessità implementativa:** un implicito richiede di **costruire e invertire** la matrice
  Jacobiana del sistema (o iterare con metodi tipo Newton/GMRES) a ogni passo — molto più oneroso
  da scrivere rispetto a un esplicito;
- **costo per iterazione:** ogni passo implicito è **molto più caro**; conviene solo se il
  $\Delta t$ molto più grande **ripaga** il costo (vero per problemi **stiff**, meno per questi casi);
- **obiettivo del corso:** capire la **stabilità condizionata** e il ruolo del CFL è proprio uno
  degli **scopi didattici**; un implicito "nasconderebbe" il fenomeno.

**Il compromesso sul CFL:** si cerca il **CFL più alto possibile** (per convergere in **poche
iterazioni**, $\Delta t \propto \text{CFL}$) **ma sotto il limite di stabilità** (per non
esplodere). Troppo basso → **lento**; troppo alto → **instabile**. Nei casi del report si usa
$\text{CFL}=0.3$, ben dentro la zona stabile.

**Margine di sicurezza pratico:** non si lavora **al limite teorico** ($\text{CFL}\approx1$) ma si
adotta un **margine** (tipicamente $\text{CFL}=0.3$–$0.7$), perché nei casi reali il limite teorico
1D **non vale esattamente**:
- **mesh non uniformi/distorte** abbassano il CFL ammissibile locale;
- **non-linearità** (urti, forti gradienti) e **2D/3D** riducono il margine;
- **condizioni al contorno** e sorgenti possono destabilizzare;
- la stima di $\lambda_{max}$ è approssimata.
Per questo si tiene un **fattore di sicurezza** (spesso $\sim0.5\times$ il limite teorico), che
garantisce **robustezza** a fronte di tutte queste incertezze, accettando una convergenza un po'
più lenta in cambio di **stabilità garantita**.

</details>
