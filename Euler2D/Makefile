# 1. DEFINIZIONE VARIABILI (Così se cambi compilatore, lo fai in un punto solo)
FC      = gfortran
FFLAGS  = -ffree-line-length-none -O2
EXE     = solver2d

# 2. LISTA FILE (L'ordine qui non è vitale, ma aiuta la lettura)
SRCS    = strutture.f90 Variabili.f90 leggi_gmsh.f90 subroutine_geometria.f90 \
          processa_griglia.f90 input.f90 init.f90 bordi.f90 \
          compute_dt.f90 compute_fluxes.f90 integ_time.f90 output.f90 \
          main.f90

# Trasforma la lista dei .f90 in una lista di .o (file oggetto intermedi)
OBJS    = $(SRCS:.f90=.o)

# 3. I "TARGET" (Gli obiettivi)

# Il primo target è quello eseguito di default quando scrivi solo 'make'
all: $(EXE)

# Regola per creare l'eseguibile: unisce tutti i file .o
$(EXE): $(OBJS)
	$(FC) $(FFLAGS) -o $@ $^

# 4. GESTIONE DIPENDENZE (Fondamentale in Fortran!)
# I moduli creano file .mod. Se Variabili.f90 usa Strutture.f90, 
# dobbiamo dire a make di compilare prima Strutture.

strutture.o: strutture.f90
	$(FC) $(FFLAGS) -c strutture.f90

Variabili.o: Variabili.f90 strutture.o
	$(FC) $(FFLAGS) -c Variabili.f90

# Regola generica: come creare un .o da un .f90
%.o: %.f90 Variabili.o
	$(FC) $(FFLAGS) -c $<

# Pulizia: 'make clean' elimina i file temporanei per ripartire da zero
clean:
	rm -f *.o *.mod $(EXE)