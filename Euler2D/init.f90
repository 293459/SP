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
! la maggior parte di queste variabili non ha senso fisico è solo un modo per semplificare le formule
! e migliorare la leggibilità del codice, evitando di scrivere costantemente espressioni più complesse che coinvolgono gam.

! Uniform initial condition from total inlet quantities.  The LS59 branch is
! kept for backward compatibility with the airfoil case in the reference data.
do i = 1, nele_interni ! inizializza le condizioni iniziali per tutti gli elementi interni della mesh
    
    ! il file di inlet fornisce ttotin, ptotin, machin, alpha (in gradi) in forma adimensionale

    ! inizializzazione di tutte le variabili primitive adimensionali 
    ele(i)%P = ptotin / ((1.0 + GD * machin**2)**GA)           ! pressione statica in ingresso adimensioanle (inversa della definizione pressione totale)
    ele(i)%T = ttotin / (1.0 + GD * machin**2)                 ! temperatura statica in ingresso adimensionale (inversa della definizione temperatura totale)
    ele(i)%a = sqrt(gam * ele(i)%T)                            ! velocità del suono adimensionale (che mi serve per poi calcolare le velocità adimensionali in x e y)
    ele(i)%u = machin * ele(i)%a * cos(alpha)                  ! velocità adimensionale in x (ottenuta come componente del Mach e dalla velocità del suono)
    ele(i)%v = machin * ele(i)%a * sin(alpha)                  ! velocità adimensionale in y (ottenuta come componente del Mach e dalla velocità del suono)
    ele(i)%S = gam * log(ele(i)%T) - (gam-1.0) * log(ele(i)%P) ! entropia adimensionale, usata per monitorare la stabilità numerica e la qualità della soluzione.

    ! Inizializzazione delle variabili conservative a partire dalle variabili primitive. Le variabili conservative sono:
    ele(i)%ucons(2) = ele(i)%P / ele(i)%T                                                 ! densità, che è la variabile conservativa di massa
    ele(i)%ucons(1) = GB * ele(i)%P + 0.5 * ele(i)%ucons(2) * (ele(i)%u**2 + ele(i)%v**2) ! energia totale per unità di volume, che è la variabile conservativa di energia
    ele(i)%ucons(3) = ele(i)%ucons(2) * ele(i)%u                                          ! quantità di moto in x per unità di volume, che è la variabile conservativa di quantità di moto in x
    ele(i)%ucons(4) = ele(i)%ucons(2) * ele(i)%v                                          ! quantità di moto in y per unità di volume, che è la variabile conservativa di quantità di moto in y
    ! essendo eulero 2D non abbiamo la quantità di moto in z, quindi ucons(5) non viene usata.
    ! si è scelto di definirle in quest'ordine perché ucons(1), ucons(3) e ucons(4) sono più semplici da definire a partire da ucons(2) che a partire dalle variabili primitive.
    
    ! da capire ancora se questo blocco serve poiché non usato dal docente ad esercitazione
    if (trim(mesh_file) == 'LS59.msh') then !
        if (ele(i)%x0(1) <= 0.0) then !
            alpha_init = 30.0 * 3.14 / 180.0
        else if (ele(i)%x0(1) > 0.0 .and. ele(i)%x0(1) <= 1.0) then
            alpha_init = 30.0 * 3.14 / 180.0 - 90.0 * 3.14 / 180.0 * ele(i)%x0(1)
        else
            alpha_init = -60.0 * 3.14 / 180.0 ! 
        end if
        alpha = alpha_init
    end if

end do
end subroutine
