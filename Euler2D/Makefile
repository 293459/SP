# ============================================================
#  SP - Euler2D Solver
#  Makefile minimale per Windows/MinGW e gfortran.
#
#  Target principali:
#    mingw32-make          compila il solver in release
#    mingw32-make debug    ricompila con check runtime e backtrace
#    mingw32-make clean    rimuove solo artefatti del solver
#    mingw32-make rebuild  clean + build release
#
#  Nota importante:
#  Il vecchio target clean usava "rm -f". Su Windows, quando
#  mingw32-make non trova un ambiente Unix nel PATH, "rm" non esiste
#  e il clean fallisce prima ancora di cancellare i file. Qui usiamo
#  "cmd /C del", quindi il target funziona nel terminale PowerShell
#  standard di VS Code.
# ============================================================

FC      = gfortran
TARGET  = euler2d
RM_CMD  = cmd /C "del /Q *.o *.mod *.smod $(TARGET) $(TARGET).exe 2>NUL || exit /B 0"

# -ffree-line-length-none evita errori sulle righe Fortran lunghe.
# -Wno-tabs evita rumore dovuto alle tabulazioni storiche gia' presenti.
# I warning su variabili inutilizzate restano attivi.
FFLAGS_COMMON  = -ffree-line-length-none -Wall -Wextra -Wno-unused-dummy-argument -Wno-tabs
FFLAGS_RELEASE = -O2 $(FFLAGS_COMMON)
FFLAGS_DEBUG   = -O0 -g -fcheck=all -fbacktrace $(FFLAGS_COMMON)
FFLAGS         = $(FFLAGS_RELEASE)

# Ordine compilazione: i moduli devono precedere i file che fanno USE.
SRCS = \
    strutture.f90            \
    Variabili.f90            \
    runtime_config.f90       \
    leggi_gmsh.f90           \
    subroutine_geometria.f90 \
    processa_griglia.f90     \
    bordi.f90                \
    init.f90                 \
    input.f90                \
    compute_dt.f90           \
    compute_fluxes.f90       \
    integ_time.f90           \
    bubble_sort.f90          \
    output.f90               \
    main.f90

OBJS = $(SRCS:.f90=.o)

.DEFAULT_GOAL := all
.PHONY: all debug clean rebuild help

all: $(TARGET)
	@echo.
	@echo Build completato: .\$(TARGET).exe
	@echo Uso: .\$(TARGET).exe [input_file] [output_dir]
	@echo.

debug: FFLAGS = $(FFLAGS_DEBUG)
debug: clean $(TARGET)
	@echo.
	@echo Build DEBUG completato: .\$(TARGET).exe
	@echo Runtime check e backtrace attivi.
	@echo.

rebuild: clean all

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^

%.o: %.f90
	$(FC) $(FFLAGS) -c $<

clean:
	@$(RM_CMD)
	@echo Pulizia completata.

help:
	@echo.
	@echo Target disponibili:
	@echo   mingw32-make          build release
	@echo   mingw32-make debug    build debug con check runtime
	@echo   mingw32-make clean    rimuove oggetti, moduli, eseguibile
	@echo   mingw32-make rebuild  clean + build release
	@echo.

# Dipendenze esplicite principali dei moduli Fortran.
Variabili.o: strutture.o
runtime_config.o: Variabili.o strutture.o
leggi_gmsh.o: Variabili.o strutture.o
processa_griglia.o: Variabili.o strutture.o
subroutine_geometria.o: Variabili.o strutture.o
output.o: bubble_sort.o runtime_config.o Variabili.o strutture.o
input.o: runtime_config.o Variabili.o strutture.o
main.o: runtime_config.o Variabili.o strutture.o output.o integ_time.o
