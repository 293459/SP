Module Variabili
use strutture
Implicit none
save ! la funzione save serve a mantenere il valore delle variabili anche dopo la fine del modulo, in questo modo possiamo accedere a queste variabili da qualsiasi parte del programma 
     ! che utilizza questo modulo, ad esempio dal main.f90 o da altri moduli che fanno use di questo modulo
      
! ******************************************************************************************************
        ! in questo primo blocco vengono dichiarate tutte le variabili utilizzate nel programmae il loro tipo (intero, reale, carattere, ecc.) e dimensione (ad esempio scalare o vettore)
        integer :: kfinal, kinf, kout, k
		! k inf frequenza info a schermo -- k out frequenza salvataggio soluzione -- k final simulazione termina (se k = k final interrompi simulazione)
		real(4) :: gam,ga,gb,gc,gd,ge,gf,gg,gh,gi,gj !rapporto dei valori specifici e variabili correlate ovvero le costanti che compaiono nelle equazioni 
		! di stato e nei calcoli dei flussi, ad esempio gam è il rapporto dei calori specifici, ga,gb,... sono costanti 
		! che dipendono da gam e vengono usate per semplificare le espressioni dei flussi e delle variabili di stato
		real(4)::time,dt! tempo e passo temporale
		real(4)::CFL ! Numero di CFL
		real(4)::periodo ! passo lungo y in caso di problema periodico   -- attivo solo in caso di problemi periodici. Con lungo y si intende la distanza 
		!tra i due bordi periodici, ad esempio se abbiamo un canale con lunghezza lungo y pari a 0.1, allora il periodo è 0.1
		character(100)::mesh_file ! Nome del file mesh in formato Gmsh 2  -- ad esempio bump.msh
		real(4)::ttotin,ptotin,alpha,pexit,machin ! Condizioni al contorno in ingresso, ad esempio la temperatura totale ttotin, la pressione totale ptotin,
		! l'angolo di attacco alpha, la pressione in uscita pexit e il numero di Mach in ingresso machin
		integer::nnodi,ninterf,nele,nele_interni,nele_bordi,nentity,ndim,neqs ! numero delle varie entità geometriche, dimensioni ed equazioni -- parte pre processing riferirsi a leggi_gmsh
		! indicano rispettivamente il numero di nodi, interfacce, elementi totali, elementi interni, elementi di bordo, entità fisiche, dimensione del problema e numero di equazioni
		real(4),dimension(4)::norm2_residuals,norminf_residuals ! variabili per monitorare la convergenza, ad esempio la norma L2 e la norma infinito dei residui
		! real(4)::norm_entropy ! variabile per monitorare la convergenza (aggiunta da me)
! ******************************************************************************************************

! ******************************************************************************************************
        ! in questo secondo blocco vengono dichiarati i vettori di tipo nodo, elemento e interfaccia, che conterranno tutte le informazioni geometriche e di stato del problema
		type(tipo_nodo),dimension(:), allocatable  :: nodo  ! array dei nodi, con tipo definito nel modulo strutture, contiene ad esempio le coordinate dei nodi e altre informazioni utili
		type(tipo_interfaccia),dimension(:), allocatable  :: interf !array delle interfacce
		type(tipo_elemento),dimension(:), allocatable  :: ele_all !array che contiene tutti gli elementi (sia quelli 2D che quelli 1D)
		type(tipo_elemento_solido),dimension(:), allocatable  :: ele ! array che contiene gli elmenti 2D
		type(tipo_bordo),dimension(:), allocatable  :: ele_bordi ! array che contiene gli elementi 1D usati sul bordo
		type(tipo_entity),dimension(6)  :: entita !array con le varie entità fisiche definite nel file di mesh, ad esempio entita(1) potrebbe essere il muro, entita(2) potrebbe essere l'ingresso, ecc.
! ******************************************************************************************************

! ******************************************************************************************************
		! in questo terzo blocco vengono dichiarate le variabili necessarie per l'output in formato Tecplot
		integer,dimension(:),allocatable::nodi_vis,nodi_agg_vis !array indici necessari per output in formato Tecplot
		integer::nnodi_vis,index_perio1 ! variabili per output in formato Tecplot, ad esempio nodi_vis contiene gli indici dei nodi da salvare su file, nodi_agg_vis contiene gli indici dei nodi
		! aggiuntivi necessari per salvare la soluzione in formato Tecplot, nnodi_vis è il numero totale di nodi da salvare su file, index_perio1 è l'indice del primo nodo del bordo periodico 
		! (utile per salvare la soluzione in formato Tecplot in caso di problemi periodici)
! ******************************************************************************************************
End module





