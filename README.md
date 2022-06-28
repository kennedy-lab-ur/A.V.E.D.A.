# A.V.E.D.A.
User friendly computational chemistry application for assessment of reactions in the presence of optimally oriented electric fields.

Note A.V.E.D.A. is only compatible with SLURM organized super computers by default however all scripts are open source and may be ajusted for other cluster organizations. All scripts are written in Python 3 and bash.

# Running A.V.E.D.A. 
After downloading Aveda, one must navigate to the Program's super folder and run:
```chmod -R 777 Program```
to change permissions on the scripts.

To initate an A.V.E.D.A. instance, ensure both intermediate and transistion state .xyz files are in a folder with the *Program* folder and *start.sh*. A user must specify the following criteria in the start command for a successful run. As all information is crucial, if any of the parameters are missing A.V.E.D.A. will fail to run. A run may be started by running: ```sh ./start.sh ts_filename.xyz int_filename. xyz charge multiplicity functional basis_set atom_reordering_method [0,1, or 2] computation_name number_of_processors SLURM_partition_name``` in a terminal navigated to the folder containing the previously noted files.

Note special characters such as ( should be preceeded by \ for example 6-31G(d) should be input as ```6-31G\(d\)```

# General Workflow 
After instantiation, a copy of the *Program* folder will be copied and labled with the computation_name. Input files will be optimized at the input level of theory. Next, the intermediate and transistion state are aligned and reordered by the selected atom_reordering_method. Then cartesian coordinate and zmatrix single point calculations will be performed. The cartesian coordinates are converted to a z-matrix using the gaussian utility newzmat. Dipole moments are tracked from cartesian to z-matrix space using a rotation matrix and the ts-intermediate dipole difference is translated from cartesian coordinates of the aligned structures to the new orientation in z-matrix space. Recursive electric fields are applied along the dipole difference vector and the intemeiate and transition states are optimized beginning with the structure converged in the previous field. After all optimizations are complete, energies are extracted, converted to kcal/mol and plotted in Python.

For a more detailed explination, please see the corresponding paper published in _ or the commented code.
