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

    call init
    call write_tecplot_file(0,0.)

    time=0.
    norm2_residuals(:)=huge(1.0)
    norminf_residuals(:)=huge(1.0)

	do k=1,kfinal

		call compute_dt
		call compute_fluxes
		call integ_time

		time=time+dt

		if(mod(k,kinf).eq.0)then
			write(*,*)' '
			write(*,*)'*************************************************'
			write(*,*)'k,time,dt = ',k,time,dt

			call compute_norm_residuals
			call compute_norm_entropy
			call save_wall_data
			write(*,*)'*************************************************'
		end if

		if(mod(k,kout).eq.0)then
			call write_tecplot_file(k,0.)
		end if

        ! Fortran non garantisce lo short-circuit degli operatori logici:
        ! separare i due test evita di leggere norm2_residuals prima che abbia
        ! un valore fisicamente significativo.
		if(k.gt.1000) then
            if(norm2_residuals(2).lt.1E-4) then
                call write_tecplot_file(k,0.)
                exit
            end if
		end if

	end do

    call append_simulation_recap_footer

End Program
