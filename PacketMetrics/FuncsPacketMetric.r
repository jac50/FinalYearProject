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


