//SetFactory("OpenCASCADE");
Mesh.MshFileVersion=2.2;
//Gmsh 3.0.7 delaunay for quad and blossom
Mesh.CharacteristicLengthExtendFromBoundary= 0;
lc=0.1;
 
Include "nozzle_points.txt";

Spline(1)={1:2010};
Line(2)={2010,2011};
Line(3)={2011,2012};
Line(4)={2012,1};

//Transfinite Line {4} = 3 Using Progression 1.;
//Transfinite Line {8} = 2 Using Progression 1.;
//Transfinite Line {9} = 2 Using Progression 1.;

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};
 
Recombine Surface {1};

Field[46] = Attractor;
Field[46].NodesList = {300};

Field[47] = Threshold;
Field[47].IField = 46;
Field[47].LcMin = 0.5*lc;
Field[47].LcMax = lc;
Field[47].DistMin = 0.5;
Field[47].DistMax = 1.;

Field[7] = Min;
Field[7].FieldsList = {47};
Background Field = 7;

Physical Surface(1) = {1};
Physical Line(2) = {4};
Physical Line(99) = {1,3};
Physical Line(3) = {2};

Mesh 2;
Save  "nozzle.msh";
//Save "my_stepfile.step";
Draw ;
Print Sprintf("nozzle.png");
Exit;
