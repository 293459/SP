!=============================================================================!
!  output.f90 — Scrittura file Tecplot e preparazione strutture di output     !
!                                                                              !
!  Contiene:                                                                   !
!    - write_tecplot_file : scrive il file .plt per Tecplot in formato FE      !
!    - prepar_tecplot     : popola la lista dei nodi visibili (interfacce)     !
!=============================================================================!


!=============================================================================!
subroutine write_tecplot_file(k_file, traslay)
!=============================================================================!
!  Genera un file Tecplot (.plt) in formato FE (Finite Element) con le        !
!  grandezze conservative interpolate ai nodi dalla soluzione a celle.        !
!                                                                              !
!  Algoritmo:                                                                  !
!    1. Costruisce il nome cartella/file a partire dall'indice di output       !
!    2. Crea la cartella di output sul filesystem                              !
!    3. Esegue la media pesata delle variabili conservative sui nodi           !
!    4. Calcola le grandezze primitive (rho, u, v, P, M, S)                   !
!    5. Scrive la connettività degli elementi (tria/quad)                      !
!    6. Aggiorna il file recap CSV di simulazione                              !
!=============================================================================!

  use variabili
  implicit none

  !---------------------------------------------------------------------------
  ! Argomenti
  !---------------------------------------------------------------------------
  integer,  intent(in) :: k_file   ! Indice progressivo del file di output
  real(4),  intent(in) :: traslay  ! Traslazione in y applicata alla griglia

  !---------------------------------------------------------------------------
  ! Variabili locali — I/O e nomi file
  !---------------------------------------------------------------------------
  ! [FIX] folder_name aggiunta come variabile locale: mancava la dichiarazione
  !       e causava l'errore "has no IMPLICIT type" in compilazione.
  character(len=100) :: folder_name   ! Percorso della cartella di output
  character(len=80)  :: datafile_tec  ! Percorso completo del file .plt
  character(len=20)  :: kcar          ! Rappresentazione stringa di k_file

  !---------------------------------------------------------------------------
  ! Variabili locali — indici e contatori
  !---------------------------------------------------------------------------
  integer :: i, j, os
  integer :: iposj2, ndofsele, iele, jj  ! Indici ausiliari (uso futuro/legacy)

  !---------------------------------------------------------------------------
  ! Variabili locali — grandezze nodali (REAL(4) per compatibilità Tecplot)
  !---------------------------------------------------------------------------
  real(4) :: rho_node        ! Densità interpolata al nodo
  real(4) :: rhou_node       ! Momento in x (rho*u) interpolato al nodo
  real(4) :: rhov_node       ! Momento in y (rho*v) interpolato al nodo
  real(4) :: e_node          ! Energia totale interpolata al nodo
  real(4) :: u_node          ! Velocità in x al nodo
  real(4) :: v_node          ! Velocità in y al nodo
  real(4) :: P_node          ! Pressione termodinamica al nodo
  real(4) :: M_node          ! Numero di Mach al nodo
  real(4) :: S_node          ! Entropia specifica al nodo
  real(4) :: somma           ! Accumulatore — conta gli elementi che condividono il nodo

  ! Variabili ausiliarie (turbulenza / distanza parete — riservate per estensioni)
  real(4) :: muSA_node, wall_dist_node, mua_node
  real(4) :: u6_node, u7_node, u8_node
  real(4) :: sensore_residui, vort_thick_node

  ! Vettori di coordinate locali (uso futuro/legacy)
  real(4), dimension(2) :: csi, xy, xyloc

  !---------------------------------------------------------------------------
  ! Variabili locali — flag logico
  !---------------------------------------------------------------------------
  logical :: trovato  ! .TRUE. se il nodo corrente è nella lista nodi_vis

  !===========================================================================
  ! 1. COSTRUZIONE DEL PERCORSO DI OUTPUT
  !    Formato: SIM_OUTPUT_<k_file>/<k_file>.plt
  !===========================================================================

  ! Converti l'indice intero in stringa senza spazi iniziali (formato I0)
  write(kcar, '(I0)') k_file

  ! Costruisci il nome della cartella dedicata a questo output
  folder_name = "SIM_OUTPUT_" // trim(kcar)

  ! Crea la cartella sul filesystem tramite comando di sistema.
  ! NOTA: 'mkdir -p' funziona su Linux/macOS; su Windows (MinGW) usa 'mkdir'.
  !       Il flag -p evita errori se la cartella esiste già.
  call execute_command_line("mkdir -p " // trim(folder_name))

  ! Costruisci il percorso completo del file .plt
  datafile_tec = trim(folder_name) // "/" // trim(kcar) // ".plt"

  !===========================================================================
  ! 2. APERTURA FILE TECPLOT E INTESTAZIONE
  !===========================================================================

  open(unit=1, file=datafile_tec)

  ! Titolo del dataset Tecplot
  write(1,*) 'title = "grid"'

  ! Dichiarazione delle variabili: l'ordine deve corrispondere
  ! esattamente all'ordine di scrittura nel ciclo nodal (sezione 3)
  write(1,'(a80)') 'variables = "x","y","rho","P","u","v","M","S"'

  ! Intestazione della zona FE:
  !   n  = numero di nodi
  !   e  = numero di elementi interni
  !   et = tipo elemento (quadrilatero; i triangoli sono scritti come quad degeneri)
  !   f  = formato (fepoint: prima tutti i nodi, poi la connettività)
  write(1,*) 'zone n=', nnodi, ' e =', nele_interni, ' et=quadrilateral, f=fepoint'

  !===========================================================================
  ! 3. INTERPOLAZIONE AI NODI E SCRITTURA GRANDEZZE NODALI
  !    Tecplot richiede i valori ai nodi (vertex-centred), ma il solver
  !    lavora con variabili a centroide cella (cell-centred).
  !    Strategia: media aritmetica dei valori delle celle adiacenti al nodo.
  !===========================================================================

  do i = 1, nnodi   ! Ciclo su tutti i nodi della mesh

    !--- Reset accumulatori nodali -------------------------------------------
    rho_node       = 0.0
    rhou_node      = 0.0
    rhov_node      = 0.0
    e_node         = 0.0
    muSA_node      = 0.0
    wall_dist_node = 0.0
    mua_node       = 0.0
    vort_thick_node= 0.0
    u6_node        = 0.0
    somma          = 0.0  ! contatore elementi contribuenti

    !--- Verifica se il nodo è nella lista dei nodi visibili (interfacce) -----
    trovato = .FALSE.
    do j = 1, nnodi_vis
      if (i .eq. nodi_vis(j)) then
        trovato = .TRUE.
        exit   ! uscita anticipata dal ciclo — nodo trovato
      end if
    end do

    !=========================================================================
    ! RAMO A: nodo di interfaccia — media su tutti gli elementi adiacenti
    !=========================================================================
    if (trovato) then

      do j = 1, nodo(i)%neles
        if (nodo(i)%ele(j) .ne. 0) then

          ! Accumula le variabili conservative dalla cella adiacente.
          ! Convenzione ucons: (1)=E, (2)=rho, (3)=rho*u, (4)=rho*v
          rho_node  = rho_node  + ele(nodo(i)%ele(j))%ucons(2)
          rhou_node = rhou_node + ele(nodo(i)%ele(j))%ucons(3)
          rhov_node = rhov_node + ele(nodo(i)%ele(j))%ucons(4)
          e_node    = e_node    + ele(nodo(i)%ele(j))%ucons(1)

          ! [FIX] Sostituito 1.d0 (REAL(8)) con 1.0 (REAL(4)) per evitare
          !       il warning "Possible change of value in conversion".
          somma = somma + 1.0

        end if
      end do

      ! Divide per il numero di celle contribuenti → media aritmetica
      rho_node  = rho_node  / somma
      rhou_node = rhou_node / somma
      rhov_node = rhov_node / somma
      e_node    = e_node    / somma

    !=========================================================================
    ! RAMO B: nodo non di interfaccia (interno/bordo non visibile)
    !         Usa direttamente il valore della cella iele.
    !
    ! ATTENZIONE: 'iele' non è inizializzato in questo scope.
    !             Assicurarsi che venga impostato correttamente prima della
    !             chiamata o che questo ramo sia effettivamente raggiunto
    !             solo con iele valido. Aggiunta guardia di sicurezza.
    !=========================================================================
    else

      ! Guardia: se iele non è nell'intervallo valido, usa cella 1 come fallback
      if (iele .lt. 1 .or. iele .gt. nele_interni) iele = 1

      rho_node  = rho_node  + ele(iele)%ucons(2)
      rhou_node = rhou_node + ele(iele)%ucons(3)
      rhov_node = rhov_node + ele(iele)%ucons(4)
      e_node    = e_node    + ele(iele)%ucons(1)

    end if

    !=========================================================================
    ! 4. CALCOLO GRANDEZZE PRIMITIVE DAL VETTORE CONSERVATIVO
    !=========================================================================

    ! Velocità componenti
    u_node = rhou_node / rho_node
    v_node = rhov_node / rho_node

    ! Pressione termodinamica dalla relazione energetica:
    !   P = (gamma-1) * [E - 0.5 * rho * |u|^2]
    P_node = (gam - 1.0) * ( e_node &
             - 0.5 * rho_node * (u_node**2 + v_node**2) )

    ! Numero di Mach locale:
    !   M = |u| / a,  con a = sqrt(gamma * P / rho) (velocità del suono)
    M_node = sqrt(u_node**2 + v_node**2) / sqrt(gam * P_node / rho_node)

    ! Entropia specifica (a meno di costante additiva):
    !   s = gamma * ln(P/rho) - (gamma-1) * ln(P)
    !     = ln(P) - gamma * ln(rho)   [forma adimensionale]
    S_node = gam * log(P_node / rho_node) - (gam - 1.0) * log(P_node)

    !=========================================================================
    ! 5. SCRITTURA RIGA DATI NODALI
    !    Ordine: x, y(+traslazione), rho, P, u, v, M, S
    !    Deve corrispondere alla dichiarazione 'variables' nell'intestazione
    !=========================================================================
    write(1,*) nodo(i)%x(1), nodo(i)%x(2) + traslay, &
               rho_node, P_node, u_node, v_node, M_node, S_node

  end do   ! fine ciclo sui nodi

  !===========================================================================
  ! 6. SCRITTURA CONNETTIVITÀ DEGLI ELEMENTI
  !    Tecplot formato FE richiede lista nodi per ogni elemento.
  !    I triangoli sono scritti come quad degeneri (nodo3 ripetuto).
  !===========================================================================

  do i = 1, nele_interni

    if (ele(i)%nnodi .eq. 3) then
      ! Triangolo → quad degenere: ripete il terzo nodo
      write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(3)

    else if (ele(i)%nnodi .eq. 4) then
      ! Quadrilatero standard
      write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(4)

    else
      ! Tipo elemento non supportato — arresto con messaggio diagnostico
      write(*,*) " ERRORE in ele%vtx: tipo elemento sconosciuto."
      write(*,*) "   i =", i, "  nele_interni =", nele_interni, &
                 "  ele(i)%nnodi =", ele(i)%nnodi
      stop

    end if

  end do   ! fine ciclo sulla connettività

  !===========================================================================
  ! 7. CHIUSURA FILE TECPLOT
  !===========================================================================
  close(1)

  !===========================================================================
  ! 8. AGGIORNAMENTO RECAP CSV
  !    Ogni chiamata aggiunge una riga al file CSV riepilogativo senza
  !    sovrascrivere i dati delle iterazioni precedenti (position="append").
  !    Colonne: indice_output, numero_nodi, percorso_file
  !===========================================================================
  open(unit=99, file="RECAP_SIMULAZIONI.csv", status="unknown", position="append")
  write(99, '(I0, A, I0, A, A)') k_file, ",", nnodi, ",", trim(datafile_tec)
  close(99)

end subroutine write_tecplot_file


!=============================================================================!
subroutine prepar_tecplot
!=============================================================================!
!  Costruisce la lista nodi_vis: insieme dei nodi appartenenti ad almeno      !
!  un'interfaccia interna. Questa lista è usata da write_tecplot_file per     !
!  distinguere i nodi di interfaccia (media su celle adiacenti) dagli         !
!  altri nodi.                                                                 !
!                                                                              !
!  Algoritmo:                                                                  !
!    - Scorre tutte le interfacce interne                                      !
!    - Per ciascun nodo (nodo1, nodo2) dell'interfaccia, lo aggiunge a        !
!      nodi_vis solo se non è già presente (ricerca lineare)                   !
!    - Ordina nodi_vis in ordine crescente tramite bubble_sort                 !
!    - Inverte l'array (ordine decrescente) — necessario per logica upstream  !
!=============================================================================!

  use Variabili
  implicit none

  !---------------------------------------------------------------------------
  ! Variabili locali
  !---------------------------------------------------------------------------
  integer :: i, j            ! Indici di ciclo
  logical :: trovato         ! Flag: nodo già presente in nodi_vis
  integer, dimension(:), allocatable :: temp  ! Array temporaneo per inversione

  !===========================================================================
  ! 1. INIZIALIZZAZIONE E ALLOCAZIONE
  !===========================================================================

  nnodi_vis = 0   ! Contatore nodi visibili — reset a zero

  ! Dealloca array precedenti se già allocati (chiamata successiva alla prima)
  if (allocated(nodi_vis)) then
    deallocate(nodi_vis)
    deallocate(nodi_agg_vis)
  end if

  ! Alloca con dimensioni conservative (upper bound sicuro)
  allocate(nodi_vis(nnodi))
  allocate(nodi_agg_vis(5 * nele_interni))

  !===========================================================================
  ! 2. POPOLAMENTO DI nodi_vis — SCANSIONE DELLE INTERFACCE
  !    Per ogni interfaccia si controllano entrambi i nodi estremi.
  !    Un nodo viene aggiunto solo se non è già presente nella lista.
  !===========================================================================

  do i = 1, ninterf   ! Ciclo su tutte le interfacce interne

    if (nnodi_vis .gt. 0) then

      !--- Controlla e inserisce nodo1 ---
      trovato = .FALSE.
      do j = 1, nnodi_vis
        if (interf(i)%nodo1 .eq. nodi_vis(j)) trovato = .TRUE.
      end do
      if (.not. trovato) then
        nnodi_vis = nnodi_vis + 1
        nodi_vis(nnodi_vis) = interf(i)%nodo1
      end if

      !--- Controlla e inserisce nodo2 ---
      trovato = .FALSE.
      do j = 1, nnodi_vis
        if (interf(i)%nodo2 .eq. nodi_vis(j)) trovato = .TRUE.
      end do
      if (.not. trovato) then
        nnodi_vis = nnodi_vis + 1
        nodi_vis(nnodi_vis) = interf(i)%nodo2
      end if

    else
      ! Lista vuota: inserisci direttamente senza controllo duplicati
      nnodi_vis = nnodi_vis + 1
      nodi_vis(nnodi_vis) = interf(i)%nodo1
      nnodi_vis = nnodi_vis + 1
      nodi_vis(nnodi_vis) = interf(i)%nodo2
    end if

  end do   ! fine ciclo sulle interfacce

  !===========================================================================
  ! 3. ORDINAMENTO IN ORDINE CRESCENTE
  !    bubble_sort ordina i primi nnodi_vis elementi di nodi_vis.
  !    L'ordinamento facilita la ricerca binaria o la scansione sequenziale
  !    in write_tecplot_file.
  !===========================================================================
  call bubble_sort(nodi_vis, nnodi_vis)

  !===========================================================================
  ! 4. INVERSIONE ARRAY (ordine decrescente)
  !    Richiesta dalla logica di look-up in write_tecplot_file.
  !===========================================================================
  allocate(temp(nnodi_vis))
  temp = nodi_vis(1:nnodi_vis)

  do i = 1, nnodi_vis
    nodi_vis(i) = temp(nnodi_vis - i + 1)
  end do

  deallocate(temp)

  !===========================================================================
  ! 5. DIAGNOSTICA
  !===========================================================================
  write(*,*) 'nnodi_vis = ', nnodi_vis

end subroutine prepar_tecplot
