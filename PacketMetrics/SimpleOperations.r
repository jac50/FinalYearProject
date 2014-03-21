
plotHistogram <- function(data) { 
	
	outputFileName = paste("../PTPData/Plots/HistogramsOfDelays/Histogram of Delays - Test:", args$nTest, " Sample - N", N, " size.eps",sep = "")
	postscript(outputFileName)
	hist(data, xlab = "Bins of Delay", ylab="Frequency", main = )

}


plotDelay <- function(delay) {
	
	outputFileName = paste("../PTPData/Plots/PlotOfDelays/Plot of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	postscript(outputFileName)
	plot(delay)
}

plotCHistogram <- function (delay) { 
	# Work in Progress. Comment out all lines until it is completed
	#outputFileName = paste("../PTPData/Plots/PlotOfDelays/Colour Histogram of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	#postscript(outputFileName)
	colouredDelayArray = matrix(0,10,20) #temp matrix. need to define size
	#plot(delay)
	# -- Flatten the histogram into their corresponding colours. 
	# --- One slice will therefore be one point in time? or one test?
	step <- floor(length(delay) / 5) # 100 steps for the time being. 
	print (step)
	j = 1
	problemStep <- length(delay) / step
	for (i in seq(1, length(delay), by=step))  {
		if (is.na(delay[(i+step - 1)])) break
		colouredDelayArray[j,] <-hist(delay[i:i+step - 1],plot = FALSE)$counts
		j = j + 1
	}
	
	#cat(paste("Test: ",counts))
	png("simpleIm.png")
	image(colouredDelayArray, col=colorRampPalette(c("blue","yellow","red"))(256))

}

calculateStats <- function(delay) {
	mean <- mean(delay)
	median <- median(delay)
	stddev <- sd(delay)
	variance <- var(delay)
		
	returnValue<- list("mean" = mean, "median" = median, "stddev" = stddev,"variance" = variance)
	return (returnValue)
}



