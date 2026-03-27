
program main
    implicit none


    real(4), dimension(3,2) :: xy !reale singola precisione, dimensione 3x2 e nome matrice
    character(200) :: nome_file !character mi tengo largo con 200 caratteri e do nome file
    integer :: i
    real(4), dimension(2) :: x0
    real(4) :: A

    !apriamo il file attraverso comando open

    nome_file = "punti.txt"
    open(unit=1, file=nome_file)

    !leggiamo le informazioni presenti nel file

    !read(1,*) xy(1,:)! primo input abbiamo unità di riferimento che in questo caso è 1, leggi prima riga e inseriscila come prima riga della nostra matrice
    !read(1, *) xy(2,:)
    !read(1, *) xy(3, :)

    !la scrittura sopra riportata è analoga a scrivere ciclo do

    do i=1,3
        read(1, *) xy(i, :) !leggi unità 1 e formato libero e sostituisci riga i-esima della matrice
    end do


    close(1)

    call calcolo_baricentro(xy, x0) !x0 baricentro dell'elemento
    write(*,*) "x0 = ", x0
    call calcolo_area(xy, A)
    write (*,*) "A = ", A


end program

!posso scrivere le subroutine in altri file


