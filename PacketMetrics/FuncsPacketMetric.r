#--------------------------------------------------
#--------------------------------------------------
#-              Script File: Source File          -
#-          Description: Has all of the created   -
#-          functions that aren't in its own      -
#-          source file
#--------------------------------------------------
#--------------------------------------------------

# ----------------------------------------------
# -     Function: runHead                      -
# -     Description: calls linux function head -
# -     Input: sampleSize, directory           -
# -     Output: none                           -
# ----------------------------------------------
runHead <- function(sampleSize, directory){
	system(paste("head -n ", sampleSize, " /home/james/FinalYearProject/PTPData/TestData/", directory, "/RawData.txt", " > /home/james/FinalYearProject/PTPData/TestData/", directory, "/SampleSize_", sampleSize, ".txt", sep="")) # System call of head
	loginfo(paste("New filename SampleSize_", sampleSize, ".txt has been created.", sep=""))
	return(0)
}
createArguments <- function(sampleSize,directory){

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
	#--------------------------------------------------------------------------------------------------
	return (parser)
}
initLogger<- function(quiet,verbose){

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
	loginfo(" --- PacketMetric.R Log -------------------------")
	loginfo("-------------------------------------------------")

}

parseFileName <- function(nTest,directory,column    ) {

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
		fileName = paste("../PTPData/TestData/ExampleData/SampleSize_", args$sampleSize, ".txt",sep="")

	} else {
		
		fileName = paste("../PTPData/TestData/", testSheet[args$nTest,3], "/SampleSize_", args$sampleSize,".txt", sep="")
	}
	index <- 4 #default index for Data delays. 4 for Master to Slave. 6 for Slave to Master
	if (column == "Slave2Master") { 
		index <- 6
		#index <- 2 New data set
	} else {
		index <- 4
	}
	returnValue<- list("fileName" = fileName, "nTest" = nTest, "index" = index)
	return (returnValue)

}	


