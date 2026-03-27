subroutine calcolo_area(coords, A)

    implicit none

    real(4), dimension(3,2) :: coords
    real (4):: A, p
    real(4), dimension(3) :: lat
    integer :: i

    lat = 0.
    A = 0.
    do i=1,3

        if (i /= 3) then

                lat(i) = sqrt((coords(i,1)-coords(i+1,1))**2+(coords(i, 2)-coords(i+1, 2))**2)

        else
                lat(i) = sqrt((coords(i,1)-coords(1,1))**2+(coords(i, 2)-coords(1, 2))**2)


        end if

    end do

    p=lat(1)+lat(2)+lat(3)

    p=p/2.0


    A=sqrt(p*(p-lat(1))*(p-lat(2))*(p-lat(3)))




end subroutine
