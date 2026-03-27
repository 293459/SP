SetFactory("OpenCASCADE");

Mesh.MshFileVersion=2.2;
lc = 1;

Point(1) = {-0.5, 0., 0, lc};
Point(2) = {-0.45, 0., 0, lc};
Point(3) = {0., 0., 0, lc};
Point(4) = {0.353,0.0623, 0, lc};
Point(5) = {0.72, 0.207, 0, lc};
Point(6) = {1., 0.204, 0, lc};
Point(7) = {1, 0.31, 0, lc};
Point(8) = {0.797, 0.31, 0, lc};
Point(9)={0.617,0.28,0,lc};
Point(10)={0.617,0.8,0,lc};
Point(11)={-0.5,0.8,0,lc};



Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,6};
Line(6)={6,7};
Line(7)={7,8};
Line(8)={8,9};
Line(9)={9,10};
Line(10)={10,11};
Line(11)={11,1};




Line Loop(1) = {1:11} ;



Plane Surface(1) = {1};





Field[1] = Attractor;
Field[1].EdgesList = {3:8};

Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 0.01;
Field[2].LcMax = 0.05;
Field[2].DistMin = 0.25;
Field[2].DistMax = 0.5;

Field[3] = Min;
Field[3].FieldsList = {2};
Background Field = 3;
 


Physical Surface(1) = 1;
Physical Line(99) = {1,2,3,4,5,7,8,10};
Physical Line(2) = {11};
Physical Line(3) = {6,9};


