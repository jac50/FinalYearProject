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

void MATIEAllMethods(int To, int* n, int* N ,double * x,double * tempResultTDEV,double * tempResultMinTDEV, double * tempResultBandTDEV, double * tempResultPercTDEV){
	int window = 5; // Set window Size
	int windowSide =  (window - 1) / 2; // Set the length of Side of window
	double outerStep[4] = {0.0,0.0,0.0,0.0}; 
	
	double interimStep[4][*N - (2 * (*n)) + 10];
	double average[3][2] = {{0,0,0},{0,0,0},{0,0,0}};
	for (int i=windowSide; i <= (*N -(2 * (*n))) - windowSide + 2; i++){
 		for (int j=i + windowSide; j < n + i - 1 - 1 ; ) { // - 1 as normal. - 1 for index difference
			for (int k=0;k < window ;k++){
				average[0][0] = average[0][0] + x[i + (*n) - windowSide + k - 1];
				average[0][1] = average[0][1] + x[i - windowSide + k - 1];
				if (x[i + (*n) - windowSide + k - 1] < minimum[0]) minimum[0] = x[i + (*n) - windowSide + k - 1];
				if (x[i- windowSide + k - 1] < minimum[1] ) minimum[1] = x[i - windowSide + k - 1];
			
			}
		}
		for (int j = 0; j < 2; j++) {
			average[0][j] = average[0][j] / window;
		}
		
		for (int k = 0; k < 2; k++) interimStep[k] = abs(interimStep[k]) / n;
		interimStep[0][i] = average[0][0] + average[0][1];
		interimStep[1][i] = interimStep[0][i] / (*n * *To);
		interimStep[2][i] = minimum[0] + minimum[1];
		imtermStep[3][i] = interimStep[2][i] / (*n * *To);
		
		for (int i = 0; i < 4; i++) average[i][0] = average[i][1] = average[i][2] = 0;
	}
	//work out max here

	*tempResultMATIETDEV = max(interimStep[0][]);
	*tempResultMAFE = max(interimStep[1][]);
	*tempResultMinMATIE = max(interimStep[2][]);
	*tempResultMinMAFE = max(interimStep[3][]);
	
	
	

}

