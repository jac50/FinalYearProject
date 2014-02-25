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
	sum <- 0
	a <- (a / 100) * length(window)
	b <- (b / 100) * length(window)
	a = round(a) + 1 # 1 indexed
	b = round(b)
	
	for (i in a:b){
		sum <- sum + window[i] # sum window from a to b
	}
	average <- sum / (b - a + 1)
	return (average)
}
