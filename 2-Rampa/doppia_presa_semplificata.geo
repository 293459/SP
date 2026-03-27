Mesh.MshFileVersion = 2.2; 

// Definizione lunghezze caratteristiche 
lc = 1; 

// Definizione Punti
Point(1) = {-0.5,0,0,lc}; 
Point(2) = {-0.45,0,0,lc};
Point(3) = {0,0,0,lc};
Point(4) = {0.353,0.0623,0,lc};
Point(5) = {0.720,0.207,0,lc}; 
Point(6) = {1,0.204,0,lc};
Point(7) = {1,0.310,0,lc};
Point(8) = {0.797,0.310,0,lc};
Point(9) = {0.617,0.280,0,lc}; 
Point(10) = {0.617,0.800,0,lc}; // sopra il punto 9, stessa y di 11, stessa x di 9
Point(11) = {-0.500,0.800,0,lc}; // stesso punto ma rinominato da 12 a 11

// Definizione Linee
Line(1) = {1,2}; 
Line(2) = {2,3}; 
Line(3) = {3,4}; 
Line(4) = {4,5}; 
Line(5) = {5,6}; 
Line(6) = {6,7}; 
Line(7) = {7,8}; 
Line(8) = {8,9}; 
Line(9) = {9,10}; 
Line(10) = {10,11}; 
Line(11) = {11,1}; 

// Definizione Curve Chiuse Orientate
Line Loop(1) = {1,2,3,4,5,6,7,8,9,10,11};

// Definizione Superficie
Plane Surface(1) = {1} ; // si mette il numero della curva chiusa orientata

// Attrattori 
Field[1] = Attractor; // la tipologia del Field 1 è attractor
// definisco un campo di distanza scalare rispetto a ciò che indico nella riga successiva
Field[1].EdgesList = {3,4,5,6,7,8}; // voglio infittire la mesh in queste zone per gli urti e la geometria
// capisce che sto prendendo le linee e non i punti perché uso "Edge"
// se sono più di 1 lato bisogna scrivere "Edges" non "Edge"


Field[2] = Threshold; // la tipologia è Threshold
Field[2].IField = 1; // I = input dle campo
Field[2].LcMin = lc*0.05; // dimensione minima della mesh
Field[2].LcMax = lc*0.1; // dimensione massima della mesh
Field[2].DistMin = lc/4; // distanza minima della mesh
Field[2].DistMax = lc/2; // distanza massima della mesh
// potrei mettere altri campi con altri attrattori Field[3]ad esempio
// potrei poi decidere di definire un campo minimo tra gli attrattori 
 
Background Field = 2 ; // il campo che ho scelto effettivamente 

Recombine Surface{1}; // lo converto in rettangoli