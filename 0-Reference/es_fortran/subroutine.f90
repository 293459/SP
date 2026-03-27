

subroutine calcolo_baricentro(coords, x_b)

    implicit none

    real(4), dimension(3,2) :: coords
    real(4), dimension(2) :: x_b
    integer :: i


    x_b=0.
    do i=1,3
        x_b= x_b+coords(i,:)   !prendo una riga la metto in xb e la sommo all'iterata successiva a quella dopo, così contemporaneamente x e y crescono
    end do
    x_b=x_b/3

!   somma= 0.
!   x_b = 0.

!    do j=1,2

!        do i=1,3
!           somma(j)=somma(j)+coords(i,j)
!       end do

!    end do

!    x_b=somma/3;



end subroutine



