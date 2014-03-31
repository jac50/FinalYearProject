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

void MATIEAllMethods(int To, int* n, int* N ,double * x,double * tempResultMATIE,double * tempResultMAFE, double * tempResultMinMATIE, double * tempResultMinMAFE){
	int window = 5; // Set window Size
	int windowSide =  (window - 1) / 2; // Set the length of Side of window
	double outerStep[4] = {0.0,0.0,0.0,0.0}; 
	double minimum[2] = {10000,10000};	
	double interimStep[4][*N - (2 * (*n)) + 10];
	double average[2] = {0.0,0.0};
	for (int i=windowSide; i <= (*N -(2 * (*n))) - windowSide + 2; i++){
 		for (int j=i + windowSide; j < *n + i - 1 - 1 ; ) { // - 1 as normal. - 1 for index difference
			for (int k=0;k < window ;k++){
				average[0] = average[0] + x[i + (*n) - windowSide + k - 1];
				average[1] = average[1] + x[i - windowSide + k - 1];
				if (x[i + (*n) - windowSide + k - 1] < minimum[0]) minimum[0] = x[i + (*n) - windowSide + k - 1];
				if (x[i- windowSide + k - 1] < minimum[1] ) minimum[1] = x[i - windowSide + k - 1];
			
			}
		}
		for (int j = 0; j < 2; j++) {
			average[j] = average[j] / window;
		}
		
		for (int k = 0; k < 2; k++) interimStep[k][i] = abs(interimStep[k][i]) / *n;
		interimStep[0][i] = average[0] + average[1];
		interimStep[1][i] = interimStep[0][i] / (*n * (To));
		interimStep[2][i] = minimum[0] + minimum[1];
		interimStep[3][i] = interimStep[2][i] / (*n * (To));
		
		average[0] = average[1] = 0;
		minimum[0] = minimum[1] = 10000.00;
		for (int k = 0; k < 4; k ++)	if (interimStep[k][i] < *tempResultMATIE) *tempResultMATIE = interimStep[k][i];
		
	}

}

