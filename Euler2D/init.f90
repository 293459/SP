subroutine init
use variabili
implicit none
integer::i
real(4)::alpha_init

! Gas model constants for nondimensional Euler equations.
gam = 1.4
GA = gam/(gam-1.0)
GB = 1.0/(gam-1.0)
GC = (gam+1.0)/(gam-1.0)
GD = (gam-1.0)/2.0
GE = (gam+1.0)/2.0
GF = sqrt(gam)
GG = 2.0/(gam-1.0)
GH = (gam+1.0)/(2.0*gam)
GI = (gam-1.0)/(2.0*gam)
GJ = (gam-1.0)/gam

! Uniform initial condition from total inlet quantities.  The LS59 branch is
! kept for backward compatibility with the airfoil case in the reference data.
do i = 1, nele_interni
    ele(i)%P = ptotin / ((1.0 + GD * machin**2)**GA)
    ele(i)%T = ttotin / (1.0 + GD * machin**2)
    ele(i)%a = sqrt(gam * ele(i)%T)

    if (trim(mesh_file) == 'LS59.msh') then
        if (ele(i)%x0(1) <= 0.0) then
            alpha_init = 30.0 * 3.14 / 180.0
        else if (ele(i)%x0(1) > 0.0 .and. ele(i)%x0(1) <= 1.0) then
            alpha_init = 30.0 * 3.14 / 180.0 - 90.0 * 3.14 / 180.0 * ele(i)%x0(1)
        else
            alpha_init = -60.0 * 3.14 / 180.0
        end if
        alpha = alpha_init
    end if

    ele(i)%u = machin * ele(i)%a * cos(alpha)
    ele(i)%v = machin * ele(i)%a * sin(alpha)
    ele(i)%S = gam * log(ele(i)%T) - (gam-1.0) * log(ele(i)%P)

    ele(i)%ucons(2) = ele(i)%P / ele(i)%T
    ele(i)%ucons(1) = GB * ele(i)%P + 0.5 * ele(i)%ucons(2) * (ele(i)%u**2 + ele(i)%v**2)
    ele(i)%ucons(3) = ele(i)%ucons(2) * ele(i)%u
    ele(i)%ucons(4) = ele(i)%ucons(2) * ele(i)%v
end do
end subroutine
