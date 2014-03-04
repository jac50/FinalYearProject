#!/usr/bin/env Rscript

generateLatex <- function(tableToPrint, headings,caption,label) {
	print(tableToPrint)
	filePointer <- file("Table.latex")
	#Work out how many columns
	x <- matrix("",nrow =  6)
	x[1] <-("\\begin{table}[H]")
	x[2] <-("\\centering")
	x[3] <-(paste("\\caption{", caption,"}"))
	tabularString <- "\\begin{tabular}{"
	for (i in 1:ncol(tableToPrint)){
		tabularString <- paste(tabularString,"|>\\centering\\arraybackslash}p{3cm}")
	}
	tabularString <- paste(tabularString,"}\\hline")
	x[4] <- tabularString
	headingString <- "\\cellcolor{Black}\\textcolour{White}{\\textbf{"
	for (i in 1:length(headings)){
		if (i == 1) Heading <- paste(headingString,headings[i],"}}")
		else  Heading <- paste(Heading," & ", headingString, headings[i], "}}")

	}	
	Heading <- paste(Heading,"\\\\ \\hline")
	x[5] <- Heading
	for (i in 1:nrow(tableToPrint)){
		rowString <- tableToPrint[i,1]
		for (j in 2:ncol(tableToPrint)){
			rowString <- paste(rowString, " & ", tableToPrint[i,j])
		}
		rowString <- paste(rowString, "\\\\ \\hline")
		x[5 + i] <- rowString

	}		
	x[6+i] <- "\\end{tabular}"
	x[7+i] <- "\\end{table}"


	writeLines(x,filePointer)
	close(filePointer)
}

