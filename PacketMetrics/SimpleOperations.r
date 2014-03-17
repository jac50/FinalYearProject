
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

plotCHistogram <- function () { 


}


