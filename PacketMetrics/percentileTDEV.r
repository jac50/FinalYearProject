#!/usr/bin/env Rscript

#-----------------------------------------------------
#-----------------------------------------------------
#--        Function Name: percentileTDEV            --
#--       Name: percentile Time Deviation           --
#--        Input: nTo - position in list            --
#--                N   - number of samples          -- 
#--                x   - vector of samples          --
#--      Output : percentile time deviation         --
#--       Note: Same as bandTDEV, just a = 0        --
#-----------------------------------------------------
#-----------------------------------------------------
source("bandMean.r")
percentileTDEV <- function(nTo,N,x){
	To <- 0.1 #time between samples
	n <- nTo / To #number of samples to current
	window <- 15 
	windowStep <- (window - 1) / 2 #get side of window
	outerStep <- 0
	a <- 0
	b <- 80
	for (j in 1:(N-3*n + 1)){
		interimStep <- 0
		for (i in j:(n+j - 1)){
			interimStep <- interimStep + bandMean(x[i + 2*n - windowStep : i + 2*n + windowStep],0,b) - 2 * bandMean(x[i+n - windowStep : i + n + windowStep],0,b) + bandMean(x[i - windowStep : i + windowStep],0,b) 
		}
		interimStep = interimStep ^ 2
		outerStep = outerStep + interimStep
	}
	outerStep = outerStep / (6 * (N - 3*n + 1))
	result <- sqrt(outerStep)
	return(result) 
}

#--- Test Code --------
#- Generate samples  --
x <- seq(0,1000)
print(percentileTDEV(12,12,x))

