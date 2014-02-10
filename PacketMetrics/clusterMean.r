#!/usr/bin/env Rscript
#-----------------------------------------------------
#-----------------------------------------------------
#--            Function Name: cluster mean          --
#--                Name: Cluster Mean               --
#--           Input: window - subset of samples     --
#--                    a    - lower band            -- 
#--                    b    - upper band            --
#--           Output : cluster mean                 --
#-----------------------------------------------------
clusterMean <- function(window,a,b){
	sum = 0
	for (i in a:b){
		sum = sum + window(i) # sum window from a to b
	}
	average = sum / (b - a + 1)
	return (average)
}
