module strutture
implicit none

! **********************************************************************************************************
type tipo_elemento                      ! tipo di elemento generico (può essere sia 2D che 1D)
    integer:: nnodi,tipo_ele            ! tipo_ele lo otteniamo ad esempio dai tag di gmsh tipo quadrilatero o triangolare
    integer,dimension(:),pointer::nodi  ! array di nodi associato all'elemento (la dimensione dipende dal tipo di elemento, 
                                        ! (4 per un quadrilatero, 3 per un triangolo, 2 per un elemento di bordo)
    integer::entity ! 0 all'interno, >0 sui bordi, ad esempio entity(1) potrebbe essere il muro ecc.
end type tipo_elemento
! **********************************************************************************************************


! ******************************************************************************************************
type tipo_nodo
   real(4),dimension(2):: x                     ! coordinate del nodo x(1) coordinata x mentre x(2) coordinata y
   integer:: nnghbrs,neles                      ! numero nodi vicini e di elementi che si affacciano su quel nodo
                                                ! la prima sigla sta per "number of neighbors" mentre la seconda sigla sta per "number of elements"
   integer,dimension(:),allocatable :: nghbr    ! list of neighbors  lista dei nodi vicini tag
   integer,dimension(:),allocatable :: ele      ! list of elements   vettore che contiene tag elementi che si affacciano su quel nodo
   end type tipo_nodo
! ******************************************************************************************************


! ******************************************************************************************************
type tipo_interfaccia
    integer:: e1, e2  !elementi associati(e1 è quello di riferimento per la normale uscente) - tag elementi associati a quella interfaccia
    integer::edge_e1,edge_e2 !Lato corrispondente degli elementi separati dall''interfaccia
    integer::nodo1,nodo2 !nodi agli estremi dell'interfaccia
    real(4),dimension(2) ::normal,x0 !normale e centro dell'interfaccia - vettore normale nx e ny e x0 baricentro
    real(4)::length !lunghezza dell'interfaccia
    integer::entity !0 all''interno, >0 sui bordi
    real(4),dimension(4)::f !flussi che attraversano l'interfaccia -- 4 elementi perchè in eulero 2d abbiamo 4 variabili conservative
    integer::int_perio ! condizioni di tipo periodico
end type tipo_interfaccia
! ******************************************************************************************************


! ******************************************************************************************************
type tipo_elemento_solido
    integer:: nnodi,tipo_ele,nlati                   ! numero nodi, tipo elemento e numero lati
    integer,dimension(:),allocatable::nodi           ! lista dei nodi dell'elemento
    integer,dimension(:,:),allocatable::edge         ! lista dei lati dell'elemento
    integer:: nnghbrs                                ! numero dei vicini dell'elemento (ad esempio 3 vicini)
    integer,   dimension(:), allocatable :: nghbr    ! lista dei vicini dell'elemento (ad esempio se abbiamo 3 vicini, allora nghbr(1)
                                                     ! è il tag del primo vicino, nghbr(2) è il tag del secondo vicino, ecc.)
    integer,dimension(:),allocatable::interfaces     ! lista delle interfacce dell'elemento (ad esempio se abbiamo 3 lati, allora interfaces(1)
                                                     ! è il tag dell'interfaccia associata al primo lato, interfaces(2) è il tag dell'interfaccia 
                                                     ! associata al secondo lato, ecc.)
    real(4)::area                                    ! area dell'elemento
    real(4),dimension(2)::x0                         ! coordinate baricentro dell'elemento
    real(4),dimension(4)::ucons                      ! vettore delle grandezze conservative: rho*e,rho,rho*u,rho*v
    real(4)::u,v,a,P,T,S                             !grandezze primitive
    real(4),dimension(4)::d_dt !vettore delle derivate temporali delle grandezze conservative
end type tipo_elemento_solido
! ******************************************************************************************************


!******************************************************************************************************
type tipo_bordo
    integer:: nnodi,tipo_ele ! numero nodi e tipo elemento (ad esempio 1 per un elemento di bordo lineare, 
                             ! 2 per un elemento di bordo quadratico, ecc.)
    integer,dimension(:),pointer::nodi ! array di nodi associato all'elemento di bordo (la dimensione dipende
                                       ! dal tipo di elemento, ad esempio 2 per un elemento di bordo lineare,
                                       ! 3 per un elemento di bordo quadratico, ecc.)
    integer::entity          ! 0 all'interno, >0 sui bordi, ad esempio entity(1) potrebbe essere il muro ecc.
end type tipo_bordo
!******************************************************************************************************


!******************************************************************************************************
type tipo_entity
    integer:: indx,tipo_ele ! indice dell'entità fisica e tipo di elemento associato all'entità fisica 
                            ! (ad esempio 1 per elementi di bordo lineari, 2 per elementi di bordo quadratici, ecc.)
    character(20)::name     ! nome dell'entità fisica, ad esempio "muro", "ingresso", "uscita", ecc.
    integer:: nmembers      ! numero di membri dell'entità fisica, ad esempio se abbiamo 10 elementi di bordo che rappresentano il muro, allora nmembers è 10
    integer,   dimension(:), allocatable :: members ! lista dei membri dell'entità fisica, ad esempio se abbiamo 10 elementi di bordo
                                                    ! che rappresentano il muro, allora members(1) è il tag del primo elemento di bordo,
                                                    ! members(2) è il tag del secondo elemento di bordo, ecc.
end type tipo_entity
!******************************************************************************************************





end module

