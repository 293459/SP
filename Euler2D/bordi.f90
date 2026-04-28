! In questo file ci sono le subroutine che gestiscono i flussi alle interfacce di tipo 99 (parete), 2 (inflow) e 3 (outflow),
! e la subroutine per salvare i dati relativi alla parete in un file di testo. Queste subroutine vengono chiamate all'interno 
! del ciclo temporale nel main.f90 per aggiornare i flussi alle interfacce e per monitorare i dati relativi alla parete durante la simulazione.


! *******************************************************************************************************
Subroutine save_wall_data ! salva i dati relativi alla parete, ad esempio per monitorare la forza di attrito o il coefficiente di pressione

    Use Variabili

	Implicit none
	integer::i ! indice per il ciclo sugli interfacciali (parete) di tipo 99

    open (unit =1, file= 'wall_data.txt') ! apre un file di testo per scrivere i dati relativi alla parete
    
        do i =1, ninterf ! ciclo su tutti gli interfacciali, ma in questo caso ci interessa solo quelli di tipo 99 (parete)

            if (interf(i)%entity.eq.99) then ! se l'interfaccia i è di tipo 99, allora salva i dati relativi alla parete
                write(1, *) interf(i)%x0, ele(interf(i)%e1)%P ! salva la posizione x0 dell'interfaccia e la pressione P dell'elemento adiacente alla parete
            end if

        end do

    close(1)

end Subroutine
! *******************************************************************************************************



! *******************************************************************************************************
Subroutine compute_boundary_flux(i) ! calcola i flussi alle interfacce di tipo 99 (parete), 2 (inflow) e 3 (outflow)

	Use Variabili

	Implicit none

	integer::l,i,j,nn ! INDICE per il ciclo sugli interfacciali, indice per il ciclo sui nodi, indice per il ciclo sugli elementi

	real(8)::ud,vd,pd,hd,ad,r1b,td,rhod,utilde,vtilde,PRH,M1rel2,rhoexit,uexit,&
&   r2dum,pc,sc,tc,ac,uc,vc,rhoc,ec,F2dum,F3dum,sd,f1,f2,f3,f4,R3A 
    ! VARIABILI per il calcolo dei flussi alle interfacce, per il mezzo problema di Riemann a parete o per le condizioni al contorno di inflow e outflow
    ! più precisamente le variabili indicano la pressione, la velocità, il campo di velocità, la densità, il campo di velocità, 
    ! il campo di velocità, il campo di velocità, la pressione, la densità, l'energia, i flussi, ecc. che servono per calcolare 
    !i flussi alle interfacce di tipo 99 (parete), 2 (inflow) e 3 (outflow)

    ! scelta della subroutine da chiamare in base al tipo di interfaccia
	if(interf(i)%entity.eq.99)then ! se l'interfaccia i è di tipo 99, allora calcola i flussi alle pareti attraverso la risoluzione del mezzo problema di Riemann a parete
                call swi(i) ! chiama la subroutine SWI che risolve il mezzo problema di Riemann a parete e calcola i flussi alle interfacce di tipo 99 (parete)

    elseif(interf(i)%entity.eq.2)then ! se l'interfaccia i è di tipo 2, allora calcola i flussi alle condizioni al contorno di inflow, ad esempio con condizioni di tipo isentropico o con condizioni di tipo Riemann
                call insub(i) ! chiama la subroutine insub che risolve il mezzo problema di Riemann a inflow e calcola i flussi alle interfacce di tipo 2 (inflow)
    elseif(interf(i)%entity.eq.3)then ! se l'interfaccia i è di tipo 3, allora calcola i flussi alle condizioni al contorno di outflow, ad esempio con condizioni di tipo isentropico o con condizioni di tipo Riemann
                call outsub(i) ! chiama la subroutine outsub che risolve il mezzo problema di Riemann a outflow e calcola i flussi alle interfacce di tipo 3 (outflow)
    end if

end subroutine
! *******************************************************************************************************


! *******************************************************************************************************
subroutine SWI(i) !SWI sta per "Subroutine Wall Interface"
use Variabili
implicit none
integer::i,j,ii,jj,nDOFsele ! indice per il ciclo sugli interfacciali, indice per il ciclo sui nodi, indice per il ciclo sugli elementi, numero di gradi di libertà per elemento
real(8)::u1a,u2a,u3a,u5a,ud,vd,pd,ad,hd,utilde,ac,pc,f1,f2,f3,f4,segno,phipq,vtilde,mlocal,z,ub,vb,ud_corr,vd_corr
! queste variabili indicano le quantità necessarie per risolvere il mezzo problema di Riemann a parete, ad esempio la velocità, la pressione, la densità, l'energia, i flussi, ecc.
real(8),dimension(2)::csi ! variabile per le coordinate locali, csi sta per "coordinate system interface" 
                          ! ed è un array di dimensione 2 che contiene le coordinate locali dell'interfaccia,
                          ! ad esempio per un elemento triangolare potrebbe essere (0.5,0.5) per il punto medio dell'interfaccia



        ! estraggo le quantità di interesse dall'elemento adiacente alla parete, che è l'elemento ele(interf(i)%e1), e in particolare prendo la densità, la quantità di moto in x, la quantità di moto in y e l'energia totale
        u1a=ele(interf(i)%e1)%ucons(2) ! u1a è la densità dell'elemento adiacente alla parete, che si ottiene dal vettore ucons dell'elemento ele(interf(i)%e1) che è l'elemento adiacente alla parete, e il secondo componente del vettore ucons è la densità
        u2a=ele(interf(i)%e1)%ucons(3) ! u2a è la quantità di moto in x dell'elemento adiacente alla parete, che si ottiene dal vettore ucons dell'elemento ele(interf(i)%e1) che è l'elemento adiacente alla parete, e il terzo componente del vettore ucons è la quantità di moto in x
        u3a=ele(interf(i)%e1)%ucons(4) ! u3a è la quantità di moto in y dell'elemento adiacente alla parete, che si ottiene dal vettore ucons dell'elemento ele(interf(i)%e1) che è l'elemento adiacente alla parete, e il quarto componente del vettore ucons è la quantità di moto in y
        u5a=ele(interf(i)%e1)%ucons(1) ! u5a è l'energia totale dell'elemento adiacente alla parete, che si ottiene dal vettore ucons dell'elemento ele(interf(i)%e1) che è l'elemento adiacente alla parete, e il primo componente del vettore ucons è l'energia totale
        segno=-1.


!		Risoluzione del mezzo problema di Riemann a parete



    ud=u2a/u1a ! ud è la velocità in x dell'elemento adiacente alla parete, che si ottiene dividendo la quantità di moto in x per la densità
    vd=u3a/u1a ! vd è la velocità in y dell'elemento adiacente alla parete, che si ottiene dividendo la quantità di moto in y per la densità
    pd=(gam-1.)*(u5a-0.5*u1a*(ud**2+vd**2)) ! pd è la pressione dell'elemento adiacente alla parete, che si ottiene dalla relazione di stato per un gas ideale, dove gam è il rapporto di calori specifici, u5a è l'energia totale, u1a è la densità, ud è la velocità in x e vd è la velocità in y



    hd=ga*Pd/u1a

    ad=sqrt((gam-1.)*hd)



    Utilde=-(Ud*interf(i)%normal(1)+Vd*interf(i)%normal(2))
    ac=ad-Utilde*GD
    Pc=Pd*(ac/ad)**(1./GI)

!		Calcolo dei flussi


    interf(i)%f(1)=0.0
    interf(i)%f(3)=Pc*interf(i)%normal(1)
    interf(i)%f(4)=Pc*interf(i)%normal(2)
    interf(i)%f(2)=0.0





end subroutine


! ****************************************************************************************

subroutine insub(i)
use Variabili
implicit none
integer::i,j
real(8)::u1a,u2a,u3a,u5a,ud,vd,pd,ad,hd,utilde,utildeinf,ac,pc,f1,f2,f3,f4,segno,&
&        r1b,r3a,sc,sd,tc,uc,vtilde,vc,rhoc,ec,f2dum,f3dum,td,rhod,tanalpha2,prova,tt,pt,&
&        kloc,wloc



    tt=ttotin
    pt=ptotin



        u1a=ele(interf(i)%e1)%ucons(2)
        u2a=ele(interf(i)%e1)%ucons(3)
        u3a=ele(interf(i)%e1)%ucons(4)
        u5a=ele(interf(i)%e1)%ucons(1)


    ud=u2a/u1a
    vd=u3a/u1a
    pd=(gam-1.)*(u5a-0.5*u1a*(ud**2+vd**2))
    hd=ga*Pd/u1a
    ad=sqrt((gam-1.)*hd)

    utilde=-(ud*interf(i)%normal(1)+vd*interf(i)%normal(2))
    Vtilde=-(-Ud*interf(i)%normal(2)+Vd*interf(i)%normal(1))
    prova=atan(interf(i)%normal(2)/interf(i)%normal(1))
    if(prova.gt.0.) then
        tanalpha2=tan(prova-alpha)
    else
        tanalpha2=tan(abs(prova)+alpha)
    end if

    r1b=GG*ad-utilde
	ad=(2.*r1b*(1.+tanalpha2**2)+sqrt(4.*r1b**2*(1.+tanalpha2**2)**2-&
	&4*(1.+gg*(1.+tanalpha2**2))*(gd*(1.+tanalpha2**2)*r1b**2-gam*tt)))/&
	&(2.*(1.+gg*(1.+tanalpha2**2)))
	ud=GG*ad-r1b
	td=ad**2/gam
	pd=pt*(td/tt)**(GA)
	rhod=pd/td

    if(prova.gt.0)then
        vd=-ud*tanalpha2
    else
        vd=ud*tanalpha2
    end if


	f2dum=pd+rhod*ud**2
	f3dum=rhod*ud*vd


	F2=-F2dum*interf(i)%normal(1)+F3dum*interf(i)%normal(2)
    F3=-F2dum*interf(i)%normal(2)-F3dum*interf(i)%normal(1)



    interf(i)%f(2)=-rhod*ud
    interf(i)%f(3)=-F2
    interf(i)%f(4)=-F3
    interf(i)%f(1)=-ud*(pd+pd/(gam-1.)+0.5*rhod*(ud**2+vd**2))




end subroutine

! ****************************************************************************************


! **********************************************************************************

subroutine outsub(i)
use Variabili
implicit none
integer::i,j,iele,iedge,kk,ielemento,ncoef
real(8)::u1a,u2a,u3a,u5a,u6a,u7a,u8a,ud,vd,pd,ad,hd,utilde,utildeinf,ac,pc,f1,f2,f3,f4,segno,&
&        r1b,r3a,sc,sd,tc,uc,vtilde,vc,rhoc,ec,f2dum,f3dum,td,rhod,r2dum,detj,jacobiano,&
&        tauxx,tauyy,tauxy,dphii_dx,dphii_dy,u6_ij,mut,muturbSA,wtildea,kaa,muturbkw,mua
real(8),dimension(2)::csi,gradu1,gradu2,gradu3,gradu5,gradu6,gradu7,gradu,gradv,gradt,gradrhonuSA,gradnuSA,gradk,gradwtilde
real(8),dimension(2,2)::jacob



iele=interf(i)%e1
iedge=interf(i)%edge_e1

! *****************************************************************






        ielemento=iele


        u1a=ele(interf(i)%e1)%ucons(2)
        u2a=ele(interf(i)%e1)%ucons(3)
        u3a=ele(interf(i)%e1)%ucons(4)
        u5a=ele(interf(i)%e1)%ucons(1)




    ud=u2a/u1a
    vd=u3a/u1a
    pd=(gam-1.)*(u5a-0.5*u1a*(ud**2+vd**2))
    hd=ga*Pd/u1a
    ad=sqrt((gam-1.)*hd)
    td=pd/u1a
    sd=gam*log(td)-(gam-1.)*log(pd)
    rhod=pd/td


    utilde=ud*interf(i)%normal(1)+vd*interf(i)%normal(2)
    Vtilde=-Ud*interf(i)%normal(2)+Vd*interf(i)%normal(1)

    If(utilde.gt.ad) Then

        F1=rhod*utilde
		F2dum=Pd+rhod*utilde**2
		F3dum=rhod*utilde*vtilde
        F4=utilde*(pd+pd/(gam-1.)+0.5*rhod*(utilde**2+vtilde**2))


    Else


		r2dum=ad/GD+utilde


		Pc=pexit
		sc=sd
		tc=exp((sc+(gam-1.)*log(pc))/gam)
		ac=sqrt(gam*tc)
		uc=r2dum-2.*ac/(gam-1.)
		vc=vtilde
		rhoc=pc/tc
		ec=rhoc*(Tc*GB+.5*(uc**2+vc**2))

		F1=rhoc*uc
		F2dum=Pc+f1*uc
		F3dum=F1*vc
		F4=uc*(ec+Pc)



    End if


	F2=F2dum*interf(i)%normal(1)-F3dum*interf(i)%normal(2)
    F3=F2dum*interf(i)%normal(2)+F3dum*interf(i)%normal(1)

    interf(i)%f(2)=f1
    interf(i)%f(3)=F2
    interf(i)%f(4)=F3
    interf(i)%f(1)=f4






end subroutine

! *******************************************************************
