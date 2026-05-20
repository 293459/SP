subroutine compute_dt
use variabili
implicit none
real::dtloc,q, lambdamax
integer::i
! questa subroutine calcola il passo dt. Si assume inizialmente un valore di dt molto grande, poi si fa un ciclo su tutti gli elementi calcolando il valore massimo ammissibile di dt nell'elemento.
! se dt locale è minore di dt allora si pone dt =dt locale. Alla fine si riduce dt moltiplicandolo per CFL
dt = huge(1.) ! più grande numero reale che può rappresentare

! ricordiamo che l'obiettivo è calcolare un passo temporale che sia stabile per tutti gli elementi della mesh, quindi si deve considerare la velocità del fluido e la dimensione di ogni elemento. 
! Il passo temporale globale sarà limitato dal passo temporale più restrittivo tra tutti gli elementi.

do i = 1, nele_interni                     ! cerco per ogni elemento della mesh

    q = sqrt((ele(i)%u**2 + ele(i)%v**2))  ! velocità del fluido nell'elemento i, calcolata come la radice quadrata della somma dei quadrati delle componenti di velocità u e v. 
                                           ! Questa è una stima della velocità del fluido che contribuisce alla propagazione del segnale nell'elemento.
    lambdamax = q + ele(i)%a               ! velocità di propagazione massima del segnale (la più restrittiva)
    dtloc = sqrt (ele(i)%area) / lambdamax ! il passo temporale che ogni cella può gestire considerato il CFL globale, 
                                           ! la velocità di propagazione del segnale e la dimensione dell'elemento
                                           ! si noti che ho usato una dimensione caratteristica basata sulla radice quadrata dell'area dell'elemento,
                                           ! che è una stima della dimensione caratteristica dell'elemento in 2D.

    ! aggiorno il passo temporale globale scegliendo sempre il più piccolo se se ne trova uno minore. 
    if (dtloc.lt.dt) dt = dtloc            ! se il passo temporale locale e' minore del passo temporale globale, 
                                           ! allora si pone il passo temporale globale uguale al passo temporale locale
    

end do

dt = CFL * dt ! alla fine si riduce il passo temporale globale moltiplicandolo per il numero di Courant-Friedrichs-Lewy (CFL), che è un fattore di sicurezza per garantire la stabilità numerica della simulazione.
! ricordiamo che il CFL è definito altrove all'interno del file variabili
end subroutine
