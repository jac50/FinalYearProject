#!/usr/bin/env Rscript

# ----------------------------------------------------
# -         Script Name: PacketMetric.r              -
# -       Description: This script will calculate    -
# -       the packet metrics for the given data set. -
# ----------------------------------------------------
# -----------------------------------------
# - Import required functions + libraries -
# -----------------------------------------
#Rprof(filename = "RProf.out", memory.profiling = TRUE, gc.profiling=TRUE,line.profiling = TRUE)
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
dyn.load("TDEVAllMethods.so")
dyn.load("MATIEAllMethods.so")
cat("Loaded Required Scripts\n")
startTime <- proc.time()
options(scipen=9)
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
NTEST <- args$nTest
start <- args$start
ratio <- args$ratio
initLogger()
if (args$interactiveMode == TRUE) {
	vars <- interactiveMenu()
	sampleSize <- vars$nLines
	nTest <- vars$nTest
	
}
if (directory == "None" && args$loadDelays == "None") {
	if (NTEST  == -1 && args$AllSampleSize == "None"){
		logerror("Error 1: You need either a directory or the test number\n Program will exit. \n")
		return (1)
	}
}
if (sampleSize <= 0 || args$AllSampleSize != "None" ){
	logwarn("Default sample size of 50 will be used\n")
	args$sampleSize <- 50
	sampleSize <-args$sampleSize
	# ---- Note: Strange that I need to do the above. will investigate. possibly to do with deep/shallow copying?
}
if (start > 0 && start < 10000) {
	sampleSize <- sampleSize + start
}
if (args$AllSampleSize!="None") {
	sampleSize <- args$AllSampleSize
	tests <- seq(0,9)
} else tests <- NTEST
ifLoad = FALSE
for (nTest in tests) {
	loginfo(paste("Running script on Test number", nTest))
	if (args$loadDelays != "None") {
		Data <-readFileDirect(paste("/home/james/FinalYearProject/PTPData/TestData/", args$loadDelays, sep=""))
		ifLoad = TRUE
	} else {
		tempResult <- parseFileName(nTest, args$directory, args$direction)
		fileName <- tempResult$fileName
		nTest  <- tempResult$nTest
		index <- tempResult$index
		testSheet <- tempResult$testSheet
		fileNameConv <- tempResult$fileNameConv
		if (args$convert) {
			loginfo(paste("Data file is being converted to the new format, and using a",ratio, "point average"))
			print(paste("File Name: ", fileName))
			runHead(sampleSize, "ExampleData") #Hard Coded need to fix!
			fileName <- convertData(ratio, fileName) #changes filename to the new file
		
		
		}
		Data <- readFile(fileName, nTest, sampleSize, testSheet)
	}
	if (dim(Data)[0] ==1 && Data == 2) return (2) # Returns out of the entire script if an error is thrown in the previous function
#---------------------------------------------------------------------------------------------------------------------------------------------
#### - May need to be dynamic To ? or at least an option to change / work out #####

	To <- 1/32 #Assume To = 1/16  
	dataPacket <- purgeData(Data,ifLoad)
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
	}

	if (args$pdelay) {
		plotDelay(delays)
	}
	print("OK")
	results <- calculateMetrics(To, N, delays)
	ResultTDEV <- results$ResultTDEV
	ResultMATIEMAFE <- results$ResultMATIEMAFE
	plotArray(ResultTDEV,0)
	plotArray(ResultMATIEMAFE,1)

	if (args$save) { 
		fname = paste("../PTPData/DelayData/Data : Test: ", nTest, "Sample Size:", N, ".txt")
		fname2 = paste("../PTPData/MetricData/TDEVData : Test: ", nTest, "Sample Size:", N, ".txt")
		fname3 = paste("../PTPData/MetricData/MATIEData : Test: ", nTest, "Sample Size:", N, ".txt")
		write.table(delays,file=fname,sep="\t", col.names = F, row.names = F)
		write.table(ResultTDEV, file=fname2,sep="\t", col.names = T, row.names = F)
	write.table(ResultMATIEMAFE, file = fname3, sep="\t", col.names = T, row.names = F)
	loginfo("Data written to file")
	}

	if (args$stats) {
		stats <- calculateStats(delays)
		tabulateStats(stats)
	}

	result <- generateResultArray(ResultTDEV, ResultMATIEMAFE)
	error <- outputTable(result,args$CSV, args$latex)
	loginfo(paste("Total Run Time: ", round(proc.time()[1] - startTime[1],3)))
	loginfo(paste("Total memory requirement: ", format((object.size(x=lapply(ls(), get))),units="KB")))
}

