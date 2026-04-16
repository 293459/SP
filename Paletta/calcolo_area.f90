subroutine calcolo_area(coords, A)

    implicit none

    real(4), intent(in), dimension(3,2) :: coords
    real(4), intent(out) :: A
    real(4) :: p
    real(4), dimension(3) :: lat
    integer :: i, j

    ! In ingresso abbiamo le coordinate dei tre vertici.
    ! Per usare la formula di Erone dobbiamo prima ricavare
    ! la lunghezza dei tre lati del triangolo.
    lat = 0.
    A = 0.

    do i = 1,3

        if (i /= 3) then
            j = i + 1
        else
            j = 1
        end if

        ! Per i primi due lati considero il vertice successivo.
        ! Per l'ultimo lato torno al primo vertice e chiudo il triangolo.
        lat(i) = sqrt((coords(i,1) - coords(j,1))**2 + (coords(i,2) - coords(j,2))**2)

    end do

    ! Il semiperimetro e la meta della somma dei tre lati.
    p = (lat(1) + lat(2) + lat(3)) / 2.0

    ! Applico la formula di Erone:
    ! A = sqrt(p * (p-a) * (p-b) * (p-c))
    ! dove a, b e c sono le tre lunghezze dei lati.
    A = sqrt(p * (p - lat(1)) * (p - lat(2)) * (p - lat(3)))

end subroutine
