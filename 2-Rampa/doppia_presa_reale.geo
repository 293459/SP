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
Point(10) = {0.832,0.426,0,lc};
Point(11) = {0.832,0.800,0,lc};
Point(12) = {-0.500,0.800,0,lc};

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
Line(11) = {11,12}; 
Line(12) = {12,1}; 

// Definizione Curve Chiuse Orientate
Line Loop(1) = {1,2,3,4,5,6,7,8,9,10,11,12};

// Definizione Superficie
Plane Surface(1) = {1} ; // si mette il numero della curva chiusa orientata

