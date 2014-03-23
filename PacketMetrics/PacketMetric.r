#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
# -----------------------------------------
# - Import required functions + libraries -
# -----------------------------------------
system("clear") #Clear screen
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
source("SimpleOperations.r")
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
start <- args$start
initLogger()


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
if (start > 0 && < 10000) {
	sampleSize <- sampleSize + start
}
tempResult <- parseFileName(args$nTest, args$directory, args$direction)
fileName <- tempResult$fileName
args$nTest <- tempResult$nTest
index <- tempResult$index
testSheet <- tempResult$testSheet
# ----- At this point all arguments have been parsed successfully -----
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
#----- As Delay variable has been written, it can now be plotted into histograms ------


if (args$hist) {
	plotHistogram(delays)
}

if (args$chist) {
	plotCHistogram(delays)
	plotCHistogram(delays)
}

if (args$pdelay) {
	plotDelay(delays)
}

results <- calculateMetrics()
ResultTDEV <- results$ResultTDEV
ResultMATIEMAFE <- results$ResultMATIEMAFE

# ---- Set restrictions based on document ------
#maxn <- floor(N / 3)
#maxNMATIE <- floor(N / 2)
## -------------- Initialise Variables ----------------------
##RawResult <- c(0,0,0,0)
#RawResultMATIE <- c(0,0,0,0)
#ResultTDEV <- matrix(0, nrow = maxn, ncol = 5)
#colnames(ResultTDEV) <- c("TDEV", "TDEVC", "minTDEV", "bandTDEV", "percentileTDEV")
#ResultMATIEMAFE <- matrix(0, nrow = maxNMATIE, ncol = 4)
#colnames(ResultMATIEMAFE) <- c("MATIE", "MAFE", "MinMATIE", "MinMAFE")

#a <- 20
#b <- 80
#loginfo("Starting main loop")
# ----- Main Loop. Loop from 1 to maxn -------
#for (i in 1:maxn){
#	ptm <- proc.time() # Read current time
#	#iresultTDEV[i] <- TDEV(To, i,N,delays) #TDEV on its own
#	#resultMinTDEV[i] <-minTDEV(To,i,N,delays) #minTDEV on its own
#	#temp <- .C("TDEV",To,as.integer(i),as.integer(N),delays,result = double(1)) # C call to TDEV
#	
#	#resultTDEVC[i] <-as.double(temp['result']) #saves TDEVC results
#	RawResult = TDEVAll(To,i,N,delays,a,b) 
#	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
#	ResultTDEV[i,1] = RawResult[1]
##	ResultTDEV[i,2] = ResultTDEVC[i] 
#	ResultTDEV[i,3] = RawResult[2]
#	ResultTDEV[i,4] = RawResult[3]
#	ResultTDEV[i,5] = RawResult[4]
#	ResultMATIEMAFE[i,1] = RawResultMATIE[1]
#	ResultMATIEMAFE[i,3] = RawResultMATIE[2]
#	ResultMATIEMAFE[i,2] = RawResultMATIE[3]
#	ResultMATIEMAFE[i,4] = RawResultMATIE[4]
#	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3), "\n" )) # Print line which prints the iteration time
#	
#}##
# ----- Extension of the main loop to handle the extra iterations needed for MATIE / MAFE
#for (i in (maxn + 1) : maxNMATIE) {
#	ptm <- proc.time()
#	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
#	ResultMATIEMAFE[i,1] = RawResultMATIE[1]
#	ResultMATIEMAFE[i,3] = RawResultMATIE[2]
#	ResultMATIEMAFE[i,2] = RawResultMATIE[3]
#	ResultMATIEMAFE[i,4] = RawResultMATIE[4]
#	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3),"\n" ))
#}##
#pr#int(ResultTDEV)
#------ Plotting and other Outpit forms are plotted here
plotArray(ResultTDEV,0)
plotArray(ResultMATIEMAFE,1)
print(ResultTDEV)

if (args$save) { 
fname = paste("../PTPData/DelayData/Data : Test: ", args$nTest, "Sample Size:", N, ".txt")
write.table(delays,file=fname,sep="\t", col.names = F, row.names = F)
loginfo("Data written to file")
}

if (args$stats) {
	stats <- calculateStats(delays)
	tabulateStats(stats)
}

result <- generateResultArray(ResultTDEV, ResultMATIEMAFE)

error <- outputTable(result,args$CSV, args$latex)

