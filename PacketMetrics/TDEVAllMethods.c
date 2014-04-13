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

void TDEVAllMethods(int To, int* n, int* N ,double * x,double * tempResultTDEV,double * tempResultMinTDEV, double * tempResultBandTDEV, double * tempResultPercTDEV){
	int window = 5; // Set window Size
	int windowSide =  (window - 1) / 2; // Set the length of Side of window
	double outerStep[4] = {0.0,0.0,0.0,0.0};

	double interimStep[4] = {0.0,0.0,0,0.0};
	double average[3][3] = {{0,0,0},{0,0,0},{0,0,0}};
	//int i = 0;
	int a = 1;
	int b = 3; //0 indexed
	double minimum[3] = {10000.0,10000.0,10000.0}; //large enough value so it won't be the minimum
	for (int i=windowSide; i <= (*N -(3 * (*n))) - windowSide + 2; i++){
		for (int k=0;k < window ;k++){
			average[0][0] = average[0][0] + x[i + 2*(*n) - windowSide + k - 1];
			average[0][1] = average[0][1] + x[i + (*n) - windowSide + k - 1];
			average[0][2] = average[0][2] + x[i - windowSide + k - 1];
			if (x[i + 2*(*n) - windowSide + k - 1] < minimum[0]) minimum[0] = x[i + 2*(*n) - windowSide + k - 1];
			if (x[i + (*n) - windowSide + k - 1] < minimum[1]) minimum[1] = x[i + (*n) - windowSide + k - 1];
			if (x[i- windowSide + k - 1] < minimum[2] ) minimum[2] = x[i - windowSide + k - 1];

		}
		for (int bm = a; bm < b + 1; bm++) {
			average[1][0] = average[1][0] + x[i + 2*(*n) - windowSide + bm - 1];
			average[1][1] = average[1][1] + x[i + (*n) - windowSide + bm - 1];
			average[1][2] = average[1][2] + x[i - windowSide + bm - 1];
		}
		for (int pm = 0; pm < b + 1; pm++){
			average[2][0] = average[2][0] + x[i + 2*(*n) - windowSide + pm - 1];
			average[2][1] = average[2][1] + x[i + (*n) - windowSide + pm - 1];
			average[2][2] = average[2][2] + x[i - windowSide + pm - 1];
		}

		for (int j = 0; j < 3; j++) {
			average[0][j] = average[0][j] / window;
			average[1][j] = average[1][j] / (b - a) + 1;
			average[2][j] = average[2][j] / (b + 1);
		}

		interimStep[0] = average[0][0] - (2 * average[0][1]) + average[0][2];
		interimStep[1] = minimum[0] - (2 * minimum[1]) + minimum[2];
		interimStep[2] = average[1][0] - (2 * average[1][1]) + average[1][2];
		interimStep[3] = average[2][0] - (2 * average[2][1]) + average[2][2];
		for (int j = 0; j < 4; j++) outerStep[j] = outerStep[j] + (interimStep[j] * interimStep[j]);

		for (int i = 0; i < 4; i++) average[i][0] = average[i][1] = average[i][2] = 0;
		minimum[0] = minimum[1] = minimum[2] = 10000.0;
		interimStep[0] = interimStep[1] = interimStep[2] = interimStep[3] = 0;
	}
	*tempResultTDEV = sqrt(outerStep[0] / (6 * (*N - (3)*(*n) + 1)));
	*tempResultMinTDEV = sqrt(outerStep[1] /  (6 * (*N - (3)*(*n) + 1)));
	*tempResultBandTDEV = sqrt(outerStep[2] /  (6 * (*N - (3)*(*n) + 1)));
	*tempResultPercTDEV = sqrt(outerStep[3] /  (6 * (*N - (3)*(*n) + 1)));




}

