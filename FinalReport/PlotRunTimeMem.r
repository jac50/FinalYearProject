#!/usr/bin/env Rscript

samples <- {50,100,500,1000,5000,10000,100000,1000000}
runtimeIter <- {}
runtimeFull <- {}
memory <- {}
plotColours = rainbow(2)
outputFileName = paste("RunTime.eps")
postscript(outputFileName)
plot(samples, runtimeIter, type='o',xaxt='n', yaxt='n',pch='+', xlab="", ylab="", col=plotColours[1])
lines(samples,runtimeFull,type='o',pch='+', col=plotColours[2])
legend(1,max(runtimeFull), c("Run Time Per Iteration", "Full Run Time"), col=plotColours, cex=0.8, lty=1, pch='+', title="Runtime Legend", box.lwd=0, box.col="white", bg="white")

title(main="Run Time for Example Data", xlab="Sample Size", ylab="Time (ms)")
dev.off()

outputFileName2 = paste("MemoryReq.eps")
postscript(outputFileName2)
plot(samples, memory, type='o',xaxt='n', yaxt='n',pch='+', xlab="", ylab="")
title(main="Memory Requirement for Example Data", xlab="Sample Size", ylab="Memory Requirement (KB))")
dev.off()
