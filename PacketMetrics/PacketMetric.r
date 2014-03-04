#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
options(warn = 1)
suppressPackageStartupMessages(library("argparse"))
library("gnumeric")
source("../LaTeXScripts/generateLatexTable.r")
source("TDEV.r") #Import TDEV Script
source("minTDEV.r") #Imprt MinTDEV Script
source("TDEVAllMethods.r")
source("MATIEAllMethods.r")
dyn.load("TDEV.so")
cat("Loaded Required Scripts\n")
#---------- Import Data into script -----------
sampleSize <- 0
directory <- ""
parser <- ArgumentParser(description='Perform some Packet Metrics')
parser$add_argument('-nTest',metavar='00X',type='integer',default= -1,
			help = 'This is the test number found in the Summary test sheet',dest="nTest")
parser$add_argument('-nLines',metavar='N',type='integer',dest="sampleSize", default = 0,
			help = 'How many lines of the test file do you want - First N lines')
parser$add_argument('-directory',metavar='dir',dest="directory",default="None", help = 'What directory is the test data in? Use a relative directory.')
parser$add_argument('-metric', metavar='metric', dest="metrics", default="TDEV", help = 'List what metrics you want to add in.')

args <- parser$parse_args()
sampleSize <- args$sampleSize
directory <- args$directory
#-----------------------------
if (directory == "None") {
	if (args$nTest == -1){
		cat("Error 1: You need either a directory or the test number\n")
		return (1)
	}
}
if (sampleSize == 0){
	cat("Default sample size of 50 will be used\n")
	args$sampleSize <- 50
	sampleSize <-args$sampleSize
}


#Handle what to do with metric types here


testSheet <- read.gnumeric.sheet(file = "../PTPData/TestData/TestSheets.ods", 
				 sheet.name="Summary Sheet",
				top.left='B3',
				bottom.right='D30',
				drop.empty.rows='bottom')

if (is.na(testSheet[args$nTest,3]) == TRUE){
	cat(paste("Test Number", args$nTest, "not found. Defaulting to example data\n"))
	args$nTest <- 0
}
				
if (directory != "None"){
	fileName = paste("../PTPData/TestData/",directory,"/SampleSize_", sampleSize,".txt",sep="")

} else if (args$nTest == 0) {
	fileName = paste("../PTPData/TestData/ExampleData/SampleSize_", args$sampleSize, ".txt",sep="")

} else {
	
	fileName = paste("../PTPData/TestData/", testSheet[args$nTest,3], "/SampleSize_", args$sampleSize,".txt", sep="")
}

cat(paste("Filename to be read : ", fileName,"\n"))

cat ("Attempting to Read in CSV Data...\n")
error <- try(Data <- read.csv(file = fileName,head = TRUE, sep=","))
if ("try-error" %in% class(error)) cat("There has been an error. please fix\n")
cat ("CSV Data has been written to Data variable\n")
delays <- as.matrix(Data[4])
# delays <-sort(delays) Sort if needed
To <- 1/16 #Assume To = 1/16
# ---- Removes Init Messages and the first value
delays = delays[-1] 
delays = delays[-1]
delays = delays[-1]
N <- as.numeric(sampleSize) - 4 #1 for the header, 2 for init, and 1 for the null value

maxn <- floor(N / 3)
maxNMATIE <- floor(N/2)
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
	cat (paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3), "\n" ))
	
	
}
for (i in (maxn + 1) : maxNMATIE) {
	ptm <- proc.time()
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	resultMATIE[i] = RawResultMATIE[1]
	resultMinMATIE[i] = RawResultMATIE[2]
	resultMAFE[i] = RawResultMATIE[3]
	resultMinMAFE[i] = RawResultMATIE[4]
	cat (paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3),"\n" ))
	proc.time()[1] - ptm[1]
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
postscript(outputFileName)
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

print(result)

