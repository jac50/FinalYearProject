#!/usr/bin/env Rscript

#-----------------------------------------------------
#-----------------------------------------------------
#--              Function Name: clusterTDEV         --
#--             Name: cluster Time Deviation        --
#--        Input: nTo - position in list            --
#--                N   - number of samples          -- 
#--                x   - vector of samples          --
#--       Output : cluster time deviation           --
#-----------------------------------------------------
source("clusterMean.r")

clusterTDEV <- function(nTo,N,x){
	To <- 0.1 # set minimum step
	n <- nTo / To #number of samples to current
	window <- 15
	windowStep <- (window - 1) / 2 #set side of window
	outerStep <- 0
	a <- 20
	b <- 80
	for (j in 1:(N-3*n + 1)){
		interimStep <- 0
		for (i in j:(n+j - 1)){
			interimStep <- interimStep + clusterMean(x[i + 2*n - windowStep : i + 2*n + windowStep],a,b) - 2 * clusterMean(x[i+n - windowStep : i + n + windowStep],a,b) + clusterMean(x[i - windowStep : i + windowStep],a,b) 
		}
		interimStep = interimStep ^ 2
		outerStep = outerStep + interimStep
	}
	outerStep = outerStep / (6 * n^2 * (N - 3*n + 1))
	result <- sqrt(outerStep)
	return(result) 
}

#--- Test Code --------
#- Generate samples  --
x <- seq(0,1000)
print(bandTDEV(12,12,x))

