subroutine write_tecplot_file(k_file,traslay)
 use variabili
 implicit none
 character(80):: datafile_tec,kcar
 integer :: i,os,j,k_file,iposj2,ndofsele,iele,jj
 real(4)::rho_node,rhou_node,rhov_node,e_node,u_node,v_node,p_node,M_node,S_node,muSA_node,wall_dist_node,phii,&
 phiorton,mua_node,u6_node,u7_node,u8_node,somma,sensore_residui,vort_thick_node,traslay
 real(4),dimension(2)::csi,xy,xyloc
logical::trovato

!--------------------------------------------------------------------------------
! blocco opzionale aggiunto da me per creare una cartella per ogni iterazione
! 1. CREA IL NOME DELLA CARTELLA (es: Results_Iter_100)
 write(kcar,'(I0)') k_file ! I0 elimina gli spazi vuoti automaticamente
 folder_name = "SIM_OUTPUT_" // trim(kcar)

 ! 2. CREA LA CARTELLA FISICAMENTE (Comando di sistema)
 ! 'mkdir -p' funziona su Linux/Mac. Se sei su Windows usa 'mkdir'
 call execute_command_line("mkdir -p " // trim(folder_name))

 ! 3. DEFINISCI IL PERCORSO DEL FILE DENTRO LA CARTELLA
 datafile_tec = trim(folder_name) // "/" // trim(kcar) // ".plt"
!--------------------------------------------------------------------------------

!--------------------------------------------------------------------------------

integer :: n_digits ! Variabile per il numero di cifre necessarie per rappresentare k_file
character(len=20) :: fmt_str ! Variabile per la stringa di formato dinamica

! 1. Calcola il numero di cifre necessarie
if (k_file > 0) then ! Se k_file è maggiore di 0, calcola il numero di cifre
    n_digits = int(log10(real(k_file))) + 1 ! ad esempio, se k_file è 100, log10(100) è 2, quindi n_digits sarà 3 (per rappresentare 100)
else
    n_digits = 1 ! Se k_file è 0 o negativo, consideriamo che serve almeno 1 cifra (per rappresentare 0)
end if

! 2. Crea una stringa di formato dinamica, es: '(i5)'
write(fmt_str, '(''(i'', i0, '')'')') n_digits 

! 3. Scrivi il numero con il formato esatto (senza spazi iniziali)
write(kcar, fmt_str) k_file

! 4. Componi il nome del file (senza bisogno di cercare spazi con index)
datafile_tec = trim(adjustl(kcar)) // '.plt'

 "
 	if(k_file.lt.10) then
	write(kcar,'(i1)') k_file
	else if(k_file.lt.100) then
	write(kcar,'(i2)') k_file
	else if(k_file.lt.1000) then
	write(kcar,'(i3)') k_file
	else if(k_file.lt.10000) then
	write(kcar,'(i4)') k_file
	else if(k_file.lt.100000) then
	write(kcar,'(i5)') k_file
	else if(k_file.lt.1000000) then
	write(kcar,'(i6)') k_file
	else if(k_file.lt.10000000) then
	write(kcar,'(i7)') k_file
	else if(k_file.lt.100000000) then
	write(kcar,'(i8)') k_file
	else if(k_file.lt.1000000000) then
	write(kcar,'(i9)') k_file
    end if iposj2=index(kcar,' ')! trova la posizione del primo spazio vuoto, in questo modo riesco a prendere solo la parte numerica del nome del file, senza spazi vuoti
	datafile_tec=kcar(1:iposj2-1)//'.plt' ! creo il nome del file tecplot, con estensione .plt, usando solo la parte numerica di kcar
"
!--------------------------------------------------------------------------------

 open(unit=1, file=datafile_tec) ! apertura del file tecplot, il nome del file è quello creato sopra
 write(1,*) 'title = "grid"' ! titolo del file tecplot
 write(1,'(a80)') 'variables = "x","y","rho","P","u","v","M","S"' 
 ! variabili da salvare su file, devono essere in accordo con quelle che si scrivono dopo, 
 ! se si vuole salvare una variabile in più o in meno basta aggiungerla o toglierla da questa riga 
 ! e da quella dopo, facendo attenzione all'ordine
 write(1,*) 'zone n=',nnodi,' e =', nele_interni,' et=quadrilateral, f=fepoint' 
 ! specifica che il file contiene una zona con nnodi nodi, nele_interni elementi, tipo quadrilatero e formato fepoint

!--------------------------------------------------------------------------------

! Nodal quantities: x, y, rho, u, v, p, Mach number
   do i = 1, nnodi ! ciclo su tutti i nodi, in questo ciclo si scrivono le variabili da salvare su file per ogni nodo

    rho_node=0.        ! inizializzo a zero la densità al nodo
    rhou_node=0.       ! inizializzo a zero la quantità di moto in x al nodo
    rhov_node=0.       ! inizializzo a zero la quantità di moto in y al nodo
    e_node=0.          ! inizializzo a zero l'energia totale al nodo
    muSA_node=0.       ! inizializzo a zero la viscosità turbolenta al nodo
    wall_dist_node=0.  ! inizializzo a zero la distanza dalla parete al nodo
    mua_node=0.        ! inizializzo a zero la viscosità dinamica al nodo
    vort_thick_node=0. ! inizializzo a zero il vortice di spessore al nodo
    u6_node=0.         ! inizializzo a zero la variabile u6 al nodo (residuo totale)
    somma=0.           ! inizializzo a zero la variabile somma, che serve per fare la media delle variabili al nodo, in caso il nodo sia condiviso da più elementi

    trovato=.FALSE. ! inizializzo a falso la variabile trovato, che serve per capire se il nodo è un nodo di interfaccia o meno
    do j=1,nnodi_vis ! ciclo sui nodi di interfaccia, che sono quelli che devo salvare su file
    if(i.eq.nodi_vis(j)) then ! se il nodo i è un nodo di interfaccia allora lo salvo su file, altrimenti no
        trovato=.TRUE.
        exit
    end if
    end do

    if(trovato)then !
        !do j=1,1
        do j=1,nodo(i)%neles
            if((nodo(i)%ele(j).ne.0))then
            
                rho_node=rho_node+ele(nodo(i)%ele(j))%ucons(2)
                rhou_node=rhou_node+ele(nodo(i)%ele(j))%ucons(3)
                rhov_node=rhov_node+ele(nodo(i)%ele(j))%ucons(4)
                e_node=e_node+ele(nodo(i)%ele(j))%ucons(1)
                
                
                somma=somma+1.d0
            

            end if
        end do

            rho_node=rho_node/somma
            rhou_node=rhou_node/somma
            rhov_node=rhov_node/somma
            e_node=e_node/somma


            u_node=rhou_node/rho_node
            v_node=rhov_node/rho_node
            P_node=(gam-1.)*(e_node-0.5*rho_node*((rhou_node/rho_node)**2+(rhov_node/rho_node)**2))
            M_node=sqrt(u_node**2+v_node**2)/sqrt(gam*P_node/rho_node)
            S_node=gam*log(P_node/rho_node)-(gam-1.)*log(p_node)

    else

            rho_node=rho_node+ele(iele)%ucons(2)
            rhou_node=rhou_node+ele(iele)%ucons(3)
            rhov_node=rhov_node+ele(iele)%ucons(4)
            e_node=e_node+ele(iele)%ucons(1)
            
            u_node=rhou_node/rho_node
            v_node=rhov_node/rho_node
            P_node=(gam-1.)*(e_node-0.5*rho_node*((rhou_node/rho_node)**2+(rhov_node/rho_node)**2))
            M_node=sqrt(u_node**2+v_node**2)/sqrt(gam*P_node/rho_node)
            S_node=gam*log(P_node/rho_node)-(gam-1.)*log(p_node)


    end if

            write(1,*) nodo(i)%x(1), nodo(i)%x(2)+traslay,rho_node,P_node,u_node,v_node,M_node,S_node
            ! scrivo su file le variabili da salvare, in questo ordine: x, y, rho, P, u, v, M, S
            ! sono rispettivamente: la coordinata x del nodo, la coordinata y del nodo (con traslazione), 
            ! la densità al nodo, la pressione al nodo, la velocità in x al nodo, la velocità in y al nodo,
            ! il numero di Mach al nodo e l'entropia al nodo
   end do

!--------------------------------------------------------------------------------
! Both quad and tria elements in quad format:

 do i = 1, nele_interni
   

      if (ele(i)%nnodi.eq.3) then

       write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(3)

      elseif (ele(i)%nnodi.eq.4) then

       write(1,*) ele(i)%nodi(1), ele(i)%nodi(2), ele(i)%nodi(3), ele(i)%nodi(4)

      else

       !Impossible
       write(*,*) " Error in ele%vtx data... Stop..: i,nele_interni,ele(i)%nvtx=",i,nele_interni,ele(i)%nnodi
       stop

      endif
  
 end do

!--------------------------------------------------------------------------------
 close(1)

! --- AGGIUNTA: SCRITTURA FILE RECAP GENERALE ---
 ! Apre il file in modalità "append" per aggiungere righe senza cancellare le precedenti
 open(unit=99, file="RECAP_SIMULAZIONI.csv", status="unknown", position="append")
 write(99, '(I0, A, I0, A, A)') k_file, ",", nnodi, ",", trim(datafile_tec)
 close(99)
 ! -----------------------------------------------

 end subroutine write_tecplot_file
 
 
 
 
 
subroutine prepar_tecplot
use Variabili
implicit none
integer::i,j
logical::trovato
integer,dimension(:),allocatable::temp

nnodi_vis=0

if(allocated(nodi_vis)) then
    deallocate(nodi_vis)
    deallocate(nodi_agg_vis)
end if

allocate(nodi_vis(nnodi))
allocate(nodi_agg_vis(5*nele_interni))

do i=1,ninterf

  

        if(nnodi_vis.gt.0)then

            TROVATO=.FALSE.
            do j=1,nnodi_vis
                if(interf(i)%nodo1.eq.nodi_vis(j)) TROVATO=.TRUE.
            end do

            if(TROVATO.eqv..FALSE.) then
                nnodi_vis=nnodi_vis+1
                nodi_vis(nnodi_vis)=interf(i)%nodo1
            end if

            TROVATO=.FALSE.
            do j=1,nnodi_vis
                if(interf(i)%nodo2.eq.nodi_vis(j)) TROVATO=.TRUE.
            end do

            if(TROVATO.eqv..FALSE.) then
                nnodi_vis=nnodi_vis+1
                nodi_vis(nnodi_vis)=interf(i)%nodo2
            end if

        else
            nnodi_vis=nnodi_vis+1
            nodi_vis(nnodi_vis)=interf(i)%nodo1
            nnodi_vis=nnodi_vis+1
            nodi_vis(nnodi_vis)=interf(i)%nodo2
        end if


    

end do

call bubble_sort(nodi_vis,nnodi_vis) ! ordina in ordine crescente gli indici dei nodi da salvare su file,  
                                ! in questo modo è più facile fare il ciclo sui nodi e trovare quelli da salvare su file

allocate(temp(nnodi_vis))

temp=nodi_vis(1:nnodi_vis)

do i=1,nnodi_vis
    nodi_vis(i)=temp(nnodi_vis-i+1)
end do

deallocate(temp)

write(*,*)'nnodi_vis = ',nnodi_vis

end subroutine



