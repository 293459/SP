Program test2d
    Use Variabili
    Implicit none

    ! [MODIFICA 2026-05-06]
    ! Il solver non cancella piu' "*.plt" nella directory corrente. Ogni run
    ! scrive nella propria output_dir, quindi piu' processi possono girare in
    ! parallelo senza eliminare i risultati degli altri.
    call setup_runtime_from_args

    call input
    call leggi_gmsh
    call processa_elementi

    ! Le caratteristiche geometriche diagnostiche non vengono piu' salvate in
    ! un file separato e ambiguo ("caratteristiche_elemento_10.txt"). Sono
    ! archiviate nel recap della singola simulazione, insieme ai conteggi mesh.
    call write_simulation_recap_header

    call init ! file di input, condizioni iniziali, condizioni al contorno, etc.
    call write_tecplot_file(0,0.) ! Salva la condizione iniziale, per confronto con i risultati di riferimento.

    time=0. ! tempo iniziale nullo
    norm2_residuals(:)=huge(1.0)   ! inizializza a un numero molto grande per evitare di stampare valori non significativi nei primi output.
                                   ! Il test di convergenza viene eseguito solo dopo 1000 iterazioni, quindi a quel punto i residui dovrebbero
                                   ! essere già scesi a valori fisicamente significativi.
    norminf_residuals(:)=huge(1.0) ! stesso discorso della norma 2 ma per la norma infinito.

	do k=1,kfinal            ! siamo noi a scegliere il numero di pasi temporli (kfinal)

		call compute_dt      ! calcola il passo temporale (CFL, viscosità numerica, etc.)
		call compute_fluxes  ! calcola i flussi numerici per tutti gli elementi interni e di bordo
		call integ_time      ! aggiorna le variabili conservative usando i flussi calcolati

		time=time+dt         ! aggiorna il tempo fisico della simulazione

		if(mod(k,kinf).eq.0)then ! ogni kinf iterazioni
			write(*,*)' '
			write(*,*)'*************************************************'
			write(*,*)'k,time,dt = ',k,time,dt ! k è il numero di iterazione, time è il tempo fisico, dt è il passo temporale.

			call compute_norm_residuals   ! calcola la norma 2 dei residui per tutti gli elementi interni e di bordo
			call compute_norm_entropy     ! calcola la norma 2 dell'entropia per tutti gli elementi interni e di bordo, per monitorare la stabilità numerica e la qualità della soluzione.
			call save_wall_data           ! salva i dati di parete (pressione, attriti, etc.) per confronto con i risultati di riferimento.
			write(*,*)'*************************************************'
		end if

		if(mod(k,kout).eq.0)then ! ogni kout iterazioni
			call write_tecplot_file(k,0.) ! salva la soluzione in un file Tecplot, per confronto con i risultati di riferimento.
		end if

        ! Fortran non garantisce lo short-circuit degli operatori logici:
        ! separare i due test evita di leggere norm2_residuals prima che abbia
        ! un valore fisicamente significativo.
		if(k.gt.1000) then ! dopo 1000 iterazioni, i residui dovrebbero essere già scesi a valori fisicamente significativi, quindi è possibile eseguire il test di convergenza.
            if(norm2_residuals(2).lt.1E-4) then ! se la norma 2 del residuo di energia è inferiore a 1E-4, consideriamo la soluzione convergente e usciamo dal ciclo.
                call write_tecplot_file(k,0.) ! salva la soluzione finale in un file Tecplot, per confronto con i risultati di riferimento.
                exit
            end if
		end if

	end do

    call append_simulation_recap_footer ! scrive in un file di testo le informazioni di fine simulazione, come il tempo totale di esecuzione, i residui finali, etc.

End Program
