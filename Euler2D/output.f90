!=============================================================================!
!  output.f90 - Tecplot output and per-run simulation recap.
!
!  This file does not change the Euler equations or the explicit time scheme.
!  It only controls how solver data are exported.  The important runtime rule is
!  that every simulation writes below output_dir, so batch or parallel runs do
!  not share SIM_OUTPUT_0, wall_data.txt, norms.txt or recap files.
!=============================================================================!

subroutine write_tecplot_file(k_file, traslay)
  use variabili
  implicit none

  integer, intent(in) :: k_file
  real(4), intent(in) :: traslay

  character(len=20)  :: kcar
  character(len=300) :: folder_name
  character(len=300) :: datafile_tec
  character(len=300) :: recap_file
  integer :: i, j, element_id, contributors
  logical :: recap_exists

  real(4) :: rho_node
  real(4) :: rhou_node
  real(4) :: rhov_node
  real(4) :: e_node
  real(4) :: u_node
  real(4) :: v_node
  real(4) :: p_node
  real(4) :: m_node
  real(4) :: s_node

  ! Output Tecplot storico: SIM_OUTPUT_<indice>/<indice>.plt.
  ! La differenza e' che SIM_OUTPUT_<indice> viene creato dentro output_dir.
  write(kcar, '(I0)') k_file
  call build_path(output_dir, 'SIM_OUTPUT_' // trim(kcar), folder_name)
  call ensure_directory(folder_name)
  call build_path(folder_name, trim(kcar) // '.plt', datafile_tec)

  open(unit=1, file=trim(datafile_tec), status='replace', action='write')

  write(1,*) 'title = "grid"'
  write(1,'(a80)') 'variables = "x","y","rho","P","u","v","M","S"'
  write(1,*) 'zone n=', nnodi, ' e =', nele_interni, ' et=quadrilateral, f=fepoint'

  do i = 1, nnodi
    rho_node = 0.0
    rhou_node = 0.0
    rhov_node = 0.0
    e_node = 0.0
    contributors = 0

    ! The solver stores conservative variables per cell.  Tecplot FEPOINT wants
    ! nodal values, so each node receives the arithmetic average of all internal
    ! cells that use it.  This replaces the old fallback based on an
    ! uninitialised local variable "iele", which could read arbitrary memory.
    do j = 1, nodo(i)%neles
      element_id = nodo(i)%ele(j)
      if (element_id >= 1 .and. element_id <= nele_interni) then
        rho_node  = rho_node  + ele(element_id)%ucons(2)
        rhou_node = rhou_node + ele(element_id)%ucons(3)
        rhov_node = rhov_node + ele(element_id)%ucons(4)
        e_node    = e_node    + ele(element_id)%ucons(1)
        contributors = contributors + 1
      end if
    end do

    if (contributors <= 0) then
      write(*,*) 'ERRORE output: nessun elemento interno associato al nodo ', i
      stop 30
    end if

    rho_node  = rho_node  / real(contributors, kind=4)
    rhou_node = rhou_node / real(contributors, kind=4)
    rhov_node = rhov_node / real(contributors, kind=4)
    e_node    = e_node    / real(contributors, kind=4)

    u_node = rhou_node / rho_node
    v_node = rhov_node / rho_node
    p_node = (gam - 1.0) * (e_node - 0.5 * rho_node * (u_node**2 + v_node**2))

    if (rho_node > 0.0 .and. p_node > 0.0) then
      m_node = sqrt(u_node**2 + v_node**2) / sqrt(gam * p_node / rho_node)
      s_node = gam * log(p_node / rho_node) - (gam - 1.0) * log(p_node)
    else
      ! Negative rho/P means the numerical state is not physical.  We still
      ! write the conservative-derived fields for diagnosis and keep M,S finite.
      m_node = 0.0
      s_node = 0.0
    end if

    write(1,*) nodo(i)%x(1), nodo(i)%x(2) + traslay, &
               rho_node, p_node, u_node, v_node, m_node, s_node
  end do

  do i = 1, nele_interni
    if (ele(i)%nnodi == 3) then
      write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(3)
    else if (ele(i)%nnodi == 4) then
      write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(4)
    else
      write(*,*) 'ERRORE output: elemento con numero nodi non supportato.'
      write(*,*) 'Elemento = ', i, ' nnodi = ', ele(i)%nnodi
      stop 31
    end if
  end do

  close(1)

  ! Recap CSV locale della simulazione.  Il recap globale Bump/RECAP_SIMULAZIONI
  ! viene gestito dallo script batch, cosi' piu' processi non scrivono insieme
  ! nello stesso file.
  call build_path(output_dir, 'RECAP_OUTPUT.csv', recap_file)
  inquire(file=trim(recap_file), exist=recap_exists)
  open(unit=99, file=trim(recap_file), status='unknown', position='append', action='write')
  if (.not. recap_exists) write(99,'(A)') 'k_file,nnodi,tecplot_file'
  write(99, '(I0, A, I0, A, A)') k_file, ',', nnodi, ',', trim(datafile_tec)
  close(99)

  call append_simulation_output_row(k_file, datafile_tec)
end subroutine write_tecplot_file


subroutine write_simulation_recap_header
  use Variabili
  implicit none

  character(len=300) :: recap_file
  character(len=8) :: date_string
  character(len=10) :: time_string
  real(4) :: lc

  call build_path(output_dir, 'RECUP_SIMULAZIONE.txt', recap_file)
  call date_and_time(date=date_string, time=time_string)

  open(unit=98, file=trim(recap_file), status='replace', action='write')
  write(98,'(A)') 'RECUP_SIMULAZIONE - Euler2D'
  write(98,'(A)') 'Modifica 2026-05-06: recap locale per run batch/paralleli.'
  write(98,'(A,A)') 'Data run: ', date_string
  write(98,'(A,A)') 'Ora run: ', time_string
  write(98,'(A,A)') 'Input file: ', trim(input_file)
  write(98,'(A,A)') 'Mesh file: ', trim(mesh_file)
  write(98,'(A,A)') 'Output dir: ', trim(output_dir)
  write(98,'(A,I0)') 'KFINAL: ', kfinal
  write(98,'(A,I0)') 'KINF: ', kinf
  write(98,'(A,I0)') 'KOUT: ', kout
  write(98,'(A,F12.6)') 'CFL: ', CFL
  write(98,*)
  write(98,'(A,I0)') 'Numero elementi totali: ', nele
  write(98,'(A,I0)') 'Numero elementi interni: ', nele_interni
  write(98,'(A,I0)') 'Numero elementi di bordo: ', nele_bordi
  write(98,'(A,I0)') 'Numero interfacce: ', ninterf
  write(98,'(A,I0)') 'Numero nodi: ', nnodi
  write(98,'(A,I0)') 'Numero nodi visibili Tecplot: ', nnodi_vis
  write(98,'(A,I0)') 'Numero entita fisiche: ', nentity
  write(98,*)

  if (nele_interni >= 10) then
    write(98,'(A,2ES16.8)') 'Elemento 10 - x0: ', ele(10)%x0
    write(98,'(A,ES16.8)') 'Elemento 10 - area: ', ele(10)%area
    write(*,*) 'ele(10)%x0 = ', ele(10)%x0
    write(*,*) 'ele(10)%area = ', ele(10)%area
  else
    write(98,'(A)') 'Elemento 10 non disponibile: mesh con meno di 10 elementi interni.'
  end if

  if (ninterf >= 100) then
    write(98,'(A,ES16.8)') 'Interfaccia 100 - lunghezza: ', interf(100)%length
    write(98,'(A,2ES16.8)') 'Interfaccia 100 - normale: ', interf(100)%normal
    write(*,*) 'interf(100)%length = ', interf(100)%length
    write(*,*) 'interf(100)%normal = ', interf(100)%normal
  else
    write(98,'(A)') 'Interfaccia 100 non disponibile: mesh con meno di 100 interfacce.'
  end if

  if (nele_interni >= 1 .and. ele(1)%nnodi >= 2) then
    lc = nodo(ele(1)%nodi(2))%x(1) - nodo(ele(1)%nodi(1))%x(1)
    write(98,'(A,ES16.8)') 'lc diagnostico elemento 1: ', lc
    write(*,*) 'lc = ', lc
  end if

  write(98,*)
  write(98,'(A)') 'Output Tecplot prodotti:'
  close(98)
end subroutine write_simulation_recap_header


subroutine append_simulation_output_row(k_file, datafile_tec)
  use Variabili
  implicit none

  integer, intent(in) :: k_file
  character(len=*), intent(in) :: datafile_tec
  character(len=300) :: recap_file

  call build_path(output_dir, 'RECUP_SIMULAZIONE.txt', recap_file)
  open(unit=98, file=trim(recap_file), status='unknown', position='append', action='write')
  write(98,'(A,I0,A,A)') '  k=', k_file, ' -> ', trim(datafile_tec)
  close(98)
end subroutine append_simulation_output_row


subroutine append_simulation_recap_footer
  use Variabili
  implicit none

  character(len=300) :: recap_file
  character(len=8) :: date_string
  character(len=10) :: time_string
  integer :: last_k

  call build_path(output_dir, 'RECUP_SIMULAZIONE.txt', recap_file)
  call date_and_time(date=date_string, time=time_string)
  last_k = min(k, kfinal)

  open(unit=98, file=trim(recap_file), status='unknown', position='append', action='write')
  write(98,*)
  write(98,'(A,I0)') 'Ultima iterazione completata: ', last_k
  write(98,'(A,ES16.8)') 'Tempo fisico finale: ', time
  write(98,'(A,4ES16.8)') 'Norma L2 residui finale: ', norm2_residuals
  write(98,'(A,A,A,A)') 'Fine run: ', date_string, ' ', time_string
  close(98)
end subroutine append_simulation_recap_footer


subroutine prepar_tecplot
  use Variabili
  implicit none

  integer :: i, j
  logical :: trovato
  integer, dimension(:), allocatable :: temp

  nnodi_vis = 0

  if (allocated(nodi_vis)) deallocate(nodi_vis)
  if (allocated(nodi_agg_vis)) deallocate(nodi_agg_vis)

  allocate(nodi_vis(nnodi))
  allocate(nodi_agg_vis(5 * nele_interni))

  ! Raccoglie i nodi che compaiono sulle interfacce.  Il vettore e' mantenuto
  ! per compatibilita' diagnostica, anche se la scrittura Tecplot ora media in
  ! modo robusto su tutti gli elementi associati al nodo.
  do i = 1, ninterf
    if (nnodi_vis == 0) then
      nnodi_vis = 1
      nodi_vis(nnodi_vis) = interf(i)%nodo1
      if (interf(i)%nodo2 /= interf(i)%nodo1) then
        nnodi_vis = nnodi_vis + 1
        nodi_vis(nnodi_vis) = interf(i)%nodo2
      end if
    else
      trovato = .FALSE.
      do j = 1, nnodi_vis
        if (interf(i)%nodo1 == nodi_vis(j)) trovato = .TRUE.
      end do
      if (.not. trovato) then
        nnodi_vis = nnodi_vis + 1
        nodi_vis(nnodi_vis) = interf(i)%nodo1
      end if

      trovato = .FALSE.
      do j = 1, nnodi_vis
        if (interf(i)%nodo2 == nodi_vis(j)) trovato = .TRUE.
      end do
      if (.not. trovato) then
        nnodi_vis = nnodi_vis + 1
        nodi_vis(nnodi_vis) = interf(i)%nodo2
      end if
    end if
  end do

  call bubble_sort(nodi_vis, nnodi_vis)

  allocate(temp(nnodi_vis))
  temp = nodi_vis(1:nnodi_vis)
  do i = 1, nnodi_vis
    nodi_vis(i) = temp(nnodi_vis - i + 1)
  end do
  deallocate(temp)

  write(*,*) 'nnodi_vis = ', nnodi_vis
end subroutine prepar_tecplot
