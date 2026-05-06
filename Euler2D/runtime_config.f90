!===============================================================================
! Runtime configuration and path helpers.
!
! The solver is still a single Euler2D executable, but it no longer assumes that
! every run must read Bump/input.txt and write into the current directory.  This
! is the small layer that makes batch and parallel runs safe:
!
!   euler2d.exe [input_file] [output_dir]
!
! input_file keeps the historical input.txt structure.  inlet.txt and outlet.txt
! are searched next to input_file, and a relative mesh path is also interpreted
! relative to that same directory.  output_dir receives Tecplot files, norms,
! wall data and the per-run RECUP_SIMULAZIONE.txt.
!===============================================================================

subroutine setup_runtime_from_args
  use Variabili
  implicit none

  character(len=300) :: arg
  integer :: stat

  input_file = 'input.txt'
  output_dir = '.'

  call get_command_argument(1, arg, status=stat)
  if (stat == 0 .and. len_trim(arg) > 0) input_file = adjustl(arg)

  call get_command_argument(2, arg, status=stat)
  if (stat == 0 .and. len_trim(arg) > 0) output_dir = adjustl(arg)

  call get_parent_dir(input_file, input_dir)
  call ensure_directory(output_dir)

  write(*,*) 'Runtime input file  = ', trim(input_file)
  write(*,*) 'Runtime input dir   = ', trim(input_dir)
  write(*,*) 'Runtime output dir  = ', trim(output_dir)
end subroutine setup_runtime_from_args


subroutine get_parent_dir(path, parent)
  implicit none

  character(len=*), intent(in)  :: path
  character(len=*), intent(out) :: parent
  integer :: last_separator

  parent = '.'
  last_separator = scan(trim(path), '/\', back=.true.)

  if (last_separator > 1) then
    parent = path(1:last_separator-1)
  else if (last_separator == 1) then
    parent = path(1:1)
  end if
end subroutine get_parent_dir


subroutine build_path(directory, name, full_path)
  implicit none

  character(len=*), intent(in)  :: directory
  character(len=*), intent(in)  :: name
  character(len=*), intent(out) :: full_path

  character(len=300) :: dir_clean
  character(len=300) :: name_clean
  integer :: dir_len, name_len
  logical :: is_absolute

  dir_clean = adjustl(directory)
  name_clean = adjustl(name)
  dir_len = len_trim(dir_clean)
  name_len = len_trim(name_clean)

  is_absolute = .false.
  if (name_len >= 1) then
    if (name_clean(1:1) == '/' .or. name_clean(1:1) == '\') is_absolute = .true.
  end if
  if (name_len >= 2) then
    if (name_clean(2:2) == ':') is_absolute = .true.
  end if

  if (is_absolute .or. dir_len == 0 .or. trim(dir_clean) == '.') then
    full_path = trim(name_clean)
  else if (dir_clean(dir_len:dir_len) == '/' .or. dir_clean(dir_len:dir_len) == '\') then
    full_path = trim(dir_clean) // trim(name_clean)
  else
    full_path = trim(dir_clean) // '/' // trim(name_clean)
  end if
end subroutine build_path


subroutine ensure_directory(path)
  implicit none

  character(len=*), intent(in) :: path
  character(len=700) :: command
  integer :: exit_code
  logical :: exists

  if (len_trim(path) == 0 .or. trim(path) == '.') return

  ! gfortran/MinGW reports directories through INQUIRE(file=..., exist=...).
  ! If the directory already exists, skipping mkdir avoids the noisy Windows
  ! message "Sottodirectory o file ... gia' esistente".
  inquire(file=trim(path), exist=exists)
  if (exists) return

  command = 'mkdir "' // trim(path) // '"'
  call execute_command_line(trim(command), exitstat=exit_code)

  if (exit_code /= 0) then
    write(*,*) 'ERRORE: impossibile creare la cartella: ', trim(path)
    write(*,*) 'Comando eseguito: ', trim(command)
    stop 10
  end if
end subroutine ensure_directory
