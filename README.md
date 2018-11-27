# README #

assemble.m, assemble_TO_fast.m and plotev.m based on code from Gary Froyland/Oliver Junge. 
Note the code is specialised to run on trajectory data of the form described in prep_data.m

### What is this repository for? ###

* Approximate dynamic laplacian, compute the eigenproblem and plot eigenvalues and eigenvectors.

### How do I get set up? ###

* Set paths to reflect location of data
* Run prep_data.m to create the cell array for the flow time
* Run setup_dyn_lap_sparse.m to compute eigenproblem and plot spectrum/eigenvectors
* Basic plotting code in plot_eigs.m

### Contribution guidelines ###

* Can be run on any 2D trajectory data. Data should be a cell array, p, where each cell represents time step and contains X and Y locations as column vectors
* Can be run for a static Laplacian eigenproblem if p is a cell array with a single cell and nt=1

### Who do I talk to? ###

* Chris Bladwell c.bladwell@unsw.edu.au
