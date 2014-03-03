#! /usr/bin/env Rscript


pktFilteredFFO <- function(To,n, N,x){
#	To <- 0.1 #time between samples
#	n <- nTo / To #number of samples to current point
	window <- 5 # Set window Size
	windowSide <- (window - 1) / 2 # Set the length of Side of window
	outerStep <- 0 
	for (i in 1:N){	
		outerStep <- outerStep + y[i] * ((2*i / (N^2 - 1)) - 1 / (N - 1))
	}
	return (outerStep * (6e-9) / (N * To))
}

	


