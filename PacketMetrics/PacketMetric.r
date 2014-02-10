#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------

source("TDEV.r") #Import TDEV Script

#---------- Import Data into script -----------

print ("Reading CSV Data...")
Data <- read.csv(file = "../PTPData/subsetData.txt",head = TRUE, sep=",")
print ("CSV Data has been written to Data variable")
delays <- as.matrix(Data[4])
# delays <-sort(delays) Sort if needed
To <- 1/16 #Assume To = 1/16
# ---- Removes Init Messages and the first value
delays = delays[-1] 
delays = delays[-1]
delays = delays[-1]
print (delays)
N <- 46
maxn = floor(N / 3)

result = matrix(0,maxn)
for (i in 1:maxn){
	
	result[i] <- TDEV(To,i,46,delays)
}

print(result)

#Create a CSV output file



