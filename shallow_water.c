#include <stdio.h>


#define CELLCOUNT 50





int main (void) 
{	
	// Defining constant parameters
	int const model_length = 1;
	double const lambda = 0.05;
	double const T = 0.5;
	double const g = 9.82;
	
	double dx = model_length/CELLCOUNT;
	double dt = lambda*dx;
	int Ntimesteps = 30;
	



	return 0;
}
