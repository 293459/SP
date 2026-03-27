subroutine compute_dt
use variabili
implicit none
real::dtloc,q, lambdamax
integer::i
! questa subroutine calcola il passo dt. Si assume inizialmente un valore di dt molto grande, poi si fa un ciclo su tutti gli elementi calcolando il valore massimo ammissibile di dt nell'elemento.
! se dt locale è minore di dt allora si pone dt =dt locale. Alla fine si riduce dt moltiplicandolo per CFL
dt = huge(1.) ! più grande numero reale che può rappresentare

do i = 1, nele_interni

    q = sqrt((ele(i)%u**2 + ele(i)%v**2))
    lambdamax = q + ele(i)%a
    dtloc = sqrt (ele(i)%area) / lambdamax
    if (dtloc.lt.dt) dt = dtloc

end do

dt = CFL * dt



end subroutine
