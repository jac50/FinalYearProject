#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------

source("TDEV.r") #Import TDEV Script
source("minTDEV.r") #Imprt MinTDEV Script
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

resultTDEV = matrix(0,maxn)
resultMinTDEV = matrix(0,maxn)

for (i in 1:maxn){
	
	resultTDEV[i] <- TDEV(To,i,N,delays)
	resultMinTDEV[i] <-minTDEV(To,i,N,delays)
}

#print(resultMinTDEV)
rangeOfValues <- range(0,resultTDEV,resultMinTDEV)
print(rangeOfValues)
#Name pdf file..
outputFileName = paste("../PTPData/Plots/Packet Results - Sample Size - ",N,".pdf",sep = "")
pdf(outputFileName)
plot(resultMinTDEV,type="o", col="red",log="xy")
lines(resultTDEV,type="o",col="blue")
legend(1,rangeOfValues[2],c("TDEV", "minTDEV"), cex = 0.8,col=c("blue","red"), pch=21:22, lty=1:2)

dev.off()
#Create a CSV output file



