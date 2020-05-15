#include <stdio.h>
#include <math.h>


/*
 * Shallow Water Equations 2D. Hardcoded for square regions with square cells.
 * 
 * 2020-05-15 
 *
 * Author: Elias Olofsson (tfy17eon@cs.umu.se)
 *
 */


int main (void) 
{	
	// Defining constant parameters
	int const CELLCOUNT = 50;			// Cell count per side.
	double const model_length = 1;			// Length of side.
	double const lambda = 0.05;			// lambda == dt/dx
	double const T = 0.5;				// Time to solve.
	double const g = 9.82;				// Gravity acceleration.

	// Calc the following parameters	
	double const dx = model_length/CELLCOUNT;	// dx == dy
	double const dt = lambda*dx;			// dt
	int const Ntimesteps = floor(T/dt);		// Nr of timesteps.
	
	// Vectors of cell centers
	double x_cc [CELLCOUNT];
	double y_cc [CELLCOUNT];
	for (int i = 0; i < CELLCOUNT; i++) {
		x_cc[i] = dx/2 + i*dx; 
		y_cc[i] = dx/2 + i*dx;
	}
	
	// Initial conditions	
	
	
	
	

	
	return 0;
}
