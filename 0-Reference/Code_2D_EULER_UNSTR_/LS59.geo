Mesh.MshFileVersion=2.2;
lc = 1;
passo=0.8333;

Point(1) = {-1., 0.5,0, lc};
Point(2) = {0.5, 0.5, 0, lc};
Point(3) = {1., -0.2, 0, lc};
Point(4) = {2.,-0.2, 0, lc};
Point(5) = {2., -0.2-passo, 0, lc};
Point(6) = {1., -0.2-passo, 0, lc};
Point(7) = {0.5, 0.5-passo, 0, lc};
Point(8) = {-1., 0.5-passo, 0, lc};

Include "punti_LS59.txt";  // ci permette di inserire il contenuto di un file esterno evitando di ricopiare i dati


Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,6};
Line(6)={6,7};
Line(7)={7,8};
Line(8)={8,1};



// creiamo due line loop per definire superficie interna e superficie interna a paletta
Line Loop(1) = {1:8} ; 
Line Loop(2) = {9};  

Plane Surface(1) = {1,2}; // 1,2 riconosce che la mesh deve essere fatta nel dominio interno a linea 1 a meno di superficie contenuta da linea 2


Periodic Line {-7} = {1};  // - per aggiustare gli indici vogliamo infatti che la linea 7 sia periodica come la linea 1 --> devono rispettare la condizione di periodicità
Periodic Line {-6} = {2};
Periodic Line {-5} = {3};


// definiamo degli attractor che vede come spline la linea che definisce il profilo
Field[1] = Attractor;
Field[1].EdgesList = {9};

Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 0.02; 
Field[2].LcMax = 0.07; 
Field[2].DistMin = 0.4;
Field[2].DistMax = 0.6;

Field[3] = Min;
Field[3].FieldsList = {2};
Background Field = 3; // field in uscita minimo dei threshold 

//Recombine Surface{1};




// dato che ci aspettiamo uno strato limite realizziamo una griglia strutturata su strato limite
// vogliamo infatti catturare al meglio i gradienti presenti nel profilo di strato limite
//Define Boundary Layer
//Field[4] = BoundaryLayer; // questo field ha bisogno di definire dei bordi
//Field[4].EdgesList = {9}; // profilo pala
//Field[4].hwall_n = 0.001;  // lunghezza caratteristica del primo elemento di parete
//Field[4].thickness = 0.05;  // spessore del profilo di griglia di strato limite
//Field[4].ratio = 1.2; // ratio fa esattamente quello che fa UsingProgression
//Field[4].Quads = 1; // questa griglia di strato limite la voglio di elementi quadrangolari 
//BoundaryLayer Field = 4; 


// tag fisici della nostra mesh
Physical Surface(1) = 1; // interni mesh
Physical Line(99) = {9}; // bordo --> no slip
Physical Line(50) = {5,6,7}; // elementi 1D che si trovano su bordo periodico inferiore
Physical Line(40) = {1,2,3}; // elementi 1D che si trovano su bordo periodico superiore
Physical Line(2) = {8}; // inlet
Physical Line(3) = {4}; // outlet


