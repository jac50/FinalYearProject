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

fileName = paste("../PTPData/SampleSize_", sampleSize, ".txt",sep="")
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

result = matrix(0,maxn)
resultMinTDEV = matrix(0,maxn)

for (i in 1:maxn){
	
	#result[i] <- TDEV(To,i,N,delays)
	resultMinTDEV[i] <-minTDEV(To,i,N,delays)
}

print(resultMinTDEV)

#Create a CSV output file



