Mesh.MshFileVersion=2.2;
//lc = 0.08;
//lc = 0.04;
lc = 0.02;
passo=0.8333;

Point(1) = {-1., 0.5,0, lc};
Point(2) = {0.5, 0.5, 0, lc};
Point(3) = {1., -0.2, 0, lc};
Point(4) = {2.,-0.2, 0, lc};
Point(5) = {2., -0.2-passo, 0, lc};
Point(6) = {1., -0.2-passo, 0, lc};
Point(7) = {0.5, 0.5-passo, 0, lc};
Point(8) = {-1., 0.5-passo, 0, lc};

Include "punti_LS59.txt";

// La funzione punti serve per prendere i punti da un altro file txt senza andare a ricopiarli

Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,6};
Line(6)={6,7};
Line(7)={7,8};
Line(8)={8,1};


// prima di definire la superficie devo definire un loop, qui ne uso 2 perché poi andrò
// ad escludere l'interno della paletta

Line Loop(1) = {1:8} ; //dominio
Line Loop(2) = {9}; //paletta

Plane Surface(1) = {1,2};
//cosi la superficie da meshare è quella del line loop 1 - quella del line loop 2
Recombine Surface{1};


Periodic Line {-7} = {1};
Periodic Line {-6} = {2};
Periodic Line {-5} = {3};


//prende le linee che vogliono essere analoghe dal punto di vista delle condizioni
// di periodicita (il meno serve sempre per avere lo stesso verso == 7 l'avevo definito al
//contrario rispetto alla linea 1 

Field[1] = Attractor;
Field[1].EdgesList = {9};
// 9 è la spline dche definisce la pala

Field[2] = Threshold;
Field[2].IField = 1; // threshold definito a coppia con un attractor qui 1 quello della pala
//Field[2].LcMin = 0.02;

//Field[2].LcMin = 0.01;
Field[2].LcMin = 0.005;

Field[2].LcMax = lc;
Field[2].DistMin = 0.3;
Field[2].DistMax = 0.6;

Field[3] = Min; // quando ho piu di un background field possibili serve prendere poi il minimo
Field[3].FieldsList = {2};
Background Field = 3;


// cerco di creare una griglia strutturata cartesiana attorno al profilo per poter 
// valutare nella simulazione lo strato limite (forti gradienti nello strato limite)



//Define Boundary Layer

//Field[4] = BoundaryLayer; //creo un field nuovo
//Field[4].EdgesList = {9}; // bordo da usare per creare la mesh di strato limite
//Field[4].hwall_n = 0.001; 

// questo parametro è la lunghezza caratteristica del 1 elemento a parete ( 1 cella)
//Field[4].thickness = 0.05;
// spessore dall'inizio alla fine della griglia di di strato limite

//Field[4].ratio = 1.2;
// ratio fa come using progression:mesh sarà piu fitta a parete, successivamente la lunghezza
// caratteristica aumenta con fattore moltiplicativo 1.2

//Field[4].Quads = 1;
// impongo che gli elementi della griglia strutturata sia fatta da quadrilateri
//BoundaryLayer Field = 4;



Physical Surface(1) = 1;
Physical Line(99) = {9};
Physical Line(50) = {5,6,7};
Physical Line(40) = {1,2,3};
Physical Line(2) = {8};
Physical Line(3) = {4};


// ancora una volta dobbiare dire al codice cfd cosa rappresentano 
// le linee (2 inlet,3 outlet, 99 parete no slip, 40 bordo periodico (Line 1,2,3)
// bordo 50 ho periodicità al borod inferiore