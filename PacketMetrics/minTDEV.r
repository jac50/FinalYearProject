#!/usr/bin/env Rscript
#---- MINTDEV --------


#Input Data 

TDEV <- function(nTo,N,x){
To <- 0.1
n <- nTo / To
#generate test data
x <- seq(0,1000)
window <- 15
windowSide <- (window - 1) / 2

outerStep <- 0
for (j in 1:(N-3*n + 1)){
	interimStep <- 0
	for (i in j:(n+j - 1)){
		interimStep <- interimStep + x[i + 2*n - windowSide] - 2* x[i+n - windowSide] + x[i - windowSide] 
	}
	interimStep = interimStep ^ 2
	outerStep = outerStep + interimStep
}
outerStep = outerStep / (6 * n^2 * (N - 3*n + 1));
result <- sqrt(outerStep)
return(result) 
}

print(TDEV(12,12))

