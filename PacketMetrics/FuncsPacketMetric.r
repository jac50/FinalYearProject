#--------------------------------------------------
#--------------------------------------------------
#-              Script File: Source File          -
#-          Description: Has all of the created   -
#-          functions that aren't in its own      -
#-          source file
#--------------------------------------------------
#--------------------------------------------------

# ----------------------------------------------
# -     Name: runHead                          -
# -     Description: calls linux function head -
# -     Input: sampleSize, directory           -
# -     Output: none                           -
# - 	GlobalVarDepend: None                  -
# ----------------------------------------------
runHead <- function(sampleSize, directory){
	system(paste("head -n ", sampleSize, " /home/james/FinalYearProject/PTPData/TestData/", directory, "/RawData.txt", " > /home/james/FinalYearProject/PTPData/TestData/", directory, "/SampleSize_", sampleSize, ".txt", sep="")) # System call of head
	loginfo(paste("New filename SampleSize_", sampleSize, ".txt has been created.", sep=""))
	return(0)
}
# --------------------------------------------------------------
# -             Name: createArguments                          -
# -             Description: creates arguments using argparse  -
# -             Input: None                                    -
# -             Output: parser                                 -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
createArguments <- function(){

	# ----- Sets up the Argument Parser and adds the required arguments -----
	parser <- ArgumentParser(description='Perform some Packet Metrics')
	parser$add_argument('-nTest',metavar='00X',type='integer',default= -1,
			help = 'This is the test number found in the Summary test sheet',dest="nTest")
	parser$add_argument('-nLines',metavar='N',type='integer',dest="sampleSize", default = 0,
			help = 'How many lines of the test file do you want - First N lines')
	parser$add_argument('-directory',metavar='dir',dest="directory",default="None", help = 'What directory is the test data in? Use a relative directory.')
	parser$add_argument('-metric', metavar='metric', dest="metrics", default="TDEV", help = 'List what metrics you want to add in.')
	parser$add_argument('-delayDir', metavar='direction', dest="direction", default="Master2Slave", 
			help = "What direction of delays do you want to base the metrics off? Master to Slave or Slave to Master")
	parser$add_argument('--AllTestsForSampleSize', metavar='Sample Size', dest='AllSampleSize', default="None", 
			help="Use this flag if you want all tests to run for a set sample size")
	parser$add_argument('--AllSamplesSizesForTest', metavar = 'Test Number', dest='AllinTest', default="None", 
			help = "USe this flag if you want all the sample sizes run for a particular test")
	parser$add_argument('-CSV',dest='CSV',action="store_true")
	parser$add_argument('-latex',dest='latex',action="store_true")
	parser$add_argument('-v', '--verbose', dest='verbose', action="store_true")
	parser$add_argument('-q', '--quiet', dest='quiet', action="store_true")
	parser$add_argument('--hist',dest='hist', action="store_true")
	parser$add_argument('--cHist', dest='chist', action="store_true")
	parser$add_argument('--plotDelay', dest='pdelay', action="store_true")	
	parser$add_argument('--save', dest='save', action="store_true")
	parser$add_argument('--load', dest='file')
	parser$add_argument('--stats', dest='stats', action="store_true")
	#--------------------------------------------------------------------------------------------------
	return (parser)
}

# --------------------------------------------------------------
# -             Name: initLogger                               -
# -             Description: initialises the logger            -
# -             Input: None                                    -
# -             Output: None                                   -
# -             GlobalVarDepend: args$verbose, args$quiet      -
# --------------------------------------------------------------
initLogger<- function(){ #removed quiet/verbose. rely globally

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
	# -----------------------------------------------
	# ----- Initialise All Logging Information -------
	# ------------------------------------------------
	# ------------------------------------------------
	addHandler(writeToFile,file="LogFiles/Test.Log",level=10)
	loginfo("-------------------------------------------------")
	loginfo(" ---------- PacketMetric.R Log ------------------")
	loginfo("-------------------------------------------------")

}

# --------------------------------------------------------------
# -             Name: parseFileName                            -
# -             Description: generates file test path from     -
# -`	             test results sheet                        -
# -             Input: nTest, directory, column                -
# -             Output: returnValue :filename, Index,          -
# -                                  nTest, testSheet          -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
parseFileName <- function(nTest,directory,column) {

	# ----- Reads in the Summary Test Sheet -----
	testSheet <- read.gnumeric.sheet(file = "../PTPData/TestData/TestSheets.ods", 
				 sheet.name="Summary Sheet",
				top.left='B3',
				bottom.right='D30',
				drop.empty.rows='bottom')

	# Currenty using only 27 rows, but it may be possible to do this dynamically. Or maybe just use a large number provided that isn't too inefficient

	# ----- Checks if either Test number is 0 or if the test has not been added to the sheet -----
	# ----- The latter is performed to check if the value in testSheet is NA                 -----
	if (nTest == 0 || is.na(testSheet[nTest,3])){
		logwarn(paste("Test Number", args$nTest, "not found. Defaulting to example data\n"))
		nTest <- 0
	}
	# ----- Creates the fileName. Currently a relative path ------
	fileName <- ""				
	if (directory != "None"){
		fileName = paste("../PTPData/TestData/",directory,"/SampleSize_", sampleSize,".txt",sep="")

	} else if (args$nTest == 0) {
		fileName = paste("../PTPData/TestData/ExampleData/SampleSize_", sampleSize, ".txt",sep="")

	} else {
		
		fileName = paste("../PTPData/TestData/", testSheet[args$nTest,3], "/SampleSize_", sampleSize,".txt", sep="")
	}
	index <- 4 #default index for Data delays. 4 for Master to Slave. 6 for Slave to Master
	if (column == "Slave2Master") { 
		index <- 6
		#index <- 2 New data set
	} else {
		index <- 4
	}
	returnValue<- list("fileName" = fileName, "nTest" = nTest, "index" = index,"testSheet" = testSheet)
	return (returnValue)

}	

# --------------------------------------------------------------
# -             Name: readFile                                 -
# -             Description: Reads the filename.               -
# -			    If file doesn't exist, create it   -
# -             Input: fileName, nTest, sampleSize, testSheet  -
# -             Output: Data                                   -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
readFile <- function(fileName, nTest, sampleSize, testSheet){

	cat(paste("Filename to be read : ", fileName,"\n"))

	loginfo("Attempting to Read in CSV Data...\n")
	error <- try(Data <- read.csv(file = fileName,head = TRUE, sep=",")) # Catches the error if read.csv fails
	if ("try-error" %in% class(error)) { 
		loginfo("The file can not be found. This is most likely because the sample size file you requested does not exist. This file will be created.\n")
		# ---- Calls Head on the non-standard sampleSize
		if (args$nTest == 0) runHead(args$sampleSize, "ExampleData")
		else runHead(args$sampleSize,testSheet[args$nTest, 3])
	
		# ----- Reads the data again to see if the file was created successfully -----
		error <- try(Data <- read.csv(file = fileName,head = TRUE, sep=","))
		if ("try-error" %in% class(error)) {
			logerror("Error 2: Failed twice. will exit script\n")
			return(2)
		}
	}
	loginfo("CSV Data has been written to Data variable\n")
	return(Data)	

}

# --------------------------------------------------------------
# -             Name: purgeData                                -
# -             Description: Purges the initial values in the  -
# -				file                           -
# -             Input: Data                                    -
# -             Output: returnValue (delays, N, time)          -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
purgeData <- function(Data) {
	#----- Work out what type of file is Data (ie new file type or old)
	if (ncol(Data) == 9) {
		loginfo("Parsing Old File Type.")
		#Index is global. careful...
		delays <- as.matrix(Data[index]) # Currently taking only one of the delays
		time <- 1/16 #Fixed Value
		delays = delays[-1] # remove for new file type
		delays = delays[-1]
		delays = delays[-1]
		N <- as.numeric(sampleSize) - 4 #1 for the header, 2 for init, and 1 for the null value
	} else if (ncol(Data == 3)) {
		loginfo("Parsing New File Type.")
	        time <- as.matrix(Data[0])
		delays <- as.matrix(Data[index])
		N <- as.numeric(dim(time))
		
	}
	
	returnValue<- list("delays" = delays, "N" = N, "time" = time)
	return (returnValue)

}

# --------------------------------------------------------------
# -             Name: plotArray                                -
# -             Description: Plots the data                    -
# -             Input: values, whichPlot                       -
# -             Output: None                                   -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
plotArray <- function(values,whichPlot) {
	#Global Vars: args$nTest, N, 
	rangeOfValues <- range(0,values) #Determines a max range for the plot
	if (whichPlot == 0) metric = "TDEV" #TDEV
	else metric = "MATIE-MAFE"
	outputFileName = paste("../PTPData/Plots/Test: ", args$nTest, " - ", metric, " - ", N, " size.eps",sep = "")
	postscript(outputFileName)
	plottingColours = rainbow(ncol(values))
	plot(values[,1], type='o',xaxt='n', yaxt='n',pch='+',col=plottingColours[1],log="xy",xlab="", ylab="")
	for (i in 2:ncol(values)) { 
		#if (values[1,i] == 0) {
		#	loginfo("Column Ignored")
		#	continue
		#}
		lines(values[,i], type='o',pch='+',col=plottingColours[i])
	}
	legend(1,max(values[,2:ncol(values)]),colnames(values) , col=plottingColours, cex = 0.8,lty=1, pch='+', title="Metrics Legend",box.lwd = 0,box.col = "white",bg = "white") 
	if (metric == "TDEV") title(main=paste("Packet Metrics - TDEV - Sample Size", sampleSize),ylab="", xlab="Index/Time")
	else title(main=paste("Packet Metrics - MATIE-MAFE - Sample Size", sampleSize),ylab="", xlab="Index/Time")
	mtext(side = 2, text="    Index/Time", line = 3)
	axis(side = 1)
	axis(side = 2, las = 1)
	dev.off()
	loginfo("Plot Created")
}

# --------------------------------------------------------------
# -             Name: generateResultArray                      -
# -             Description: returns the combined result array -
# -             Input: ResultTDEV, ResultMATIEMAFE             -
# -             Output: resu                                   -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
generateResultArray <- function(ResultTDEV, ResultMATIEMAFE) {

	# Globals: maxNMATIE, maxn
	# The indices below refer to the C result. Adjust the result indices by 1 when it gets removed.
	#  C array is result[,2]
	result <- matrix(0,ncol = 10, nrow = maxNMATIE)
	result[,1] <- seq(1,maxNMATIE) #currently datapoints - not time axis
	result[1:maxn,2:6] <- ResultTDEV
	result[,7:10] <- ResultMATIEMAFE
	return(result)

}

# --------------------------------------------------------------
# -             Name: outputTable                              -
# -             Description: writes CSV and latex file         -
# -             Input: result, isCSV, isLatex                  -
# -             Output: None                                   -
# -             GlobalVarDepend: None                          -
# --------------------------------------------------------------
outputTable <- function(result, isCSV, isLatex){
	#Global: args$nTest, args$sampleSize
	# ----- Create a CSV output file ------
	if (isCSV){
		loginfo("CSV File Requested") 
		write.csv(result,file = paste("ResultCSV/Result_Test_", args$nTest,"_Size_",  args$sampleSize, ".csv",sep=""))
		loginfo("CSV File Written")
	}
	if (isLatex) {
		loginfo("LaTeX Table Requested")
		fileName <- paste("ResultLaTeX/Table_Test_", args$nTest, "_Size_", args$sampleSize, ".latex", sep="")
		generateLatexMetrics(fileName,result,c("Index","TDEV", "minTDEV","BandTDEV", "PercentTDEV", "MATIE", "minMATIE", "MAFE", "minMAFE"), "Raw results of 500 samples for TDEV and minTDEV", "table:500sample")
		loginfo("LaTeX table written")
	}
}
