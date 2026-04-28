subroutine bubble(arr, n)
    implicit none
    integer, intent(in) :: n ! dimensione dell'array da ordinare
    integer, intent(inout) :: arr(n) ! array da ordinare, con intent(inout) perché vogliamo modificare l'array originale
    integer :: i, j, tmp ! variabili temporanee per il ciclo e per lo scambio degli elementi
    do i = 1, n-1 ! ciclo esterno che va da 1 a n-1, perché dopo n-1 passaggi l'array sarà ordinato
        do j = 1, n-i ! ciclo interno che va da 1 a n-i, perché dopo i passaggi gli ultimi i elementi sono già ordinati
            if (arr(j) > arr(j+1)) then ! se l'elemento corrente è maggiore del successivo, allora li scambiamo
                tmp = arr(j); arr(j) = arr(j+1); arr(j+1) = tmp ! scambio degli elementi usando una variabile temporanea
            end if
        end do
    end do
end subroutine