program hello
    implicit none

    !print *, "Hello World!"
    ! vogliamo leggere da file dei punti e chiamare una subroutine per il calcolo del baricentro ed area per un triangolo
    ! prossima volta lo faremo per un quadrato cosa penso ci serva per discorsi legati alla mesh


    ! INPUT matrice di numeri reali
    real(4),dimension(3,2)::xy ! sto usando singola precisione, creo una matrice 3x2 e nome matrice
    integer::i
    real(4),dimension(2)::x0 ! baricentro
    real(4),dimension(1)::A ! area

    ! dichiarazione stringa nome del file di input
    character(200)::nome_file !character mi tengo largo con 200 caratteri e do nome file
    nome_file = "punti.txt"


    ! Apertura e chiusura file
    open(unit=1, file= nome_file)

    do i=1,3
        read(1,*) xy(i,:)
    end do

    close(1)

    ! Ora chiamo le subroutines definite altrove per calcolare area e baricentro
    call calcolo_baricentro(xy,x0) ! semplice media ponderata
    call calcolo_area(xy,A)


end program

