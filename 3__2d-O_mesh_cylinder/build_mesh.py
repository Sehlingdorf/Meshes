#! /share/fe00fx11/anaconda/4.3.0-python3.6/bin/python3.6
# Kattmann, 05.2018, python 3.6
#
# Requires: .su2 meshes for each zone in current dir, or .geo files
# Optional: gmsh .geo files for each zone seperatly in the dir, the .su2
#           meshes are then created by setting "create_zone_meshes" to 1
# Output: .su2 mesh with multiple zones
#
# TODO create Parser such that mesh names can be parsed via command line
#-------------------------------------------------------------------#
import subprocess
#-------------------------------------------------------------------#
# enter the names of .geo files here, without .geo -ending
geo_files = ['O_mesh_cylinder']
#geo_files = ['channel_only','top_block_only']
#geo_files = ['channel_only','bottom_block_only']
# output filename
out_mesh_name = 'O_mesh_cylinder.su2'
# mesh dimension
ndim = 2
create_zone_meshes = True

#-------------------------------------------------------------------#
# Create .su2 meshes out of .geo files with gmsh
if create_zone_meshes:
  for file in geo_files:
    create_mesh = ['gmsh', file+'.geo', '-2', '-f', 'su2', '-o', file+'.su2']
    #create_mesh = ['gmsh', file+'.geo', '-2', '-f', 'su2', '-saveall', '-o',  file+'.su2']
    
    process = subprocess.check_output(create_mesh, stderr=subprocess.STDOUT)
  print("Meshes for each zone created.")

print("Input files:")
for idx,file in enumerate(geo_files): print(str(idx+1) + ". " + file)
print("Output mesh: ", out_mesh_name)
