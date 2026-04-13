subroutine calcolo_area(coords, A)

    implicit none

    real(4), dimension(3,2) :: coords ! 3 vertici e due coordinate x e y
    real (4):: A, p ! semiperimetro e area
    real(4), dimension(3) :: lat ! lati del triangolo
    integer :: i ! contatore

    ! ricordiamo che noi abbiamo le coordinate dei punti ma non la lunghezza dei lati già fornita

    lat = 0. ! inizializzo i lati a zero, così posso sommare le lunghezze dei lati e poi calcolare il semiperimetro e l'area
    A = 0. ! inizializzo l'area a zero, così posso calcolarla con la formula di Erone dopo aver calcolato i lati e il semiperimetro
    do i=1,3

        if (i /= 3) then ! se i è diverso da 3, calcolo la lunghezza del lato tra il vertice i e il vertice i+1

                lat(i) = sqrt((coords(i,1)-coords(i+1,1))**2+(coords(i, 2)-coords(i+1, 2))**2)

        else ! se i è uguale a 3, calcolo la lunghezza del lato tra il vertice 3 e il vertice 1
                lat(i) = sqrt((coords(i,1)-coords(1,1))**2+(coords(i, 2)-coords(1, 2))**2)
                
        ! metto questa if condition perché altrimenti quando i è uguale a 3, il programma cerca di accedere alla riga 4 della matrice coords, 
        ! che non esiste, e quindi dà un errore di out of bounds, invece con questa if condition, quando i è uguale a 3, il programma accede 
        ! alla riga 1 della matrice coords, che esiste, e quindi non dà errore

        end if

    end do

    p=lat(1)+lat(2)+lat(3) ! calcolo il perimetro del triangolo sommando i lati

    p=p/2.0 ! calcolo il semiperimetro del triangolo dividendo il perimetro per 2

    A=sqrt(p*(p-lat(1))*(p-lat(2))*(p-lat(3))) 
    ! calcolo l'area del triangolo con la formula di Erone, che è A = sqrt(p*(p-a)*(p-b)*(p-c)), dove p è il semiperimetro e a, b, c sono i lati del triangolo

end subroutine
