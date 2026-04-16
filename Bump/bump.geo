Mesh.MshFileVersion = 2.2; 

// Definizione lunghezze caratteristiche 
L=1; // lungheza del domionio
h = 0.3; //altezza del dominio
lc = 0.05; // lunghezza caratteristica della mesh

// Definizione Rettangolo
Point(1) = {0,0,0,lc}; // volendo posso addensare la mesh in un punto specifico
Point(2) = {L,0,0,lc};
Point(3) = {L,h,0,lc};
Point(4) = {0,h,0,lc};

// Definizione Bump
Point(5) = {L/2,h/10,0,lc}; // massima altezza del bump
Point(6) = {L/2-L/8,0,0,lc};
Point(7) = {L/2+L/8,0,0,lc};

// Definizione Linee
Line(1) = {2,3}; 
Line(2) = {3,4}; 
Line(3) = {4,1}; 

// Definizione Spline per il bump
Spline(4) = {1,6,5,7,2};  // conviene mettere tutti i punti nella spline

// Definizione Curve Chiuse Orientate
Line Loop(1) = {1,2,3,4};

// Definizione Superficie
Plane Surface(1) = {1} ; // si mette il numero della curva chiusa orientata


// MESH STRUTTURATA
Transfinite Line {1} = 30 Using Progression 1.1; // 
// il primo valore è il numro di elementi di calcolo per linea
// il secondo valore è il growth factor geometrico
Transfinite Line {-3} = 30 Using Progression 1.1; // 
// il meno serve a far partire la serie geometrica dal lato opposto
Transfinite Line {2} = 60 Using Bump 3; //
// Using Bump è una progressione geometrica di tipo bump centrata
Transfinite Line {4} = 60 Using Bump 3; //
// Abbiamo addensato in basso perché ci sono gradienti maggiori
Transfinite Surface {1} = {1,2,3,4}; // di default è triangolare
Recombine Surface{1}; // trasforma i triangoli in rettangoli

// Assegnazione Tag per le Boundary Conditions
Physical Surface(1)= {1}; // assegnamo alla superficie 1 il tag 1 che è il DOMINIO
Physical Line(99)= {4,2}; // assegnamo alle linee 2,4 il tag 99 che significa WALL
Physical Line(2)= {3}; // assegnamo alle linee 2,4 il tag 2 che significa INLET
Physical Line(3)= {1}; // assegnamo alle linee 2,4 il tag 3 che significa OUTLET
