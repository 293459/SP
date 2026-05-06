subroutine integ_time
use variabili
implicit none
integer::i

! Explicit Euler update of the conservative variables.
! The numerical scheme is unchanged: d_dt already contains the flux balance
! divided by cell area, and dt is provided by compute_dt.
do i = 1, nele_interni
    ele(i)%ucons(:) = ele(i)%ucons(:) + dt * ele(i)%d_dt(:)

    ele(i)%u = ele(i)%ucons(3) / ele(i)%ucons(2)
    ele(i)%v = ele(i)%ucons(4) / ele(i)%ucons(2)
    ele(i)%p = (gam - 1.0) * (ele(i)%ucons(1) - &
               0.5 * ele(i)%ucons(2) * (ele(i)%u**2 + ele(i)%v**2))
    ele(i)%T = ele(i)%P / ele(i)%ucons(2)
    ele(i)%a = sqrt(ele(i)%T * gam)
    ele(i)%S = gam * log(ele(i)%T) - (gam - 1.0) * log(ele(i)%P)
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
