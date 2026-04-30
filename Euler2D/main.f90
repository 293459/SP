Program test2d
    Use Variabili  ! utilizza tutto quello che � nel modulo variabili che a sua volta contiene Use strutture e quindi richiama il contenuto di quel file
    Implicit none

	!call system("rm *.plt") !ATTENZIONE: cancella tutti i file plt presenti nella cartella! (su linux)
	call system("del *.plt") !ATTENZIONE: cancella tutti i file plt presenti nella cartella! (su windows) -- plt estensione in cui si salva la soluzione
	! comando utile per mantenere un ordine e riferire il file di soluzione a quella che effettivamente si � utilizzata

    call input ! leggi il file di input e salva le informazioni nei parametri globali definiti nel modulo variabili

    call leggi_gmsh ! leggi il file di mesh generato con gmsh e salva le informazioni nei vettori di tipo nodo, elemento e interfaccia

    call processa_elementi

    !Verifica delle caratteristiche geometria per elemento 10 e interfaccia 10
    write(*,*)'ele(10)%x0 = ',ele(10)%x0 ! punto di riferimento dell'elemento 10
    write(*,*)'ele(10)%area = ',ele(10)%area ! area dell'elemento 10
    write(*,*)'interf(100)%length = ',interf(100)%length ! lunghezza dell'interfaccia 100
    write(*,*)'interf(100)%normal = ',interf(100)%normal ! normale dell'interfaccia 100
    write(*,*) 'lc = ', nodo(ele(1)%nodi(2))%x(1) - nodo(ele(1)%nodi(1))%x(1) 
	! questo comando serve per verificare che la lunghezza caratteristica lc sia corretta,
	! in questo caso dovrebbe essere 0.1 dato che i nodi 1 e 2 dell'elemento 1 sono rispettivamente (0,0) e (0.1,0)

	call init ! inizializza le variabili di stato, ad esempio per il primo passo temporale, e calcola i primi flussi

	call write_tecplot_file(0,0.) ! primo parametro determina il nome del file, secondo parametro determina la traslazione lungo y


    time=0. ! inizializza il tempo a zero (non avrebbe molto senso partire da un tempo intermedio)

	do k=1,kfinal ! ciclo temporale che va da 1 a kfinal, dove kfinal � un parametro di input che determina il numero massimo di iterazioni temporali


		call compute_dt   ! calcola dt ad ogni passo temporale attraverso la condizione CFL quindi abbiamo bisogno di aggiornare il dt ammissibile che � diverso per ogni passo nel tempo
		call compute_fluxes ! calcolo dei flussi
		call integ_time ! integrazione temporale esplicita, ad esempio con metodo di Eulero esplicito, quindi aggiorna le variabili di stato per il passo successivo

		time=time+dt ! aggiorna il tempo sommando il dt appena calcolato


		if(mod(k,kinf).eq.0)then ! fai output ogni volta che la divisione tra interi non ha resto, quindi ogni kinf iterazioni, 
			                     ! dove kinf � un parametro di input che determina la frequenza di output a video
			write(*,*)' ' ! stampa una riga vuota per separare i blocchi di output
			write(*,*)'*************************************************'
			write(*,*)'k,time,dt = ',k,time,dt ! stampa il numero di iterazione, il tempo e il dt

			call compute_norm_residuals ! calcola la norma dei residui per monitorare la convergenza
			!write(*,*)'norm2_residuals = ',norm2_residuals ! stampa la norma dei residui
			call compute_norm_entropy ! calcola la norma dell'entropia per monitorare la convergenza
			!write(*,*)'norm_entropy = ',norm_entropy ! stampa la norma dell'entropia
			call save_wall_data ! salva i dati relativi alla parete, ad esempio per monitorare la forza di attrito o il coefficiente di pressione
			!write(*,*)'wall_data = ',wall_data ! stampa i dati relativi alla parete
			write(*,*)'*************************************************'


		end if


		if(mod(k,kout).eq.0)then ! fai output ogni volta che la divisione tra interi non ha resto, quindi ogni kout iterazioni, 
			                     ! dove kout � un parametro di input che determina la frequenza di output su file
			call write_tecplot_file(k,0.) ! salva la soluzione in un file tecplot, il primo parametro determina il nome del file,
			                              ! secondo parametro determina la traslazione lungo y
		end if

		if((norm2_residuals(2).lt.1E-4).and.(k.gt.1000)) then ! (CONDIZIONE DI ARRESTO)
		! se la norma dei residui per la variabile 2 (ad esempio la pressione) è inferiore a 1E-4 e
		! siamo oltre le prime 1000 iterazioni, allora interrompi la simulazione
        ! call write_goal_functions ! salva le funzioni obiettivo, ad esempio per monitorare la forza di attrito o il coefficiente di pressione
        call write_tecplot_file(k,0.) ! salva la soluzione finale in un file tecplot
        exit
		end if

	end do



End Program






