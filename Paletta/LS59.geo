Mesh.MshFileVersion=2.2;
lc = 1;
passo=0.8333;

// Definizione del dominio
Point(1) = {-1., 0.5,0, lc};
Point(2) = {0.5, 0.5, 0, lc};
Point(3) = {1., -0.2, 0, lc};
Point(4) = {2.,-0.2, 0, lc};
Point(5) = {2., -0.2-passo, 0, lc};
Point(6) = {1., -0.2-passo, 0, lc};
Point(7) = {0.5, 0.5-passo, 0, lc};
Point(8) = {-1., 0.5-passo, 0, lc};

// inclusione modulare della geometria della turbina
// si può cambiare la chiamata ed usare un paletta diversa
// il file così è chiamato correttamente solo se nella stessa directory
Include "punti_LS59.txt";

Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,6};
Line(6)={6,7};
Line(7)={7,8};
Line(8)={8,1};




Line Loop(1) = {1:8} ;
Line Loop(2) = {9};

// sottrazione tra superfici ovvero 1-2
Plane Surface(1) = {1,2};

// servono ad evitare di analizzare tutte le palette della schiera
// analizziamo solo una restizione del dominio che contiene una sola paletta
// imponiamo poi delle condizioni al contorno periodiche
// il meno serve a mantere i flussi coeerenti con la normale
// imponendo questa condizione la dimensione tra i 2 boundaries coincide
Periodic Line {-7} = {1}; // cioè che entra nella linea 1 esce dalla linea 7 e viceversa
Periodic Line {-6} = {2};
Periodic Line {-5} = {3};



Field[1] = Attractor;
Field[1].EdgesList = {9};

Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 0.01;
Field[2].LcMax = 0.05;
Field[2].DistMin = 0.25;
Field[2].DistMax = 0.5;

Field[3] = Min; // qui specifico che volio un campo di tipo minimo
Field[3].FieldsList = {2}; // qua dico di quali campi fare il minimo
// chiaramente qui non ha senso fare il minimo di un solo campo
// ovviamente il minimo di un campo è sè stesso
// serviva solo a farci vedere il comando
Background Field = 3; // il campo di background è il campo minimo numero 3





//Define Boundary Layer
Field[4] = BoundaryLayer;
Field[4].EdgesList = {9}; // dove c'è il boundary layer
Field[4].hwall_n = 0.001; // dimensione caratteristica della prima cella
Field[4].thickness = 0.05;// spessore strato limite
Field[4].ratio = 1.2; // tasso di crescita della dimensione della mesh
Field[4].Quads = 1; // meglio i quad perché il flusso è allineato all'interfaccia
BoundaryLayer Field = 4;
 


Physical Surface(1) = 1;
Physical Line(99) = {9};
Physical Line(50) = {5,6,7};
Physical Line(40) = {1,2,3};
Physical Line(2) = {8};
Physical Line(3) = {4};


