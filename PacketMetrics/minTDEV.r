#!/usr/bin/env Rscript
#-----------------------------------------------------
#-----------------------------------------------------
#--             Function Name: minTDEV              --
#--         Name: Minimum Time Deviation            --
#--         Input: nTo - position in list           --
#--                 N   - number of samples         -- 
#--                 x   - vector of samples         --
#--           Output :min. time deviation           --
#-----------------------------------------------------
#-----------------------------------------------------

minTDEV <- function(nTo,N,x){
	To <- 0.1 #time between samples
	n <- nTo / To #number of samples to current point

	window <- 15 
	windowSide <- (window - 1) / 2 #Calculate left and right side of window
	outerStep <- 0
	for (j in 1:(N-3*n + 1)){
		interimStep <- 0
		for (i in j:(n+j - 1)){
			# As list is sorted, min value is far left value
			# in window
			interimStep <- interimStep + x[i + 2*n - windowSide] - 2* x[i+n - windowSide] + x[i - windowSide] 
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
print(minTDEV(12,12,x)) #Test Data

