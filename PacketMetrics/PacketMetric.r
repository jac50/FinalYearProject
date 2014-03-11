#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
# -----------------------------------------
# - Import required functions + libraries -
# -----------------------------------------
options(warn = 1) # Enables warnings
cat("Loading Required Scripts..\n")
suppressPackageStartupMessages(library("argparse")) 
suppressPackageStartupMessages(library("gnumeric"))
library("logging")
source("../LaTeXScripts/generateLatexTable.r")
source("TDEV.r") 
source("minTDEV.r")
source("TDEVAllMethods.r")
source("MATIEAllMethods.r")
source("FuncsPacketMetric.r")
dyn.load("TDEV.so") # C function
cat("Loaded Required Scripts\n")

# ----- Initialises Variables -----
sampleSize <- 0
directory <- ""
fileName <- ""
index <- 0
parser <- createArguments()
# ----- Parses the arguments and checks to see if they are valid -----
args <- parser$parse_args()
sampleSize <- args$sampleSize
directory <- args$directory
initLogger(args$verbose, args$quiet)


if (directory == "None") {
	if (args$nTest == -1){
		logerror("Error 1: You need either a directory or the test number\n Program will exit. \n")
		return (1)
	}
}
if (sampleSize <= 0){
	logwarn("Default sample size of 50 will be used\n")
	args$sampleSize <- 50
	sampleSize <-args$sampleSize
	# ---- Note: Strange that I need to do the above. will investigate. possibly to do with deep/shallow copying?
}

###### TO DO: Handle what to do with metric types here ######

tempResult <- parseFileName(args$nTest, args$directory, args$direction)
fileName <- tempResult$fileName
args$nTest <- tempResult$nTest
index <- tempResult$index
testSheet <- tempResult$testSheet
# ----- At this point all arguments have been parsed successfully -----
# ----- Attempts to read RawData file -----
Data <- readFile(fileName, nTest, sampleSize, testSheet)
if (dim(Data)[0] ==1 && Data == 2) return (2) # Returns out of the entire script if an error is thrown in the previous function
#---------------------------------------------------------------------------------------------------------------------------------------------
#### - May need to be dynamic To ? or at least an option to change / work out #####

To <- 1/16 #Assume To = 1/16  
dataPacket <- purgeData(Data)
delays <- dataPacket$delays
time <- dataPacket$time
N <- dataPacket$N

#---- Currently To == Time, but will sort out once I understand what to do with To ----


# ---- Set restrictions based on document ------
maxn <- floor(N / 3)
maxNMATIE <- floor(N / 2)
# -------------- Initialise Variables ----------------------
RawResult <- c(0,0,0,0)
RawResultMATIE <- c(0,0,0,0)
ResultTDEV <- matrix(0, nrow = maxn, ncol = 5)
colnames(ResultTDEV) <- c("TDEV", "TDEVC", "minTDEV", "bandTDEV", "percentileTDEV")
ResultMATIEMAFE <- matrix(0, nrow = maxNMATIE, ncol = 4)
colnames(ResultMATIEMAFE) <- c("MATIE", "MAFE", "MinMATIE", "MinMAFE")

a <- 20
b <- 80
# ----- Main Loop. Loop from 1 to maxn -------
for (i in 1:maxn){
	ptm <- proc.time() # Read current time
	#iresultTDEV[i] <- TDEV(To, i,N,delays) #TDEV on its own
	#resultMinTDEV[i] <-minTDEV(To,i,N,delays) #minTDEV on its own
	#temp <- .C("TDEV",To,as.integer(i),as.integer(N),delays,result = double(1)) # C call to TDEV
	
	#resultTDEVC[i] <-as.double(temp['result']) #saves TDEVC results
	RawResult = TDEVAll(To,i,N,delays,a,b) 
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	ResultTDEV[i,1] = RawResult[1]
#	ResultTDEV[i,2] = ResultTDEVC[i] 
	ResultTDEV[i,3] = RawResult[2]
	ResultTDEV[i,4] = RawResult[3]
	ResultTDEV[i,5] = RawResult[4]
	ResultMATIEMAFE[i,1] = RawResultMATIE[1]
	ResultMATIEMAFE[i,3] = RawResultMATIE[2]
	ResultMATIEMAFE[i,2] = RawResultMATIE[3]
	ResultMATIEMAFE[i,4] = RawResultMATIE[4]
	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3), "\n" )) # Print line which prints the iteration time
	
}
# ----- Extension of the main loop to handle the extra iterations needed for MATIE / MAFE
for (i in (maxn + 1) : maxNMATIE) {
	ptm <- proc.time()
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	ResultMATIEMAFE[i,1] = RawResultMATIE[1]
	ResultMATIEMAFE[i,3] = RawResultMATIE[2]
	ResultMATIEMAFE[i,2] = RawResultMATIE[3]
	ResultMATIEMAFE[i,4] = RawResultMATIE[4]
	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3),"\n" ))
}
#print(ResultTDEV)
#### Plotting needs to be handled better. flags for what to plot, different ranges
# ------ Plotting the results -------

plotArray(ResultTDEV)
#plotArray(ResultMATIEMAFE)

result <- generateResultArray(ResultTDEV, ResultMATIEMAFE)

error <- outputTable(result,args$CSV, args$latex)

# ----- Create a CSV output file ------
#if (args$CSV){
#	loginfo("CSV File Requested") 
#	write.csv(result,file = paste("ResultCSV/Result_Test_", args$nTest,"_Size_",  args$sampleSize, ".csv",sep=""))
#	loginfo("CSV File Written")
#if (args$latex) {
#	loginfo("LaTeX Table Requested")
#	fileName <- paste("ResultLaTeX/Table_Test_", args$nTest, "_Size_", args$sampleSize, ".latex", sep="")
#	generateLatex(fileName,result,c("Index","TDEV", "minTDEV","BandTDEV", "PercentTDEV", "MATIE", "minMATIE", "MAFE", "minMAFE"), "Raw results of 500 samples for TDEV and minTDEV", "table:500sample")
#	loginfo("LaTeX table written")
#}
#print(result) #Test line to print result
