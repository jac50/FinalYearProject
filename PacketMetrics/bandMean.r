#!/usr/bin/env Rscript
bandMean <- function(window,a,b){
	sum = 0
	for (i in a:b){
		sum = sum + window(i) # sum window from a to b
	}
	average = sum / (b - a + 1)
	return (average)
}
