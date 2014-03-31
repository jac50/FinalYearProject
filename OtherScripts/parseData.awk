#!/usr/bin/awk -f
#------------------------------------------------------------------------------------------------------------------------
#- 				Script Name: parseData.awk                                                              -
#--- Description: strips unnecessary data from the text file and saves it to a new file.                                -
#-        Input: Only input varialbe is RATIO - wich needs to be defined using RATIO=10                                 -
#-        First argument is the file to run the script on        
#-        Use > filename at the end of the script to pipe the data to the correct output file
#------------------------------------------------------------------------------------------------------------------------
BEGIN {
# Checks to see if Ratio is correct (ie greater than 0, not too high, and is an integer
if (RATIO < 0 || RATIO > 1000000) print "Illegal value of ratio. Will default to 10\n" > "/dev/stderr";\
if (RATIO == 0) print "RATIO variable not found. will default to 10" > "/dev/stderr" ;\
if (!(RATIO ~ /^[0-9]+$/)) print "RATIO must be an integer. Defaulted to 10" > "/dev/stderr"; 
FS = ","; RATIO==10; num=0; sum[0]=0; sum[1]=0; #Sets the file seperator, a default ratio value, and some initial values
printf "# TimeDelta, Master2Slave, Slave2Master\n"
};\
{\
if (NR < 4) next; #Ignores the first three lines
if (num==0) { firstfield = $1}; # Sets the firstfield (time) to the variable firstfield
num = num + 1;\
sum[1] = sum[1] + $4; #Adds the first delay to the first sum 
sum[2] = sum[2] + $6; #Adds the second delay to sum
if (num == RATIO) { #If we've added up RATIO number of delays
# --- This section parse
split(firstfield,arrayFirstField," ") #Split old time (at num=0) by space
split($1,arraySecond," ") #Split the new time (at num=RATIO) by space
gsub(/:/," ",arrayFirstField[2]) #Replace all semi colons with a space
gsub(/:/," ", arraySecond[2])#Replace all semi colons with a space
gsub(/-/, " ", arrayFirstField[1])#Replace all dashes with a space
gsub(/-/, " ", arraySecond[1]) #Replace all dasheswith a space
timeDelta = add_ms(arrayFirstField,arraySecond) 

printf "%s, %g, %g \n",abs(timeDelta),sum[1]/num,sum[2]/num;\
sum[1] = 0;#reset counters
sum[2] = 0; \
num = 0;\
}; \
lastfield = $1\
}\

END {	
	if (num != 0) { #If the number of delays is nonzero, do one final calculation as above

		split(firstfield,arrayFirstField," ")
		split($1,arraySecond," ")
		gsub(/:/," ",arrayFirstField[2])
		gsub(/:/," ", arraySecond[2])
		gsub(/-/, " ", arrayFirstField[1])
		gsub(/-/, " ", arraySecond[1])
		timeDelta = add_ms(arrayFirstField,arraySecond)
		printf "%s, %g, %g \n",abs(timeDelta),sum[1]/num, sum[2]/num
	}

}
function add_ms(time, time2, 	delta, delta2) { 
	split(time[2],delta, "."); #split the old time by .
	split(time2[2],delta2,"."); #split the current time by .
	#delta?[2] is the ms difference
	if (int(delta[2]) > int(delta2[2])) {
		# If delta is > delta 2, the time is of the form similar to 3.873 and 4.210. 
		# You can't take one away from the other, so I did 1000 - 873, then added on the 210. (for example)
		return (1000 - int(delta[2]) / 1000 + int(delta2[2]) / 1000) 
	} else 	return( (mktime(time2[1] " " time2[2]) + (int(delta2[2]) / 1000 ))) - (mktime(time[1] " " time[2]) + (int(delta[2]) / 1000));
}
function abs(value)
{
  return (value<0?-value:value);
}
