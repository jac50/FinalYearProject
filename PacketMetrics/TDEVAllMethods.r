#!/usr/bin/env Rscript
#-----------------------------------------------------
#-----------------------------------------------------
#--                Function Name: All Methods       --
#--                Name: Time Deviation             --
#--           Input: nTo - position in list         --
#--                  N   - number of samples        -- 
#--                  x   - vector of samples        --
#--           Output : time deviation               --
#-----------------------------------------------------
#-----------------------------------------------------
source("bandMean.r")
TDEVAll <- function(To,n, N,x,a,b){
#	To <- 0.1 #time between samples
#	n <- nTo / To #number of samples to current point
	window <- 5 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	interimStep <- c(0,0,0,0)
	outerStep <- c(0,0,0,0)
	result <- c(0,0,0,0)
	for (i in windowSide+1:(N-3*n + 1) - windowSide){
		interimStep <- c(0,0,0,0)	
			interimStep[1] <- interimStep[1] + mean(x[(i + (2*n)) - windowSide:(i + (2*n)) + windowSide]) - 2* mean(x[i+n - windowSide : i + n + windowSide]) + mean(x[i - windowSide : i + windowSide])
			
			interimStep[2] <- interimStep[2] + min(x[(i + (2*n)) - windowSide:(i + (2*n)) + windowSide]) - 2* min(x[i+n - windowSide : i + n + windowSide]) + min(x[i - windowSide : i + windowSide])
			interimStep[3] <- interimStep[3] + bandMean(x[(i + (2*n)) - windowSide:(i + (2*n)) + windowSide],a,b) - 2* bandMean(x[i+n - windowSide : i + n + windowSide],a,b) + bandMean(x[i - windowSide : i + windowSide],a,b)
		interimStep[4] <- interimStep[4] + bandMean(x[(i + (2*n)) - windowSide:(i + (2*n)) + windowSide],0,b) - 2* bandMean(x[i+n - windowSide : i + n + windowSide],0,b) + bandMean(x[i - windowSide : i + windowSide],0,b)
		
		for (k in 1:4){
			interimStep[k] <- interimStep[k] ^ 2
			result[k] <- result[k] + interimStep[k]
		}
	}
	for (k in 1:4){
		result[k] <- result[k] / (6 * (N - (3*n) + 1));
		result[k] <- sqrt(result[k])
	}
	#print(result)
	return(result) 
}


