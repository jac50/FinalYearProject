#!/usr/bin/env Rscript
#-----------------------------------------------------
#-----------------------------------------------------
#--                Function Name: bandMean          --
#--                Name: Band Mean                  --
#--           Input: window - the samples           --
#--                     a   - lower band            -- 
#--                     b   - upper band            --
#--           Output : mean of window               --
#-----------------------------------------------------
#-----------------------------------------------------
bandMean <- function(window,a,b){
	sum = 0
	for (i in a:b){
		sum = sum + window[i] # sum window from a to b
	}
	average = sum / (b - a + 1)
	print(window)
	return (average)
}
