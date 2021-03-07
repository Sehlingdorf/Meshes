// ----------------------------------------------------------------------------------- //
// Kattmann 20.08.2018, O mesh for CHT vortex shedding behind cylinder
// The O mesh around the cylinder consists out of two half cylinders.
// The inner pin is hollow.
// ----------------------------------------------------------------------------------- //

// Which domain part should be handled
Which_Mesh_Part= 2;// 0=all, 1=Fluid, 2=Solid
// Evoque Meshing Algorithm?
Do_Meshing= 1; // 0=false, 1=true
// Write Mesh files in .su2 format
Write_mesh= 0; // 0=false, 1=true

//Geometric inputs
cylinder_diameter = 1;
cylinder_radius = cylinder_diameter/2;
mesh_radius = 20 * cylinder_diameter;
inner_pin_d = 0.5;

// ----------------------------------------------------------------------------------- //
//Mesh inputs
gridsize = 0.01;
Ncylinder = 202/2;
Nradial = 112;
Rradial = 1.06;

NPinRadial = 10;
RPinRadial = 1.03;

// Each zone is self-sufficient (i.e. has all of its own Points/Lines etc.)
// ----------------------------------------------------------------------------------- //
// Fluid zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 1)

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

EndIf

// ----------------------------------------------------------------------------------- //
// Pin zone
If (Which_Mesh_Part == 0 || Which_Mesh_Part == 2)

     // Geometry definition
    // Points
    Point(11) = {-mesh_radius, 0, 0, gridsize};
    Point(12) = {-inner_pin_d, 0, 0, gridsize};
    Point(13) = {inner_pin_d, 0, 0, gridsize};
    Point(14) = {mesh_radius, 0, 0, gridsize};
    Point(15) = {0, 0, 0, gridsize};

EndIf
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