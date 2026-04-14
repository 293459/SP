program hello
    implicit none

    ! Vogliamo leggere da file i tre vertici del triangolo e
    ! chiamare due subroutine esterne per calcolare baricentro e area.
    real(4), dimension(3,2) :: xy
    integer :: i
    real(4), dimension(2) :: x0
    real(4) :: A

    ! Dichiaro il nome del file di input.
    character(200) :: nome_file
    nome_file = "punti.txt"

    ! Apertura, lettura e chiusura del file con le coordinate.
    open(unit=1, file=nome_file)

    do i=1,3
        read(1,*) xy(i,:)
    end do

    close(1)

    ! Chiamo le subroutine definite in file separati.
    call calcolo_baricentro(xy, x0)
    call calcolo_area(xy, A)

    print *, "Baricentro:", x0
    print *, "Area:", A

end program
