// ----------------------------------------------------------------------------------- //
// Kattmann 20.08.2018, O mesh for vortex shedding behind cylinder
// The O mesh around the cylinder consists out of two half cylinders
// ----------------------------------------------------------------------------------- //

// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

//Geometric inputs
cylinder_diameter = 1;
cylinder_radius = cylinder_diameter/2;
mesh_radius = 20 * cylinder_diameter;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.01;
Ncylinder = 202/2;
Nradial = 112;
Rradial = 1.06;

// ----------------------------------------------------------------------------------- //
// Geometry definition
// Points
Point(1) = {-mesh_radius, 0, 0, gridsize};
Point(2) = {-cylinder_radius, 0, 0, gridsize};
Point(3) = {cylinder_radius, 0, 0, gridsize};
Point(4) = {mesh_radius, 0, 0, gridsize};
Point(5) = {0, 0, 0, gridsize};

//helping point to know height of first layer
//Point(6) = {-cylinder_radius - 0.002, 0, 0, gridsize};

// Lines
Line(1) = {1, 2}; // to the left
Line(2) = {3, 4}; // to the right

Circle(3) = {2, 5, 3}; // lower inner
Circle(4) = {1, 5, 4}; // lower outer
Circle(5) = {3, 5, 2}; // upper inner
Circle(6) = {4, 5, 1}; // upper outer

// Lineloops and surfaces
Line Loop(1) = {1, 3, 2, -4}; Plane Surface(1) = {1}; // lower half cylinder
Line Loop(2) = {1, -5, 2, 6}; Plane Surface(2) = {2}; // upper half cylinder

// ----------------------------------------------------------------------------------- //
// Mesh definition
// make structured mesh with transfinite Lines

// lower
Transfinite Line{3, 4} = Ncylinder;
Transfinite Line{-1, 2} = Nradial Using Progression Rradial;

// upper
Transfinite Line{-5, -6} = Ncylinder;
Transfinite Line{-1, 2} = Nradial Using Progression Rradial;

// Physical Groups
Physical Line("cylinder") = {3, 5};
Physical Line("farfield") = {4, 6};
Physical Surface("surface_mesh") = {1, 2};

// ----------------------------------------------------------------------------------- //
Transfinite Surface "*";
Recombine Surface "*";

If (Do_Meshing == 1)
    Mesh 1; Mesh 2;
EndIf

// ----------------------------------------------------------------------------------- //
// Write .su2 meshfile
If (Write_mesh == 1)

    Mesh.Format = 42; // .su2 mesh format, 
    Save "O_mesh_cylinder.su2";

EndIf
