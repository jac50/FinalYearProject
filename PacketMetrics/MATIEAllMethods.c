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

void MATIEAllMethods(double *To, int* n, int* N ,double * x,double * tempResultMATIE,double * tempResultMAFE, double * tempResultMinMATIE, double * tempResultMinMAFE){
	int window = 5; // Set window Size
	int windowSide =  (window - 1) / 2; // Set the length of Side of window
	double minimum[2] = {10000,10000};	
	double interimStep[2][*N - (2 * (*n)) + 10];
	double average[2] = {0.0,0.0};
	for (int i=0; i <= (*N -(2 * (*n)))  + 1 -1; i++){
 		for (int j=i; j < *n + i - 1 - 1 ; j++) { // - 1 as normal. - 1 for index difference
			for (int k=0;k < window ;k++){
				average[0] = average[0] + x[j + (*n) - windowSide + k - 1];
				average[1] = average[1] + x[j - windowSide + k - 1];
				if (x[j + (*n) - windowSide + k - 1] < minimum[0]) minimum[0] = x[j + (*n) - windowSide + k - 1];
				if (x[j- windowSide + k - 1] < minimum[1] ) minimum[1] = x[j - windowSide + k - 1];
			
			}
		}
		for (int j = 0; j < 2; j++) {
			average[j] = average[j] / window;
		}
		
		interimStep[0][i] = (average[0] - average[1]) < 0 ? -((average[0] - average[1]) / *n) : ((average[0] - average[1]) / *n);
		interimStep[1][i] = (minimum[0] - minimum[1]) < 0 ? -(minimum[0] - minimum[1]) / *n : (minimum[0] - minimum[1]) / *n;
		average[0] = average[1] = 0;
		minimum[0] = minimum[1] = 10000.00;
		if (interimStep[0][i] > *tempResultMATIE) *tempResultMATIE = interimStep[0][i];
		if (interimStep[1][i] > *tempResultMinMATIE) *tempResultMinMATIE = interimStep[1][i];
		*tempResultMAFE = (double) *tempResultMATIE / (*n * (*To));
		*tempResultMinMAFE = (double) *tempResultMinMATIE / (*n * (*To));
		
	}

}

