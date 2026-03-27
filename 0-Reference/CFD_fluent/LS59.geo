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

Plane Surface(1) = {1,2};


Periodic Line {-7} = {1};
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

Field[3] = Min;
Field[3].FieldsList = {2};
Background Field = 3;





//Define Boundary Layer
Field[4] = BoundaryLayer;
Field[4].EdgesList = {9};
Field[4].hwall_n = 0.001;
Field[4].thickness = 0.05;
Field[4].ratio = 1.2;
Field[4].Quads = 1;
BoundaryLayer Field = 4;
 


Physical Surface(1) = 1;
Physical Line(99) = {9};
Physical Line(50) = {5,6,7};
Physical Line(40) = {1,2,3};
Physical Line(2) = {8};
Physical Line(3) = {4};


