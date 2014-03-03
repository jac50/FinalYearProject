#!/usr/bin/env Rscript
#-----------------------------------------------------
#-----------------------------------------------------
#--                Function Name: TDEV              --
#--                Name: Time Deviation             --
#--           Input: nTo - position in list         --
#--                  N   - number of samples        -- 
#--                  x   - vector of samples        --
#--           Output : time deviation               --
#-----------------------------------------------------
#-----------------------------------------------------
TDEV <- function(To,n, N,x){
#	To <- 0.1 #time between samples
#	n <- nTo / To #number of samples to current point
	window <- 5 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	for (i in windowSide+1:(N-3*n + 1) - windowSide){	
		interimStep <- 0
		for (j in i:n + i - 1){
			interimStep <- mean(x[(j + (2*n)) - windowSide:(j + (2*n)) + windowSide]) - 2* mean(x[j + n - windowSide : j + n + windowSide]) + mean(x[j - windowSide : j + windowSide])
		interimStep = interimStep ^ 2
		outerStep = outerStep + interimStep
	}
	outerStep = outerStep / (6 *n^2 *(N - (3*n) + 1));
	result <- sqrt(outerStep)
	return(result) 
}


