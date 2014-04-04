#!/bin/sh
#---------------------------------------------------------------------------
#-                 Script Name: generateSampleTextfiles.sh                 -
#--- Description: used to create a selection of files from the given data  -
#---              set. Uses "head" and saves output in form SampleSize_N   -
#---              where N is the sampleSize                                -
#---------------------------------------------------------------------------
echo "Sample Size Script Generator Started.."
echo "Awk Script to split file into its usable components Started."
awk 'BEGIN { printf "Time   One Way Delay   Offset From Master, Slave to Master, MAster to Slave" 
		printf"-----------------------" };

{print $2, $5 $6, $7, $8} /home/james/FinalYearProject/PTPData/TestData/ExampleData/timeport_to_software_example.txt > Test.txt';

# Only takes the 2nd, 5th, 6th, 7th and 8th column of the data file. 

echo "Awk Script Finished"
head -n 50 Test.txt > SampleSize_50.txt
echo "50 Lines Saved"
head -n 100 Test.txt > SampleSize_100.txt
echo "100 Lines Saved"
head -n 500 Test.txt > SampleSize_500.txt
echo "500 Lines Saved"

head -n 1000 Test.txt > SampleSize_1000.txt
echo "1000 Lines Saved"
head -n 5000 Test.txt > SampleSize_5000.txt
echo "5000 Lines Saved"
head -n 10000 Test.txt > SampleSize_10000.txt
echo "10000 Lines Saved"
head -n 100000 Test.txt > SampleSize_100000.txt
echo "100000 Lines Saved"
head -n 1000000 Test.txt > SampleSize_1000000.txt
echo "1000000 Lines Saved"
head -n 10000000 Test.txt > SampleSize_10000000.txt
echo "10000000 Lines Saved"
