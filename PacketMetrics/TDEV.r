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
TDEV <- function(nTo,N,x){
	To <- 0.1 #time between samples
	n <- nTo / To #number of samples to current point
	window <- 15 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	for (j in 1:(N-3*n + 1)){
		interimStep <- 0
		for (i in j:(n+j - 1)){
			interimStep <- interimStep + mean(x[i + 2*n - windowSide:i + 2*n + windowSide]) - 2* mean(x[i+n - windowSide : i + n + windowSide]) + mean(x[i - windowSide : i + windowSide])
		}
		interimStep = interimStep ^ 2
		outerStep = outerStep + interimStep
	}
	outerStep = outerStep / (6 * n^2 * (N - 3*n + 1));
	result <- sqrt(outerStep)
	return(result) 
}

#--- Test Code --------
#- Generate samples  --
x <- seq(0,1000)
print(TDEV(12,12,x)) #Test Data

