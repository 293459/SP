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


// MESH NON STRUTTURATA

// Attrattori 
Field[1] = Attractor; // la tipologia del Field 1 è attractor
// definisco un campo di distanza
Field[1].EdgeList = {4}; // La linea 4 fa parte del Field 1 quindi la linea è un attrattore
// specifico che la distanza dal più vicino punto 
// se ci sono delle linee considera tutti i punti della linea
// se ci sono più linee considera ogni punto di ogni linea

Field[2] = Threshold; // la tipologia è Threshold
Field[2].IField = 1; // I = input dle campo
Field[2].LcMin = lc*0.1; // dimensione minima della mesh
Field[2].LcMax = lc*0.5; // dimensione massima della mesh
Field[2].DistMin = h/4; // distanza minima della mesh
Field[2].DistMax = h/2; // distanza massima della mesh
// potrei mettere altri campi con altri attrattori Field[3]ad esempio
// potrei poi decidere di definire un campo minimo tra gli attrattori 
 
Background Field = 2 ; // il campo che ho scelto effettivamente 

Recombine Surface{1}; // lo converto in rettangoli