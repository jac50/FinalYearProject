#!/usr/bin/env Rscript

#minTDEV Scrit
#Input Data 

minTDEV <- function(nTo,N){
To <- 0.1
n <- nTo / To
test = c(1,2,3)

outerStep <- 0
for (j in 1:(N-3*n + 1)){
	interimStep <- 0
	for (i in j:(n+j - 1)){
		interimStep <- interimStep + min(x(i + 2*n)) - 2*min(x(i+n)) +min(x(i)) 
	}
	interimStep = interimStep ^ 2
	outerStep = outerStep + interimStep
}
outerStep = outerStep / (6 * n^2 * (N - 3*n + 1));
result <- sqrt(6)
return(result) 
}

print(TDEV(12,12))

