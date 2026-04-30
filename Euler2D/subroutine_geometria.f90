subroutine compute_center_ele(i) ! questa subroutine calcola il baricentro dell'elemento i e lo salva nella variabile ele(i)%x0, 
                                 ! che è un array di dimensione 2 che contiene le coordinate x e y del baricentro
use variabili ! questa è la dichiarazione per poter accedere alle variabili globali, ad esempio ele e nodo
implicit none
integer::i,j ! variabile intera che rappresenta l'indice dell'elemento di cui vogliamo calcolare il baricentro

! in questa subroutine si calcola il baricentro dell'elemento facendo la media aritmetica delle coordinate dei noti dell'ele
ele(i)%x0=0. ! inizializza il baricentro a zero, in questo modo possiamo sommare le coordinate dei nodi senza doverci preoccupare di sovrascrivere valori precedenti

do j=1,ele(i)%nnodi ! ciclo che va da 1 al numero di nodi dell'elemento i, ad esempio 3 per un triangolo o 4 per un quadrilatero
 ele(i)%x0=nodo(ele(i)%nodi(j))%x+ele(i)%x0 ! somma le coordinate del nodo j dell'elemento i al baricentro, ad esempio se il nodo j 
                                            ! ha coordinate (x,y) allora aggiungiamo x a ele(i)%x0(1) e y a ele(i)%x0(2)
end do

ele(i)%x0= ele(i)%x0/ele(i)%nnodi ! alla fine del ciclo, dividiamo il baricentro per il numero di nodi dell'elemento per ottenere la media aritmetica, 
                                  ! ad esempio se abbiamo un triangolo con nodi (x1,y1), (x2,y2), (x3,y3) allora il baricentro sarà ((x1+x2+x3)/3, (y1+y2+y3)/3)

end subroutine



subroutine compute_area_ele(i) ! questa subroutine calcola l'area dell'elemento i e la salva nella variabile ele(i)%area
use variabili
implicit none
integer::i ! variabile intera che rappresenta l'indice dell'elemento di cui vogliamo calcolare l'area
real::a,b,c,d,f,At1,At2,p1,p2 ! variabili reali che rappresentano le lunghezze dei lati dell'elemento (a,b,c,d), 
                              ! l'area dei triangoli che compongono il quadrilatero (f,At1,At2) e i semiperimetri (p1,p2)

!Calcolare l'area dell'elemento:
! * se è un triangolo con lati di lunghezza a,b,c e semiperimetro p1=0.5*(a+b+c) usare la formula di Erone At=sqrt(p1*(p1-a)*(p1-b)*(p1-c))
! * se è un quadrilatero calcolare la sua area come somma dei due triangoli che lo compongono, usando la formula di Erone su ciascuno

if (ele(i)%nnodi == 3) then ! se l'elemento ha 3 nodi, allora è un triangolo e possiamo calcolare l'area direttamente con la formula di Erone

 a = sqrt((nodo(ele(i)%nodi(1))%x(1)-nodo(ele(i)%nodi(2))%x(1))**2 + (nodo(ele(i)%nodi(1))%x(2)-nodo(ele(i)%nodi(2))%x(2))**2)
 b = sqrt((nodo(ele(i)%nodi(2))%x(1)-nodo(ele(i)%nodi(3))%x(1))**2 + (nodo(ele(i)%nodi(2))%x(2)-nodo(ele(i)%nodi(3))%x(2))**2)
 c = sqrt((nodo(ele(i)%nodi(3))%x(1)-nodo(ele(i)%nodi(1))%x(1))**2 + (nodo(ele(i)%nodi(3))%x(2)-nodo(ele(i)%nodi(1))%x(2))**2)

 p1 = (a+b+c)*0.5 ! calcola il semiperimetro del triangolo, che è la metà della somma dei lati
 ele(i)%area=sqrt(p1*(p1-a)*(p1-b)*(p1-c)) ! calcola l'area del triangolo con la formula di Erone, che è la radice quadrata del prodotto tra il semiperimetro e la differenza tra il semiperimetro e ciascun lato


else ! se l'elemento ha 4 nodi, allora è un quadrilatero e dobbiamo calcolare l'area come somma dei due triangoli che lo compongono, ad esempio i triangoli (1,2,3) e (1,3,4)

 a = sqrt((nodo(ele(i)%nodi(1))%x(1)-nodo(ele(i)%nodi(2))%x(1))**2 + (nodo(ele(i)%nodi(1))%x(2)-nodo(ele(i)%nodi(2))%x(2))**2)
 b = sqrt((nodo(ele(i)%nodi(2))%x(1)-nodo(ele(i)%nodi(3))%x(1))**2 + (nodo(ele(i)%nodi(2))%x(2)-nodo(ele(i)%nodi(3))%x(2))**2)
 c = sqrt((nodo(ele(i)%nodi(4))%x(1)-nodo(ele(i)%nodi(3))%x(1))**2 + (nodo(ele(i)%nodi(4))%x(2)-nodo(ele(i)%nodi(3))%x(2))**2)
 d = sqrt((nodo(ele(i)%nodi(4))%x(1)-nodo(ele(i)%nodi(1))%x(1))**2 + (nodo(ele(i)%nodi(4))%x(2)-nodo(ele(i)%nodi(1))%x(2))**2)
 f = sqrt((nodo(ele(i)%nodi(3))%x(1)-nodo(ele(i)%nodi(1))%x(1))**2 + (nodo(ele(i)%nodi(3))%x(2)-nodo(ele(i)%nodi(1))%x(2))**2)

 p1 = (a+b+f)*0.5 ! calcola il semiperimetro del primo triangolo, che è la metà della somma dei lati
 At1 = sqrt(p1*(p1-a)*(p1-b)*(p1-f)) ! calcola l'area del primo triangolo con la formula di Erone

 p2 = (c+d+f)*0.5 ! calcola il semiperimetro del secondo triangolo, che è la metà della somma dei lati
 At2 = sqrt(p2*(p2-c)*(p2-d)*(p2-f)) ! calcola l'area del secondo triangolo con la formula di Erone

 ele(i)%area=At1+At2 ! l'area del quadrilatero è la somma delle aree dei due triangoli che lo compongono

end if

end subroutine





subroutine compute_length_inte(i) ! questa subroutine calcola la lunghezza dell'interfaccia i e la salva nella variabile interf(i)%length
use variabili
implicit none
integer::i

! Calcolare la lunghezza dell'interfaccia usando Pitagora sulle coordinate dei nodi 1 e 2 dell'interfaccia

interf(i)%length = sqrt((nodo(interf(i)%nodo1)%x(1)-nodo(interf(i)%nodo2)%x(1))**2 + (nodo(interf(i)%nodo1)%x(2)-nodo(interf(i)%nodo2)%x(2))**2 )

end subroutine


subroutine compute_normal_inte(i) ! questa subroutine calcola la normale all'interfaccia i e la salva nella variabile interf(i)%normal, 
                                 ! che è un array di dimensione 2 che contiene le componenti x e y della normale
use variabili
implicit none
integer::i ! variabile intera che rappresenta l'indice dell'interfaccia di cui vogliamo calcolare la normale
real::tx,ty ! variabili reali che rappresentano le componenti x e y del versore tangente all'interfaccia, che useremo per calcolare la normale

call compute_length_inte(i)

!in questa subroutine si calcola la normale all'interfaccia i. calcolare il versore tangente (tx,ty) e poi calcolare la normale ad esso perpendicolare nx=-ty; ny=tx

tx = (nodo(interf(i)%nodo2)%x(1)-nodo(interf(i)%nodo1)%x(1))/interf(i)%length !sqrt((nodo(interf(i)%nodo1)%x(1)-nodo(interf(i)%nodo2)%x(1))**2 + (nodo(interf(i)%nodo1)%x(2)-nodo(interf(i)%nodo2)%x(2))**2 )
ty = (nodo(interf(i)%nodo2)%x(2)-nodo(interf(i)%nodo1)%x(2))/interf(i)%length !sqrt((nodo(interf(i)%nodo1)%x(1)-nodo(interf(i)%nodo2)%x(1))**2 + (nodo(interf(i)%nodo1)%x(2)-nodo(interf(i)%nodo2)%x(2))**2 )


interf(i)%normal(1) = -ty ! la componente x della normale è uguale a -ty, che è la componente y del versore tangente, con segno negativo per avere la normale che punta verso l'esterno dell'elemento
interf(i)%normal(2) = tx ! la componente y della normale è uguale a tx, che è la componente x del versore tangente

end subroutine

