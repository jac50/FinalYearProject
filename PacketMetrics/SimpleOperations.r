
plotHistogram <- function(data) { 
	
	outputFileName = paste("../PTPData/Plots/HistogramsOfDelays/Histogram of Delays - Test:", args$nTest, " Sample - N", N, " size.eps",sep = "")
	postscript(outputFileName)
	hist(data, xlab = "Bins of Delay", ylab="Frequency", main = )

}


plotDelay <- function(delay) {
	
	outputFileName = paste("../PTPData/Plots/PlotOfDelays/Plot of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	postscript(outputFileName)
	plot(delay,, pch = 16, cex = .9)
}

plotCHistogram <- function (delay) { 
	# Work in Progress. Comment out all lines until it is completed
	#outputFileName = paste("../PTPData/Plots/PlotOfDelays/Colour Histogram of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	#postscript(outputFileName)
	#logDelay <- log(abs(delay))
	postscript("Test.eps")
	logDelay <- delay[2000:length(delay)]
	plot(delay[2000:length(delay)])
	step <- 32
	j <- 0
	# -- Flatten the histogram into their corresponding colours. 
	nStep <- floor(length(logDelay) / step ) # 100 steps for the time being. 
	colouredDelayArray = matrix(0,nStep,20) #temp matrix. need to define size
	print(nStep)
	print(min(logDelay))
	print(max(logDelay))
	bins <- seq(0.00000, 0.00010, by = 0.00005)
	
	for (i in seq(1, length(logDelay), by = step))  {
		if (is.na(logDelay[(i+step - 1)])) break
		
		colouredDelayArray[j,] <-hist(logDelay[i:i+step - 1],plot = FALSE, breaks = bins)$counts
		j = j + 1
	}
	print(colouredDelayArray)	
	#cat(paste("Test: ",counts))
	png("simpleIm.png")
	image(colouredDelayArray, col=rainbow(256))

}

calculateStats <- function(delay) {
	mean <- mean(delay)
	median <- median(delay)
	stddev <- sd(delay)
	variance <- var(delay)
	minimum <- min(delay)
	maximum <- max(delay)
	
	returnValue<- list("mean" = mean, "median" = median, "stddev" = stddev,"variance" = variance)
	return (returnValue)
}



