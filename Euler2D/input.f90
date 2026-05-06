subroutine input
use Variabili

implicit none

    character(len=300) :: inlet_file
    character(len=300) :: outlet_file
    character(len=300) :: mesh_path
    integer :: ios

    ndim=2 ! Numero di dimensioni del problema.
    neqs=4 ! Numero di equazioni conservative di Eulero 2D.

    ! Il file di input mantiene la struttura storica:
    ! riga descrittiva, riga con il valore, separatori, e cosi' via.
    ! La differenza e' che ora il nome del file viene da input_file,
    ! impostato da setup_runtime_from_args. Se non vengono passati argomenti
    ! da riga di comando, input_file resta "input.txt".
    open(unit=1,file=trim(input_file),status='old',action='read',iostat=ios)
    if (ios /= 0) then
        write(*,*) 'ERRORE: impossibile aprire il file input: ', trim(input_file)
        stop 20
    end if
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

    ! Se la mesh nel file di input e' relativa, la interpretiamo rispetto alla
    ! cartella dell'input. In questo modo input_01.txt, input_02.txt, ...
    ! possono vivere in cartelle diverse senza cambiare la struttura interna.
    call build_path(input_dir, mesh_file, mesh_path)
    mesh_file = mesh_path

    ! inlet.txt e outlet.txt sono configurazioni della stessa simulazione:
    ! vengono cercati accanto all'input file, non nella directory corrente.
    call build_path(input_dir, 'inlet.txt', inlet_file)
    call build_path(input_dir, 'outlet.txt', outlet_file)

    open(unit=1,file=trim(inlet_file),status='old',action='read',iostat=ios)
    if (ios /= 0) then
        write(*,*) 'ERRORE: impossibile aprire il file inlet: ', trim(inlet_file)
        stop 21
    end if
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

    alpha=alpha*(4.*atan(1.0))/(180.) ! Conversione da gradi a radianti.

    open(unit=1,file=trim(outlet_file),status='old',action='read',iostat=ios)
    if (ios /= 0) then
        write(*,*) 'ERRORE: impossibile aprire il file outlet: ', trim(outlet_file)
        stop 22
    end if
    read(1,*)
    read(1,*)
    read(1,*) pexit
    close(1)

end subroutine
