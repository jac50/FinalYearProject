//-----------------------------------------------------
//-----------------------------------------------------
//--                Function Name: TDEV              --
//--                Name: Time Deviation             --
//--           Input: nTo - position in list         --
//--                  N   - number of samples        -- 
//--                  x   - vector of samples        --
//--           Output : time deviation               --
//-----------------------------------------------------/
//-----------------------------------------------------
#include <math.h>
#include <stdio.h>
#include <R.h>

void TDEV(int To, int* n, int* N ,double * x,double * result){
	
	int window = 5; // Set window Size
	int windowSide =  (window - 1) / 2; // Set the length of Side of window
	double outerStep =  0; 
	
	double interimStep = 0;
	double average[3] = {0,0,0};
	int i = 0;
	for (i=windowSide; i <= (*N -(3 * (*n))) - windowSide + 2; i++){
		for (int k=0;k < window ;k++){
			average[0] = average[0] + x[i + 2*(*n) - windowSide + k - 1];
			average[1] = average[1] + x[i + (*n) - windowSide + k - 1];
			average[2] = average[2] + x[i - windowSide + k - 1];
		}
		average[0] = average[0] / window;
		average[1] = average[1] / window;
		average[2] = average[2] / window;			
		Rprintf("Second Average: %f\n", average[1]); 
		interimStep = average[0] - (2 * average[1]) + average[2];
		
		//printf("InterimStep: %0.9f", interimStep * interimStep);
		outerStep = outerStep + (interimStep * interimStep);
		average[0] = average[1] = average[2] = 0;
		interimStep = 0;
	}
	if (i == windowSide) printf("I am here..\n");
	outerStep = outerStep / (6 * (*N - (3)*(*n) + 1));
	*result = sqrt(outerStep);

}

