subroutine input !subroutine per lettura degli input
use Variabili

implicit none

	ndim=2 !numero dimensioni problema
	neqs=4 ! numero equazioni
   
    ! lettura del file di input, fare attenzione al numero di righe
    open(unit=1,file='input.txt')
    read(1,*)
    read(1,*)
    read(1,*) mesh_file
    read(1,*)
    read(1,*)
    read(1,*) kfinal
    read(1,*)
    read(1,*)
    read(1,*) kinf
    read(1,*)
    read(1,*)
    read(1,*) kout
    read(1,*)
    read(1,*)
    read(1,*) CFL
    close(1)

    ! lettura del file di inlet, fare attenzione al numero di righe
    open(unit=1,file='inlet.txt') ! in 2d ho 4 condizioni al contorno, devo dare informazione su inclinazione della corrente in ingresso
    read(1,*)
    read(1,*)
    read(1,*) ttotin
    read(1,*)
    read(1,*)
    read(1,*) ptotin
    read(1,*)
    read(1,*)
    read(1,*) alpha
    read(1,*)
    read(1,*)
    read(1,*) machin
    close(1)

    alpha=alpha*(4.*atan(1.0))/(180.) ! conversione da gradi a radianti

    ! lettura del file di outlet, fare attenzione al numero di righe
    open(unit=1,file='outlet.txt')
    read(1,*)
    read(1,*)
    read(1,*) pexit    ! se uscita subsonica � necessario fornire condizione al contorno
    close(1)






end subroutine




