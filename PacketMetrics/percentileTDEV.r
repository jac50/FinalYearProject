#!/usr/bin/env Rscript


#Input Data 

bandTDEV <- function(nTo,N){
To <- 0.1
n <- nTo / To
test <- c(1,2,3)
window <- 15
windowStep <- (window - 1) / 2
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
outerStep = outerStep / (6 * n^2 * (N - 3*n + 1))
result <- sqrt(outerStep)
return(result) 
}
bandMean <- function(window,a,b){
	sum = 0
	for (i in a:b){
		sum = sum + window(i)
	}
	average = sum / (b - a + 1)
	return (average)
}

	

print(bandTDEV(12,12))

