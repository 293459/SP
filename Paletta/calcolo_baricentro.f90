subroutine calcolo_baricentro(coords, x_b)

    implicit none

    ! Questa subroutine calcola il baricentro di un triangolo piano.
    ! Nel caso della esercitazione basta fare la media delle coordinate
    ! dei tre vertici.
    !
    ! La routine e pensata in modo semplice e specifico per il triangolo.
    ! Se in futuro si volesse gestire un poligono con N vertici,
    ! sarebbe sufficiente sommare tutte le coordinate e dividere per N.
    real(4), intent(in), dimension(3,2) :: coords
    real(4), intent(out), dimension(2) :: x_b
    integer :: i

    ! Inizializzo il baricentro a zero e accumulo i contributi
    ! dei tre vertici sia in x sia in y.
    x_b = 0.
    do i = 1,3
        x_b = x_b + coords(i,:)
    end do

    ! Divido per il numero di vertici per ottenere la media.
    x_b = x_b / 3.

end subroutine
