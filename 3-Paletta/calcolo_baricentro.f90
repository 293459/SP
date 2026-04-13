subroutine calcolo_baricentro(coords, x_b)

    implicit none
    ! la funzione è tunata per il caso specifico ma manca di generalità perché 
    ! è specifica per il triangolo, se volessimo fare un quadrato dovremmo cambiare 
    ! la formula e quindi non sarebbe più una subroutine riutilizzabile

    ! se volessimo fare una subroutine più generale dovremmo scrivere una subroutine
    ! che prende in ingresso il numero di vertici e la matrice delle coordinate e poi
    ! fare un ciclo che somma tutte le righe della matrice e alla fine divide per il 
    ! numero di vertici, in questo modo avremmo una subroutine più generale che potrebbe 
    ! essere riutilizzata per qualsiasi poligono (ma qui semplifichiamo)
    real(4), dimension(3,2) :: coords ! 3 vertici e due coordinate x e y
    real(4), dimension(2) :: x_b ! baricentro (ha 2 coordinate)
    integer :: i


    x_b=0. ! inizializzo il baricentro a zero, così posso sommare le coordinate dei vertici e poi dividere per 3
    do i=1,3
        x_b= x_b+coords(i,:)   !prendo una riga la metto in xb e la sommo all'iterata successiva a quella dopo, cos� contemporaneamente x e y crescono
    end do
    x_b=x_b/3 ! alla fine divido per 3 perché ho 3 vertici, se avessi n vertici dovrei dividere per n

! quella inserita tra commenti di seguito è la versione più generale    
!   somma= 0.
!   x_b = 0.

!    do j=1,2

!        do i=1,3
!           somma(j)=somma(j)+coords(i,j)
!       end do

!    end do

!    x_b=somma/3;



end subroutine



