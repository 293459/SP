subroutine integ_time
use variabili
implicit none
integer::i,j

!In questa subroutine si aggiornano le grandezze conservative (ele(i)%ucons(:)) facendo un passo temporale con il metodo di Eulero esplicito
! e poi, dopo aver aggiornato le grandezze conservative, si ricalcolano le grandezze primitive (ele(i)%u,ele(i)%v,ele(i)%a,ele(i)%p,ele(i)%T)in funzione della conservative aggiornate

do i =1,nele_interni !aggiornare variabili per tutti gli elementi interni

ele(i)%ucons(:) = ele(i)%ucons(:) + dt*ele(i)%d_dt(:) !aggiorniamo le variabili conservative d_dt contiene già il rapporto lunghezza area



ele(i)%u = ele(i)%ucons(3)/ele(i)%ucons(2)
ele(i)%v = ele(i)%ucons(4)/ele(i)%ucons(2)
ele(i)%p = (gam-1)*(ele(i)%ucons(1)-0.5*ele(i)%ucons(2)*(ele(i)%u**2+ele(i)%v**2))
ele(i)%T = ele(i)%P/ele(i)%ucons(2)
ele(i)%a = sqrt(ele(i)%T * gam)
ele(i)%S = gam * log(ele(i)%T) - (gam-1.)* log(ele(i)%P)

end do
end subroutine


subroutine compute_norm_residuals
use variabili
implicit none
integer::i
real(4)::areatot!, somma_entropy, norm2_entropy
!real(4), dimension(4):: somma

20      format ('Norm-2 residuals = ',e10.3,4x,e10.3,4x,e10.3,4x,e 10.3,4x)

! In questa subroutine si calcola la norma 2 dei residui andando a integrare sull'intero dominio di calcolo

areatot = 0.
norm2_residuals = 0.
!somma(:) = 0.
!somma_entropy =0.

do i = 1, nele_interni

    !somma(:)= somma(:)+ele(i)%d_dt**2* ele(i)%area
    norm2_residuals(:) = norm2_residuals(:) + ele(i)%d_dt**2* ele(i)%area
    areatot = areatot + ele(i)%area
    !somma_entropy = somma_entropy + ele(i)%S**2*ele(i)%area


end do

!norm2_residuals(:) = sqrt(somma(:)/areatot)
norm2_residuals(:) = sqrt(norm2_residuals(:)/areatot)
!norm2_entropy = sqrt(somma_entropy/areatot)


write(*,20) norm2_residuals
!write(*, *) 'Norm2_entropy = ' ,norm2_entropy

end subroutine

subroutine compute_norm_entropy
use variabili
implicit none
integer::i
real(4):: areatot, norm2_entropy

norm2_entropy = 0.
areatot =0.

do i =1, nele_interni

norm2_entropy = norm2_entropy + ele(i)%S**2 * ele(i)%area
areatot = areatot + ele(i)%area

end do

norm2_entropy = sqrt(norm2_entropy/areatot)
write(*, *) 'Norm2_entropy = ' ,norm2_entropy

!if ((norm2_residuals(2).lt.2E-4).and.(k.gt.1000)) then

    open (unit = 1, file = 'norms.txt')
    write(1, *) norm2_residuals, norm2_entropy
    close(1)

!end if


end subroutine
