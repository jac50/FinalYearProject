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
dyn.load("TDEV.so") # C function
cat("Loaded Required Scripts\n")
# ----------------------------------------------
# -     Function: runHead                      -
# -     Description: calls linux function head -
# -     Input: sampleSize, directory           -
# -     Output: none                           -
# ----------------------------------------------
runHead <- function(sampleSize, directory){
	system(paste("head -n ", sampleSize, " /home/james/FinalYearProject/PTPData/TestData/", directory, "/RawData.txt", " > /home/james/FinalYearProject/PTPData/TestData/", directory, "/SampleSize_", sampleSize, ".txt", sep="")) # System call of head
	cat("Head has been run\n")
	return(0)
}
# ------------------------------------------------
# ------------------------------------------------
# ----- Initialise All Logging Information -------
# ------------------------------------------------
# ------------------------------------------------


# ----- Initialises Variables -----
sampleSize <- 0
directory <- ""
# ----- Sets up the Argument Parser and adds the required arguments -----
parser <- ArgumentParser(description='Perform some Packet Metrics')
parser$add_argument('-nTest',metavar='00X',type='integer',default= -1,
			help = 'This is the test number found in the Summary test sheet',dest="nTest")
parser$add_argument('-nLines',metavar='N',type='integer',dest="sampleSize", default = 0,
			help = 'How many lines of the test file do you want - First N lines')
parser$add_argument('-directory',metavar='dir',dest="directory",default="None", help = 'What directory is the test data in? Use a relative directory.')
parser$add_argument('-metric', metavar='metric', dest="metrics", default="TDEV", help = 'List what metrics you want to add in.')
parser$add_argument('-delayDir', metavar='direction', dest="direction", default="Master2Slave", help = "What direction of delays do you want to base the metrics off? Master to Slave or Slave to Master")
parser$add_argument('--AllTestsForSampleSize', metavar='Sample Size', dest='AllSampleSize', default="None", help="Use this flag if you want all tests to run for a set sample size")
parser$add_argument('--AllSamplesSizesForTest', metavar = 'Test Number', dest='AllinTest', default="None", help = "USe this flag if you want all the sample sizes run for a particular test")
parser$add_argument('-CSV',dest='CSV',action="store_true")
parser$add_argument('-latex',dest='latex',action="store_true")
parser$add_argument('-v', '--verbose', dest='verbose', action="store_true")
parser$add_argument('-q', '--quiet', dest='quiet', action="store_true")
#--------------------------------------------------------------------------------------------------

# ----- Parses the arguments and checks to see if they are valid -----
args <- parser$parse_args()
if ((args$verbose && args$quiet)|| (!args$verbose && !args$quiet)) {
	basicConfig(level=20)
	logwarn("Invalid Flags or no flags given. Normal level of verbosity has been set")
} else if (args$verbose == TRUE) {
	basicConfig(level=10)
	loginfo("Verbose mode activated")
} else if (args$quiet == TRUE) {
	basicConfig(level=30)
	loginfo("Quiet mode activated")
}
# ------------------------------------------------
# ------------------------------------------------
# ----- Initialise All Logging Information -------
# ------------------------------------------------
# ------------------------------------------------
addHandler(writeToFile,file="LogFiles/Test.Log",level=10)
loginfo("-------------------------------------------------")
loginfo(" --- PacketMetric.R Log -------------------------")
loginfo("-------------------------------------------------")
sampleSize <- args$sampleSize
directory <- args$directory
if (directory == "None") {
	if (args$nTest == -1){
		logerror("Error 1: You need either a directory or the test number\n")
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

# ----- Reads in the Summary Test Sheet -----

testSheet <- read.gnumeric.sheet(file = "../PTPData/TestData/TestSheets.ods", 
				 sheet.name="Summary Sheet",
				top.left='B3',
				bottom.right='D30',
				drop.empty.rows='bottom')

# Currenty using only 27 rows, but it may be possible to do this dynamically. Or maybe just use a large number provided that isn't too inefficient

# ----- Checks if either Test number is 0 or if the test has not been added to the sheet -----
# ----- The latter is performed to check if the value in testSheet is NA                 -----
if (args$nTest == 0 || is.na(testSheet[args$nTest,3])){
	logwarn(paste("Test Number", args$nTest, "not found. Defaulting to example data\n"))
	args$nTest <- 0
}
# ----- Creates the fileName. Currently a relative path ------
				
if (directory != "None"){
	fileName = paste("../PTPData/TestData/",directory,"/SampleSize_", sampleSize,".txt",sep="")

} else if (args$nTest == 0) {
	fileName = paste("../PTPData/TestData/ExampleData/SampleSize_", args$sampleSize, ".txt",sep="")

} else {
	
	fileName = paste("../PTPData/TestData/", testSheet[args$nTest,3], "/SampleSize_", args$sampleSize,".txt", sep="")
}

index <- 4 #default index for Data delays. 4 for Master to Slave. 6 for Slave to Master
if (args$direction == "Slave2Master") { 
	index <- 6
	#index <- 2 New data set
} else {
	index <- 4
	#index <- 1 new data set
}

# ----- At this point all arguments have been parsed successfully -----
# ----- Attempts to read RawData file -----
loginfo(paste("Filename to be read : ", fileName,"\n"))

loginfo("Attempting to Read in CSV Data...\n")
##### Implement in a simple while loop? breaking if works or return if false
error <- try(Data <- read.csv(file = fileName,head = TRUE, sep=",")) # Catches the error if read.csv fails
if ("try-error" %in% class(error)) { #This is run if there's an error with the try-catch
	loginfo("The file can not be found. This is most likely because the sample size file you requested does not exist. This file will be created.\n")
	# ---- Calls Head on the non-standard sampleSize
	if (args$nTest == 0) runHead(args$sampleSize, "ExampleData")
	else runHead(args$sampleSize,testSheet[args$nTest, 3])
	loginfo("New Sample Size has been added. \n")

	# ----- Reads the data again to see if the file was created successfully -----
	error <- try(Data <- read.csv(file = fileName,head = TRUE, sep=","))
	if ("try-error" %in% class(error)) {
		logerror("Error 2: Failed twice. will exit script\n")
		return(2)
	}
}	

loginfo("CSV Data has been written to Data variable\n")

delays <- as.matrix(Data[index]) # Currently taking only one of the delaus
time   <- as.matrix(Data[0]) #Taking the time in preparation for using new file type

##### - May need to be dynamic To ? or at least an option to change / work out #####

To <- 1/16 #Assume To = 1/16  
# ---- Removes Init Messages and the first value -----

delays = delays[-1] # remove for new file type
delays = delays[-1]
delays = delays[-1]
N <- as.numeric(sampleSize) - 4 #1 for the header, 2 for init, and 1 for the null value

# ---- Set restrictions based on document ------
maxn <- floor(N / 3)
maxNMATIE <- floor(N/2)
# ---- Initialise Variables
RawResult = c(0,0,0,0)
RawResultMATIE <- c(0,0,0,0)
a <- 20
b <- 80
### Might need to refactor the below into its own results matrix ###
#------------------------------------------------------------------------
resultMATIE <-matrix(0,maxNMATIE)
resultMinMATIE <-matrix(0,maxNMATIE)
resultMAFE <-matrix(0,maxNMATIE)
resultMinMAFE <-matrix(0,maxNMATIE)

resultTDEV = matrix(0,maxn)
resultTDEVC = matrix(0,maxn)
resultMinTDEV = matrix(0,maxn)
resultBandTDEV = matrix(0,maxn)
resultPercentTDEV = matrix(0,maxn)
# -------------------------------------------------------------------
# ----- Main Loop. Loop from 1 to maxn -------
for (i in 1:maxn){
	ptm <- proc.time() # Read current time
	#iresultTDEV[i] <- TDEV(To, i,N,delays) #TDEV on its own
	#resultMinTDEV[i] <-minTDEV(To,i,N,delays) #minTDEV on its own
	#temp <- .C("TDEV",To,as.integer(i),as.integer(N),delays,result = double(1)) # C call to TDEV
	
	#resultTDEVC[i] <-as.double(temp['result']) #saves TDEVC results
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
	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3), "\n" )) # Print line which prints the iteration time
	
}
# ----- Extension of the main loop to handle the extra iterations needed for MATIE / MAFE
for (i in (maxn + 1) : maxNMATIE) {
	ptm <- proc.time()
	RawResultMATIE = MATIEAllMethods(To,i,N,delays)
	resultMATIE[i] = RawResultMATIE[1]
	resultMinMATIE[i] = RawResultMATIE[2]
	resultMAFE[i] = RawResultMATIE[3]
	resultMinMAFE[i] = RawResultMATIE[4]
	loginfo(paste("Iteration", i,"complete in Time:", round(proc.time()[1] - ptm[1],3),"\n" ))
}

#### Plotting needs to be handled better. flags for what to plot, different ranges
# ------ Plotting the results -------
rangeOfValues <- range(0,resultTDEV, resultMinTDEV,resultBandTDEV,resultPercentTDEV) #Determines a max range for the plot
outputFileName = paste("../PTPData/Plots/Packet Results - Sample Size - ",N,".eps",sep = "")
postscript(outputFileName)
plot(resultMinTDEV,type="o", col="red",log="xy")
lines(resultTDEV,type="o",col="blue")
lines(resultBandTDEV,type="o",col="green")
lines(resultPercentTDEV,type="o",col="orange")
legend(1,rangeOfValues[2],c("TDEV", "minTDEV","bandTDEV","percentTDEV"), cex = 0.8,col=c("blue","red","green","orange"), pch=21:22, lty=1:2)
dev.off()

loginfo("Plot created")
# ----- Create a CSV output file ------
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
loginfo("Result Array Created")
if (args$CSV){
	loginfo("CSV File Requested") 
	write.csv(result,file = paste("ResultCSV/Result_Test_", args$nTest,"_Size_",  args$sampleSize, ".csv",sep=""))
	loginfo("CSV File Written")
if (args$latex) {
	loginfo("LaTeX Table Requested")
	fileName <- paste("ResultLaTeX/Table_Test_", args$nTest, "_Size_", args$sampleSize, ".latex", sep="")
	generateLatex(fileName,result,c("Index","TDEV", "minTDEV","BandTDEV", "PercentTDEV", "MATIE", "minMATIE", "MAFE", "minMAFE"), "Raw results of 500 samples for TDEV and minTDEV", "table:500sample")
	loginfo("LaTeX table written")
}
#print(result) #Test line to print result

