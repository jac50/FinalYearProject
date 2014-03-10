#!/usr/bin/awk -f

BEGIN {
if (RATIO < 0 || RATIO > 1000000) print "Illegal value of ratio. Will default to 10\n" > "/dev/stderr";\
if (RATIO == 0) print "RATIO variable not found. will default to 10" > "/dev/stderr" ;\
if (!(RATIO ~ /^[0-9]+$/)) print "RATIO must be an integer. Defaulted to 10" > "/dev/stderr"; 

FS = ","; RATIO==10; num=0; sum[0]=0; sum[1]=0;
	


};\
{\
if (num==0) { firstfield = $1}; \
num = num + 1;\
sum[1] = sum[1] + $4; 
sum[2] = sum[2] + $6;\
if (num == RATIO) {
split(firstfield,arrayFirstField," ")
split($1,arraySecond," ")
gsub(/:/," ",arrayFirstField[2])
gsub(/:/," ", arraySecond[2])
gsub(/-/, " ", arrayFirstField[1])
gsub(/-/, " ", arraySecond[1])
timeDelta = add_ms(arrayFirstField,arraySecond)

printf "%s %g %g \n",abs(timeDelta),sum[1]/num,sum[2]/num;\
#printf "%s to %s %g %g Test: %s\n",firstfield,$1,sum[1]/num,sum[2]/num, abs(timeDelta);\
sum[1] = 0; \
sum[2] = 0; \
num = 0;\
}; \
lastfield = $1\
}\

END {if (num!=0) printf "%s to %s %g %g\n",firstfield,lastfield,sum[1]/num, sum[2]/num}
function add_ms(time, time2, 	delta, delta2) { 
	split(time[2],delta, ".");\
	split(time2[2],delta2,".");\
	if (int(delta[2]) > int(delta2[2])) {
		return (1000 - int(delta[2]) / 1000 + int(delta2[2]) / 1000)
	} else 	return( (mktime(time2[1] " " time2[2]) + (int(delta2[2]) / 1000 ))) - (mktime(time[1] " " time[2]) + (int(delta[2]) / 1000));
}
function abs(value)
{
  return (value<0?-value:value);
}
