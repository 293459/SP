Program test2d
    Use Variabili  ! utilizza tutto quello che è nel modulo variabili che a sua volta contiene Use strutture e quindi richiama il contenuto di quel file
    Implicit none

	!call system("rm *.plt") !ATTENZIONE: cancella tutti i file plt presenti nella cartella! (su linux)
	call system("del *.plt") !ATTENZIONE: cancella tutti i file plt presenti nella cartella! (su windows) -- plt estensione in cui si salva la soluzione
	! comando utile per mantenere un ordine e riferire il file di soluzione a quella che effettivamente si è utilizzata

    call input !

    call leggi_gmsh

    call processa_elementi

    !Verifica delle caratteristiche geometria per elemento 10 e interfaccia 10
    write(*,*)'ele(10)%x0 = ',ele(10)%x0
    write(*,*)'ele(10)%area = ',ele(10)%area
    write(*,*)'interf(100)%length = ',interf(100)%length
    write(*,*)'interf(100)%normal = ',interf(100)%normal
    write(*,*) 'lc = ', nodo(ele(1)%nodi(2))%x(1) - nodo(ele(1)%nodi(1))%x(1)

	call init

	call write_tecplot_file(0,0.) !primo parametro determina il nome del file, secondo parametro determina la traslazione lungo y


    time=0.

	do k=1,kfinal


		call compute_dt   ! calcola dt ad ogni passo temporale attraverso la condizione CFL quindi abbiamo bisogno di aggiornare il dt ammissibile che è diverso per ogni passo nel tempo
		call compute_fluxes ! calcolo dei flussi
		call integ_time

		time=time+dt


		if(mod(k,kinf).eq.0)then   ! fai print ogni volta che la divisione tra interi non ha resto
			write(*,*)' '
			write(*,*)'*************************************************'
			write(*,*)'k,time,dt = ',k,time,dt

			call compute_norm_residuals
			call compute_norm_entropy
			call save_wall_data


		end if


		if(mod(k,kout).eq.0)then
			call write_tecplot_file(k,0.)
		end if

		if((norm2_residuals(2).lt.1E-4).and.(k.gt.1000)) then
        !call write_goal_functions
        call write_tecplot_file(k,0.)
        exit
		end if

	end do



End Program






