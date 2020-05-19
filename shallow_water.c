#include <stdio.h>
#include <math.h>


#define M_PI acos(-1.0) //pi  

/*
 * Shallow Water Equations 2D. Hardcoded for square regions with square cells.
 * 
 * 2020-05-15 
 *
 * Author: Elias Olofsson (tfy17eon@cs.umu.se)
 *
 */

// State vector
typedef struct u {
	double h;
	double q; 
	double r; 
} u_vector;

double init_func(double x, double y) 
{
	double value;
	if ((x > 0.4) && (x < 0.6) && (y > 0.4) && (y < 0.6)) {
		value = 1.5;
	} else {
		value = 1;
	}
	return value; 
}
 
/* 
void set_initcond ()
{
	
} 
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
	
	
	u_vector u[CELLCOUNT+2][CELLCOUNT+2];

	for (int i = 0; i < CELLCOUNT+2; i++) {
		for (int j = 0; j < CELLCOUNT+2; j++) {
			u[i][j].h = 
			u[i][j].q = 2; 
			u[i][j].r = 3;
		}
	}	
	
	// Set Initial conditions	
	// Main loop
	
/*	for (int i = 0; i < Ntimesteps; 1++) {
	
		// calc ghost cell
	}*/
	
	return 0;
}
