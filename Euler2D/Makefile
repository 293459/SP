# ============================================================
#  SP — Euler2D Solver
#  Makefile
#
#  Uso:
#    make            → compila in modalità release (euler2d)
#    make debug      → compila con bound-checking e backtrace
#    make clean      → rimuove oggetti, moduli ed eseguibile
#
#  Requisiti: gfortran >= 10  oppure  ifort/ifx (Intel oneAPI)
# ============================================================

# --- Compilatore ---
FC = gfortran

# --- Flag base ---
FFLAGS_RELEASE = -O2 -Wall -Wextra -Wno-unused-dummy-argument
FFLAGS_DEBUG   = -O0 -g -fcheck=bounds -fbacktrace -Wall -Wextra

# Default: release
FFLAGS = $(FFLAGS_RELEASE)

# --- Eseguibile ---
TARGET = euler2d

# ============================================================
#  Ordine di compilazione — rispetta le dipendenze USE Fortran
#
#  costanti  →  strutture  →  Variabili  →  [utility]  →  main
#
#  Le unit di modulo devono essere compilate prima di qualunque
#  file che le referenzia con USE.
# ============================================================
SRCS = \
    strutture.f90            \
    Variabili.f90            \
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

# ============================================================
#  Target principali
# ============================================================

.DEFAULT_GOAL := all

.PHONY: all debug clean help

all: $(TARGET)
	@echo ""
	@echo "  Build completato: ./$(TARGET)"
	@echo "  Uso: ./$(TARGET) <percorso_mesh.msh>"
	@echo ""

debug: FFLAGS = $(FFLAGS_DEBUG)
debug: clean $(TARGET)
	@echo ""
	@echo "  Build DEBUG completato: ./$(TARGET)"
	@echo "  Bound checking e backtrace attivi."
	@echo ""

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^

# Regola generica: ogni .f90 → .o
# gfortran produce automaticamente il .mod nella directory corrente
%.o: %.f90
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f *.o *.mod *.smod $(TARGET) $(TARGET).exe
	@echo "  Pulizia completata."

help:
	@echo ""
	@echo "  Targets disponibili:"
	@echo "    make          → release build (ottimizzato)"
	@echo "    make debug    → debug build  (bound check + backtrace)"
	@echo "    make clean    → rimuovi oggetti, moduli, eseguibile"
	@echo ""

# ============================================================
#  Dipendenze esplicite dei moduli
#  (necessarie perché Make non legge USE Fortran in automatico)
# ============================================================
Variabili.o: strutture.o
leggi_gmsh.o: Variabili.o strutture.o
processa_griglia.o: Variabili.o strutture.o
subroutine_geometria.o: Variabili.o strutture.o
main.o: Variabili.o strutture.o output.o integ_time.o