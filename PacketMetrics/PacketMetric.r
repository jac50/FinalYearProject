#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
options(warn = 1)
source("../LaTeXScripts/generateLatexTable.r")
source("TDEV.r") #Import TDEV Script
source("minTDEV.r") #Imprt MinTDEV Script
source("TDEVAllMethods.r")
source("MATIEAllMethods.r")
dyn.load("TDEV.so")

#---------- Import Data into script -----------
arguments  <- commandArgs()
sampleSize <- arguments[6] #Command line args start from index 6

fileName = paste("../PTPData/TestData/SampleSize_", sampleSize, ".txt",sep="")
print(fileName)

print ("Reading CSV Data...")
Data <- read.csv(file = fileName,head = TRUE, sep=",")
print ("CSV Data has been written to Data variable")
delays <- as.matrix(Data[4])
# delays <-sort(delays) Sort if needed
To <- 1/16 #Assume To = 1/16
# ---- Removes Init Messages and the first value
delays = delays[-1] 
delays = delays[-1]
delays = delays[-1]
#print (delays)
N <- as.numeric(sampleSize) - 4 #1 for the header, 2 for init, and 1 for the null value

maxn <- floor(N / 3)
maxNMATIE <- floor(N/2)
print(paste("maxNMATIE", maxNMATIE))
RawResult = c(0,0,0,0)
RawResultMATIE <- c(0,0,0,0)
resultMATIE <-matrix(0,maxNMATIE)
resultMinMATIE <-matrix(0,maxNMATIE)
resultMAFE <-matrix(0,maxNMATIE)
resultMinMAFE <-matrix(0,maxNMATIE)

resultTDEV = matrix(0,maxn)
resultTDEVC = matrix(0,maxn)
resultMinTDEV = matrix(0,maxn)
resultBandTDEV = matrix(0,maxn)
resultPercentTDEV = matrix(0,maxn)
a <- 20
b <- 80
	

for (i in 1:maxn){
	ptm <- proc.time()
	#iresultTDEV[i] <- TDEV(To, i,N,delays)
	#resultMinTDEV[i] <-minTDEV(To,i,N,delays)
	#temp <- .C("TDEV",To,as.integer(i),as.integer(N),delays,result = double(1))
	
#	resultTDEVC[i] <-as.double(temp['result'])
	RawResult = TDEVAll(To,i,N,delays,a,b)
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	resultTDEV[i] = RawResult[1]
	resultMinTDEV[i] = RawResult[2]
	resultBandTDEV[i] = RawResult[3]
	resultPercentTDEV[i] = RawResult[4]
	resultMATIE[i] = RawResultMATIE[1]
	resultMinMATIE[i] = RawResultMATIE[2]
	resultMAFE[i] = RawResultMATIE[3]
	resultMinMAFE[i] = RawResultMATIE[4]

	#print(paste("Result: -----------------", resultTDEV[i]))
	print (paste("Iteration", i,"complete in Time:", "..." ))
	
}
for (i in (maxn + 1) : maxNMATIE) {
	print (paste("Iteration", i,"complete in Time:", "..." ))
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	resultMATIE[i] = RawResultMATIE[1]
	resultMinMATIE[i] = RawResultMATIE[2]
	resultMAFE[i] = RawResultMATIE[3]
	resultMinMAFE[i] = RawResultMATIE[4]
}

#print(resultTDEV)
#print(resultTDEVC)
#print(resultMinTDEV)
#print(resultMinTDEV)
rangeOfValues <- range(0,resultTDEV, resultMinTDEV,resultBandTDEV,resultPercentTDEV)
#print(rangeOfValues)
#Name pdf file..
outputFileName = paste("../PTPData/Plots/Packet Results - Sample Size - ",N,".eps",sep = "")
setEPS()
#postscript(outputFileName)
plot(resultMinTDEV,type="o", col="red",log="xy")
lines(resultTDEV,type="o",col="blue")
lines(resultBandTDEV,type="o",col="green")
lines(resultPercentTDEV,type="o",col="orange")
legend(1,rangeOfValues[2],c("TDEV", "minTDEV","bandTDEV","percentTDEV"), cex = 0.8,col=c("blue","red","green","orange"), pch=21:22, lty=1:2)

dev.off()
#Create a CSV output file
result <- matrix(0,ncol = 10, nrow = maxNMATIE)
result[,1] <- seq(1,maxNMATIE)
result[,2] <- c(resultTDEV, rep(0,maxNMATIE - maxn))
result[,3] <- c(resultTDEVC, rep(0,maxNMATIE - maxn))

result[,4] <- c(resultMinTDEV, rep(0,maxNMATIE - maxn))
result[,5] <- c(resultBandTDEV, rep(0,maxNMATIE - maxn))
result[,6] <- c(resultPercentTDEV, rep(0,maxNMATIE - maxn))
result[,7] <- resultMATIE
result[,8] <- resultMinMATIE
result[,9] <- resultMAFE
result[,10] <- resultMinMATIE
#generateLatex(result,c("Index","TDEV", "minTDEV","BandTDEV", "PercentTDEV", "MATIE", "minMATIE", "MAFE", "minMAFE"), "Raw results of 500 samples for TDEV and minTDEV", "table:500sample")

#print(result)

