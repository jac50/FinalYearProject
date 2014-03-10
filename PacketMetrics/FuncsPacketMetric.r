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
	cat("Head has been run\n")
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

