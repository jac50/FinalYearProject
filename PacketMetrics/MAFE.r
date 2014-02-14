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
MAFE <- function(To,n, N,x,MATIE){
#	To <- 0.1 #time between samples
#	n <- nTo / To #number of samples to current point
	if (MATIE!=0) return MATIE / (n*To)
	window <- 5 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	result = matrix(0,(N - 2*n + 1))
	for (i in windowSide + 1:(N-2*n + 1) - windowSide){
		interimStep <- 0
		for (j in i:(n+k-1)){
			interimStep <- interimStep + mean(x[i+n - windowSide: i + n + windowSide]) +  mean(x[i - windowSide : i + windowSide])
		}
		interimStep = abs(interimStep)
		interimStep = interimStep / n
		result[i] = interimStep
	}		
	return(max(result) / (n*To))
}


