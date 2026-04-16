subroutine init
use variabili
implicit none
integer::i
real(4)::rho,u,v,p,t,alpha_init


	gam=1.4 !rapporto dei calori specifici

    ! variabili derivate dal rapporto dei calori specifici
    GA=gam/(gam-1.)
    GB=1./(gam-1.)
    GC=(gam+1.)/(gam-1.)
    GD=(gam-1.)/2.
    GE=(gam+1.)/2.
    GF=sqrt(gam)
    GG=2./(gam-1.)
    GH=(gam+1.)/(2.*gam)
    GI=(gam-1.)/(2.*gam)
    GJ=(gam-1.)/gam


    ! deve ciclare per tutti gli elementi interni
    do i =1, nele_interni
        ele(i)%P = ptotin/((1.+GD*machin**2)**GA)! settiamo pressione attraverso isentropica a partire da pressione totale può essere scritta così solo perchè si ha ptot = 1
        ele(i)%T = ttotin / (1. + GD * machin**2)
        ele(i)%a = sqrt(gam*ele(i)%T)

    if (mesh_file  == 'LS59.msh') then
    if (ele(i)%x0(1) <= 0) then
        alpha_init = 30*3.14/180
    elseif (ele(i)%x0(1) > 0 .and. ele(i)%x0(1) <= 1) then
        alpha_init = 30*3.14/180 - 90*3.14/180* ele(i)%x0(1)
    elseif (ele(i)%x0(1) > 1) then
        alpha_init = -60*3.14/180
    end if
    alpha = alpha_init
    end if


        ele(i)%u = machin*ele(i)%a*cos(alpha)
        ele(i)%v = machin*ele(i)%a*sin(alpha)
        ele(i)%S = gam * log(ele(i)%T) - (gam-1.)* log(ele(i)%P) ! entropia nulla per condizioni di monte S0=0

        ele(i)%ucons(2) = ele(i)%P/ele(i)%T
        ele(i)%ucons(1) = GB*ele(i)%P +0.5 *ele(i)%ucons(2)*(ele(i)%u**2 + ele(i)%v**2)
        ele(i)%ucons(3) = ele(i)%P/ele(i)%T * ele(i)%u
        ele(i)%ucons(4) = ele(i)%P/ele(i)%T * ele(i)%v

    end do
end subroutine
