! integ_time.f90 serve a aggiornare le variabili conservative e primitive ad ogni passo di tempo,
! utilizzando il termine di flusso diviso area calcolato nella subroutine compute_fluxes.
subroutine integ_time 
use variabili
implicit none
integer::i

! Explicit Euler update of the conservative variables.
! The numerical scheme is unchanged: d_dt already contains the flux balance
! divided by cell area, and dt is provided by compute_dt.
do i = 1, nele_interni ! loop su tutti gli elementi interni   

    !aggiorno le variabili conservative con il termine di flusso diviso area moltiplicato per dt
    ele(i)%ucons(:) = ele(i)%ucons(:) + dt * ele(i)%d_dt(:) ! in pratica corrisponde alla formula u^{n+1} = u^n + dt * d_dt, dove u è il vettore delle variabili conservative 
    ! e d_dt è il termine di flusso diviso area, quindi questa è la formula per aggiornare le variabili conservative con il metodo di Eulero esplicito

    ! aggiorno le variabili primitive per il calcolo di grandezze come pressione, temperatura, velocità, entropia
    ele(i)%u = ele(i)%ucons(3) / ele(i)%ucons(2)                   ! ele(i)%ucons(3) è la quantità di moto in x, ele(i)%ucons(2) è la densità, quindi u è la velocità in x (cioè rho*u/rho=u)
    ele(i)%v = ele(i)%ucons(4) / ele(i)%ucons(2)                   ! ele(i)%ucons(4) è la quantità di moto in y, ele(i)%ucons(2) è la densità, quindi v è la velocità in y (cioè rho*v/rho=v)
    ele(i)%p = (gam - 1.0) * (ele(i)%ucons(1) - &                  ! ele(i)%ucons(1) è la densità di energia totale, ele(i)%ucons(2) è la densità, ele(i)%u e ele(i)%v sono le velocità in x e y, quindi questa è la formula per calcolare la pressione a partire dalle variabili conservative
               0.5 * ele(i)%ucons(2) * (ele(i)%u**2 + ele(i)%v**2))! quindi questa è la formula per calcolare la pressione a partire dalle variabili conservative
    ele(i)%T = ele(i)%P / ele(i)%ucons(2)                          ! P = rho T  ---> gas perfetti adimensionale, quindi questa è la formula per calcolare la temperatura a partire dalla pressione e dalla densità
    ele(i)%a = sqrt(ele(i)%T * gam)                                ! a = sqrt(gamma * R * T) con R adimensionale uguale a 1, quindi questa è la formula per calcolare la velocità del suono a partire dalla temperatura
    ele(i)%S = gam * log(ele(i)%T) - (gam - 1.0) * log(ele(i)%P)   ! questa è la formula per calcolare l'entropia a partire dalla temperatura e dalla pressione, con la costante di gas perfetto adimensionale uguale a 1
end do
end subroutine integ_time



! Questa subroutine calcola la norma L2 dei residui, che è una misura della convergenza della soluzione. 
! La norma L2 dei residui è definita come la radice quadrata della media dei quadrati dei residui, pesata per l'area degli elementi.
! Viene anche calcolata la norma L2 dell'entropia, che è una misura della qualità della soluzione in termini di conservazione dell'entropia.
subroutine compute_norm_residuals
use variabili
implicit none
integer::i
real(4)::areatot
! la riga seguente serve a definire un array di 4 elementi per la norma L2 dei residui, 
! che corrispondono alle 4 variabili conservative (densità, energia totale, quantità di moto in x, quantità di moto in y)
20 format ('Norm-2 residuals = ',e10.3,4x,e10.3,4x,e10.3,4x,e10.3,4x)

areatot = 0.0         ! inizializzo la variabile che conterrà l'area totale della mesh, che mi serve per normalizzare la norma L2 dei residui
norm2_residuals = 0.0 ! inizializzo la variabile che conterrà la norma L2 dei residui, che è un array di 4 elementi per le 4 variabili conservative

do i = 1, nele_interni
    norm2_residuals(:) = norm2_residuals(:) + ele(i)%d_dt**2 * ele(i)%area 
    ! in sostanza norm2_residuals(:) è la somma dei quadrati dei residui, pesata per l'area degli elementi, 
    ! quindi alla fine del loop avremo la somma dei quadrati dei residui per tutta la mesh, pesata per l'area totale della mesh
    areatot = areatot + ele(i)%area ! dato che costruisco in modo iterativo la soluzione parto da un'area nulla poichè non ho ancora celle
                                    ! e poi l'area aumenta man mano che aggiungo celle alla mesh.
end do

norm2_residuals(:) = sqrt(norm2_residuals(:) / areatot) ! normalizzo la norma L2 dei residui dividendo per l'area totale della mesh e prendendo la radice quadrata,
! in modo da avere una misura della convergenza che non dipende dalla dimensione della mesh
write(*,20) norm2_residuals ! stampo la norma L2 dei residui, che è un array di 4 elementi per le 4 variabili conservative
end subroutine compute_norm_residuals



! Questa subroutine calcola la norma L2 dell'entropia, che è una misura della qualità della soluzione in termini di conservazione dell'entropia.
! La norma L2 dell'entropia è definita come la radice quadrata della media dei quadrati dell'entropia, pesata per l'area degli elementi. 
! Viene anche scritto un file norms.txt che contiene sia la norma L2 dei residui che la norma L.
subroutine compute_norm_entropy
use variabili
implicit none
integer::i
real(4)::areatot, norm2_entropy
character(len=300)::norms_file

norm2_entropy = 0.0 ! inizializzo la variabile che conterrà la norma L2 dell'entropia, che è una misura della qualità della soluzione in termini di conservazione dell'entropia
areatot = 0.0       ! inizializzo la variabile che conterrà l'area totale della mesh, che mi serve per normalizzare la norma L2 dell'entropia

do i = 1, nele_interni
    norm2_entropy = norm2_entropy + ele(i)%S**2 * ele(i)%area
    ! in sostanza norm2_entropy è la somma dei quadrati dell'entropia, pesata per l'area degli elementi,
    ! quindi alla fine del loop avremo la somma dei quadrati dell'entropia per tutta la mesh, pesata per l'area totale della mesh
    areatot = areatot + ele(i)%area
end do

norm2_entropy = sqrt(norm2_entropy / areatot)
write(*,*) 'Norm2_entropy = ', norm2_entropy



! [MODIFICA 2026-05-06] norms.txt e' scritto nella cartella della singola
! simulazione, cosi' piu' processi paralleli non condividono lo stesso file.
call build_path(output_dir, 'norms.txt', norms_file)
open(unit=1, file=trim(norms_file), status='replace', action='write')
write(1,*) norm2_residuals, norm2_entropy
close(1)
end subroutine compute_norm_entropy
