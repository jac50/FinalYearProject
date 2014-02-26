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
MATIEAllMethods <- function(To,n, N,x){
#	To <- 0.1 #time between samples
#	n <- nTo / To #number of samples to current point
	window <- 5 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	#MATIE, MAFE, minMATIE, MAFE
	result <- matrix(0,4)
	interimResult <- matrix(0,(N - 2*n + 10),4) #fudged because of the 4 truncated rows. will fix what N is. 
	interimStep <- matrix(0,2) #only need MATIE and minMATIE
	for (i in windowSide + 1:(N-2*n + 1) - windowSide ){
		interimStep <- c(0,0,0,0)
		for (j in i:(n+i-1)){
			interimStep[0] <- interimStep[0] + mean(x[i+n - windowSide: i + n + windowSide]) +  mean(x[i - windowSide : i + windowSide])
			interimStep[1] <- interimStep[1] + min(x[i + n - windowSide : i + n + windowSide]) + min(x[i - windowSide : i + windowSide])
		}
		for (k in 1:2){
		
			interimStep[k] <- abs(interimStep[k]) / n
		}
		interimResult[1][i] <- interimStep[1]
		interimResult[2][i] <- interimStep[1] / (n * To)
		interimResult[3][i] <- interimStep[2]
		interimResult[4][i] <- interimStep[2] / (n * To)
	}
	result[1] <- max(interimResult[1])		
	result[2] <- max(interimResult[2])		
	result[3] <- max(interimResult[3])		
	result[4] <- max(interimResult[4])		
	return(result)
}


