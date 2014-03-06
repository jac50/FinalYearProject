#!/usr/bin/awk -f

BEGIN {FS = ","; RATIO=10; num=0; sum[0]=0; sum[1]=0;};\
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

delta[0] = add_ms(arrayFirstField[2])
delta[1] = add_ms(arraySecond[2])


#printf "%s to %s %g %g Test: %s\n",firstfield,$1,sum[1]/num,sum[2]/num, delta[1]; 
printf "%s to %s %g %g Test: %s\n",firstfield,$1,sum[1]/num,sum[2]/num, abs((mktime(arraySecond[1] " " arraySecond[2]) + delta[1])  - (mktime(arrayFirstField[1] " " arrayFirstField[2]) + delta[0]));\
sum[1] = 0; \
sum[2] = 0; \
num = 0;\
}; \
lastfield = $1\
}\

END {if (num!=0) printf "%s to %s %g %g\n",firstfield,lastfield,sum[1]/num, sum[2]/num}
function add_ms(time, 	delta) { 
	split(time,delta, ".")
	return (delta[2] / 1000)
			

}
function abs(value)
{
  return (value<0?-value:value);
}
