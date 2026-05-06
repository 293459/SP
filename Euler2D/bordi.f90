!===============================================================================
! Boundary fluxes and wall diagnostics.
!
! Entities used by the Bump meshes:
!   99 -> inviscid solid wall
!    2 -> subsonic inlet
!    3 -> subsonic outlet
!
! The numerical formulas are the historical ones.  The 2026-05-06 maintenance
! pass only removed unused local variables and made output files local to
! output_dir, so concurrent simulations do not write the same wall_data.txt.
!===============================================================================

subroutine save_wall_data
    use Variabili
    implicit none

    integer :: i
    character(len=300) :: wall_file

    call build_path(output_dir, 'wall_data.txt', wall_file)
    open(unit=1, file=trim(wall_file), status='replace', action='write')

    do i = 1, ninterf
        if (interf(i)%entity == 99) then
            write(1,*) interf(i)%x0, ele(interf(i)%e1)%P
        end if
    end do

    close(1)
end subroutine save_wall_data


subroutine compute_boundary_flux(i)
    use Variabili
    implicit none

    integer, intent(in) :: i

    if (interf(i)%entity == 99) then
        call swi(i)
    else if (interf(i)%entity == 2) then
        call insub(i)
    else if (interf(i)%entity == 3) then
        call outsub(i)
    else
        write(*,*) 'ERRORE: condizione al contorno non gestita.'
        write(*,*) 'Interfaccia = ', i, ' entity = ', interf(i)%entity
        stop 40
    end if
end subroutine compute_boundary_flux


subroutine swi(i)
    use Variabili
    implicit none

    integer, intent(in) :: i
    real(8) :: u1a, u2a, u3a, u5a
    real(8) :: ud, vd, pd, ad, hd
    real(8) :: utilde, ac, pc

    ! Stato interno adiacente alla parete.  Nel vettore ucons storico:
    !   1 = energia totale, 2 = rho, 3 = rho*u, 4 = rho*v.
    u1a = ele(interf(i)%e1)%ucons(2)
    u2a = ele(interf(i)%e1)%ucons(3)
    u3a = ele(interf(i)%e1)%ucons(4)
    u5a = ele(interf(i)%e1)%ucons(1)

    ud = u2a / u1a
    vd = u3a / u1a
    pd = (gam - 1.0) * (u5a - 0.5 * u1a * (ud**2 + vd**2))
    hd = ga * pd / u1a
    ad = sqrt((gam - 1.0) * hd)

    ! Mezzo problema di Riemann a parete inviscida: velocita normale riflessa
    ! e pressione corretta sulla parete.
    utilde = -(ud * interf(i)%normal(1) + vd * interf(i)%normal(2))
    ac = ad - utilde * gd
    pc = pd * (ac / ad)**(1.0 / gi)

    interf(i)%f(1) = 0.0
    interf(i)%f(2) = 0.0
    interf(i)%f(3) = pc * interf(i)%normal(1)
    interf(i)%f(4) = pc * interf(i)%normal(2)
end subroutine swi


subroutine insub(i)
    use Variabili
    implicit none

    integer, intent(in) :: i
    real(8) :: u1a, u2a, u3a, u5a
    real(8) :: ud, vd, pd, ad, hd
    real(8) :: utilde, r1b, td, rhod
    real(8) :: tanalpha2, prova, tt, pt
    real(8) :: f2, f3, f2dum, f3dum

    tt = ttotin
    pt = ptotin

    u1a = ele(interf(i)%e1)%ucons(2)
    u2a = ele(interf(i)%e1)%ucons(3)
    u3a = ele(interf(i)%e1)%ucons(4)
    u5a = ele(interf(i)%e1)%ucons(1)

    ud = u2a / u1a
    vd = u3a / u1a
    pd = (gam - 1.0) * (u5a - 0.5 * u1a * (ud**2 + vd**2))
    hd = ga * pd / u1a
    ad = sqrt((gam - 1.0) * hd)

    utilde = -(ud * interf(i)%normal(1) + vd * interf(i)%normal(2))
    prova = atan(interf(i)%normal(2) / interf(i)%normal(1))
    if (prova > 0.0) then
        tanalpha2 = tan(prova - alpha)
    else
        tanalpha2 = tan(abs(prova) + alpha)
    end if

    ! Ricostruzione subsonica di ingresso con grandezze totali assegnate.
    r1b = gg * ad - utilde
    ad = (2.0 * r1b * (1.0 + tanalpha2**2) + &
          sqrt(4.0 * r1b**2 * (1.0 + tanalpha2**2)**2 - &
          4.0 * (1.0 + gg * (1.0 + tanalpha2**2)) * &
          (gd * (1.0 + tanalpha2**2) * r1b**2 - gam * tt))) / &
         (2.0 * (1.0 + gg * (1.0 + tanalpha2**2)))
    ud = gg * ad - r1b
    td = ad**2 / gam
    pd = pt * (td / tt)**ga
    rhod = pd / td

    if (prova > 0.0) then
        vd = -ud * tanalpha2
    else
        vd = ud * tanalpha2
    end if

    f2dum = pd + rhod * ud**2
    f3dum = rhod * ud * vd

    f2 = -f2dum * interf(i)%normal(1) + f3dum * interf(i)%normal(2)
    f3 = -f2dum * interf(i)%normal(2) - f3dum * interf(i)%normal(1)

    interf(i)%f(1) = -ud * (pd + pd / (gam - 1.0) + 0.5 * rhod * (ud**2 + vd**2))
    interf(i)%f(2) = -rhod * ud
    interf(i)%f(3) = -f2
    interf(i)%f(4) = -f3
end subroutine insub


subroutine outsub(i)
    use Variabili
    implicit none

    integer, intent(in) :: i
    real(8) :: u1a, u2a, u3a, u5a
    real(8) :: ud, vd, pd, ad, hd, td, sd, rhod
    real(8) :: utilde, vtilde
    real(8) :: f1, f2, f3, f4, f2dum, f3dum
    real(8) :: r2dum, pc, sc, tc, ac, uc, vc, rhoc, ec

    u1a = ele(interf(i)%e1)%ucons(2)
    u2a = ele(interf(i)%e1)%ucons(3)
    u3a = ele(interf(i)%e1)%ucons(4)
    u5a = ele(interf(i)%e1)%ucons(1)

    ud = u2a / u1a
    vd = u3a / u1a
    pd = (gam - 1.0) * (u5a - 0.5 * u1a * (ud**2 + vd**2))
    hd = ga * pd / u1a
    ad = sqrt((gam - 1.0) * hd)
    td = pd / u1a
    sd = gam * log(td) - (gam - 1.0) * log(pd)
    rhod = pd / td

    utilde = ud * interf(i)%normal(1) + vd * interf(i)%normal(2)
    vtilde = -ud * interf(i)%normal(2) + vd * interf(i)%normal(1)

    if (utilde > ad) then
        ! Uscita localmente supersonica: tutte le caratteristiche escono.
        f1 = rhod * utilde
        f2dum = pd + rhod * utilde**2
        f3dum = rhod * utilde * vtilde
        f4 = utilde * (pd + pd / (gam - 1.0) + 0.5 * rhod * (utilde**2 + vtilde**2))
    else
        ! Uscita subsonica: pressione statica imposta da outlet.txt.
        r2dum = ad / gd + utilde
        pc = pexit
        sc = sd
        tc = exp((sc + (gam - 1.0) * log(pc)) / gam)
        ac = sqrt(gam * tc)
        uc = r2dum - 2.0 * ac / (gam - 1.0)
        vc = vtilde
        rhoc = pc / tc
        ec = rhoc * (tc * gb + 0.5 * (uc**2 + vc**2))

        f1 = rhoc * uc
        f2dum = pc + f1 * uc
        f3dum = f1 * vc
        f4 = uc * (ec + pc)
    end if

    f2 = f2dum * interf(i)%normal(1) - f3dum * interf(i)%normal(2)
    f3 = f2dum * interf(i)%normal(2) + f3dum * interf(i)%normal(1)

    interf(i)%f(1) = f4
    interf(i)%f(2) = f1
    interf(i)%f(3) = f2
    interf(i)%f(4) = f3
end subroutine outsub
