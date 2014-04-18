
plotHistogram <- function(data) { 
	
	outputFileName = paste("../PTPData/Plots/HistogramsOfDelays/Histogram of Delays - Test:", args$nTest, " Sample - N", N, " size.eps",sep = "")
	postscript(outputFileName)
	hist(data, xlab = "Bins of Delay", ylab="Frequency", main = )

}


plotDelay <- function(delay) {
	
	outputFileName = paste("../PTPData/Plots/PlotOfDelays/Plot of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	postscript(outputFileName)
	plot(delay * 1000, pch = 16, cex = .9, xlab = "Sample Number", ylab = "Delays (ms)")
}

plotCHistogram <- function (delay) { 
	# Work in Progress. Comment out all lines until it is completed
	#outputFileName = paste("../PTPData/Plots/PlotOfDelays/Colour Histogram of Delays - Test:", args$nTest, " Sample -", N, " size.eps",sep = "")
	#postscript(outputFileName)
	step <- 32 * 60
	j <- 0
	#delay <- rnorm(n=5000,m=24.2,sd=2.2)
	# -- Flatten the histogram into their corresponding colours. 
	nStep <- floor(length(delay) / step ) # 100 steps for the time being. 
	colouredDelayArray = matrix(0,nStep,100) #temp matrix. need to define size
	bins <- seq(0.00000, 0.00010, by = 0.00005)
	
	for (i in seq(1, length(delay),by=step))  {
		if (is.na(delay[(i+step - 1)])) break
		histogram <- hist(delay[i:step + i - 1],breaks=30)$counts
		colouredDelayArray[j,1:length(histogram)] <- histogram
		j = j + 1
	}
	png("simpleIm.png")
	
	image(log(t(colouredDelayArray[,1:30])), col=heat.colors(30,alpha=1))

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



