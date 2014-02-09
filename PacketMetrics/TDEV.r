#!/usr/bin/env Rscript


#Input Data 

TDEV <- function(nTo,N,x){
To <- 0.1
n <- nTo / To
#generate test data
x <- seq(0,1000)

outerStep <- 0
for (j in 1:(N-3*n + 1)){
	interimStep <- 0
	for (i in j:(n+j - 1)){
		interimStep <- interimStep + x[i + 2*n] - 2* x[i+n] + x[i] 
	}
	interimStep = interimStep ^ 2
	outerStep = outerStep + interimStep
}
outerStep = outerStep / (6 * n^2 * (N - 3*n + 1));
result <- sqrt(6)
return(result) 
}

print(TDEV(12,12))

