subroutine bubble_sort(x, n)
implicit none

integer, intent(in) :: n
integer, intent(inout) :: x(n)
integer :: i, j, jmax, temp

! Simple in-place ordering used by prepar_tecplot.  The historical routine
! sorts in descending order because the caller later reverses the vector to get
! the final order expected by the old Tecplot path.
jmax = n - 1

do i = 1, n - 1
    do j = 1, jmax
        if (x(j) > x(j + 1)) cycle
        temp = x(j)
        x(j) = x(j + 1)
        x(j + 1) = temp
    end do
    jmax = jmax - 1
end do
end subroutine bubble_sort
