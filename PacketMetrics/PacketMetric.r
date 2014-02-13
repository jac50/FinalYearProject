#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
source("../LaTeXScripts/generateLatexTable.r")
source("TDEV.r") #Import TDEV Script
source("minTDEV.r") #Imprt MinTDEV Script
source("TDEVAllMethods.r")
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

maxn = floor(N / 3)
RawResult = c(0,0,0,0)
resultTDEV = matrix(0,maxn)
resultMinTDEV = matrix(0,maxn)
resultbandTDEV = matrix(0,maxn)
resultpercentTDEV = matrix(0,maxn)
a <- 20
b <- 80
	
print ("Calling C function")
result <- 0
.C("TDEV",To,as.integer(1),as.integer(N),delays,result)
print (paste("Result: ", result))
for (i in 1:maxn){
	ptm <- proc.time()
	#resultTDEV[i] <- TDEV(To,,N,delays)
	#resultMinTDEV[i] <-minTDEV(To,i,N,delays)
	RawResult = TDEVAll(To,i,N,delays,a,b)
	#print(RawResult)
	resultTDEV[i] = RawResult[1]
	resultMinTDEV[i] = RawResult[2]
	resultbandTDEV[i] = RawResult[3]
	resultpercentTDEV[i] = RawResult[4]
	time <- proc.time() - ptm
	#print (paste("Iteration", i,"complete in Time:", time[3], "..." ))
}
,
#print(resultMinTDEV)
#rangeOfValues <- range(0,resultTDEV, resultMinTDEV,resultbandTDEV,resultpercentTDEV)
#print(rangeOfValues)
#Name pdf file..
outputFileName = paste("../PTPData/Plots/Packet Results - Sample Size - ",N,".eps",sep = "")
setEPS()
postscript(outputFileName)
plot(resultMinTDEV,type="o", col="red",log="xy")
lines(resultTDEV,type="o",col="blue")
lines(resultbandTDEV,type="o",col="green")
lines(resultpercentTDEV,type="o",col="orange")
#legend(1,rangeOfValues[2],c("TDEV", "minTDEV","bandTDEV","percentTDEV"), cex = 0.8,col=c("blue","red","green","orange"), pch=21:22, lty=1:2)

dev.off()
#Create a CSV output file
result <- matrix(0,ncol = 3, nrow = maxn)
#result[,1] <- seq(1,maxn)
#result[,2] <- resultTDEV
#result[,3] <- resultMinTDEV
generateLatexTable(result,c("Index","TDEV", "minTDEV"), "Raw results of 500 samples for TDEV and minTDEV", "table:500sample")


