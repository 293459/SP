subroutine integ_time
use variabili
implicit none
integer::i

! Explicit Euler update of the conservative variables.
! The numerical scheme is unchanged: d_dt already contains the flux balance
! divided by cell area, and dt is provided by compute_dt.
do i = 1, nele_interni ! loop su tutti gli elementi interni   

   ! aggiorno le variabili conservative con il termine di flusso diviso area moltiplicato per dt
    ele(i)%ucons(:) = ele(i)%ucons(:) + dt * ele(i)%d_dt(:)       

    ! aggiorno le variabili primitive per il calcolo di grandezze come pressione, temperatura, velocità, entropia
    ele(i)%u = ele(i)%ucons(3) / ele(i)%ucons(2)                   ! ele(i)%ucons(3) è la quantità di moto in x, ele(i)%ucons(2) è la densità, quindi u è la velocità in x
    ele(i)%v = ele(i)%ucons(4) / ele(i)%ucons(2)                   ! ele(i)%ucons(4) è la quantità di moto in y, ele(i)%ucons(2) è la densità, quindi v è la velocità in y
    ele(i)%p = (gam - 1.0) * (ele(i)%ucons(1) - &                  ! ele(i)%ucons(1) è la densità di energia totale, ele(i)%ucons(2) è la densità, ele(i)%u e ele(i)%v sono le velocità in x e y, quindi questa è la formula per calcolare la pressione a partire dalle variabili conservative
               0.5 * ele(i)%ucons(2) * (ele(i)%u**2 + ele(i)%v**2))! quindi questa è la formula per calcolare la pressione a partire dalle variabili conservative
    ele(i)%T = ele(i)%P / ele(i)%ucons(2)                          ! P = rho T  ---> gas perfetti adimensionale, quindi questa è la formula per calcolare la temperatura a partire dalla pressione e dalla densità
    ele(i)%a = sqrt(ele(i)%T * gam)                                ! a = sqrt(gamma * R * T) con R adimensionale uguale a 1, quindi questa è la formula per calcolare la velocità del suono a partire dalla temperatura
    ele(i)%S = gam * log(ele(i)%T) - (gam - 1.0) * log(ele(i)%P)   ! questa è la formula per calcolare l'entropia a partire dalla temperatura e dalla pressione, con la costante di gas perfetto adimensionale uguale a 1
end do
end subroutine integ_time


subroutine compute_norm_residuals
use variabili
implicit none
integer::i
real(4)::areatot

20 format ('Norm-2 residuals = ',e10.3,4x,e10.3,4x,e10.3,4x,e10.3,4x)

areatot = 0.0
norm2_residuals = 0.0

do i = 1, nele_interni
    norm2_residuals(:) = norm2_residuals(:) + ele(i)%d_dt**2 * ele(i)%area
    areatot = areatot + ele(i)%area
end do

norm2_residuals(:) = sqrt(norm2_residuals(:) / areatot)
write(*,20) norm2_residuals
end subroutine compute_norm_residuals


subroutine compute_norm_entropy
use variabili
implicit none
integer::i
real(4)::areatot, norm2_entropy
character(len=300)::norms_file

norm2_entropy = 0.0
areatot = 0.0

do i = 1, nele_interni
    norm2_entropy = norm2_entropy + ele(i)%S**2 * ele(i)%area
    areatot = areatot + ele(i)%area
end do

norm2_entropy = sqrt(norm2_entropy / areatot)
write(*,*) 'Norm2_entropy = ', norm2_entropy

! [MODIFICA 2026-05-06] norms.txt e' scritto nella cartella della singola
! simulazione, cosi' piu' processi paralleli non condividono lo stesso file.
call build_path(output_dir, 'norms.txt', norms_file)
open(unit=1, file=trim(norms_file), status='replace', action='write')
write(1,*) norm2_residuals, norm2_entropy
close(1)
end subroutine compute_norm_entropy
