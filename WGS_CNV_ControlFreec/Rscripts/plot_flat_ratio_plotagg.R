#!/usr/bin/env Rscript
library(karyoploteR)
library(CopyNumberPlots)

#args <- commandArgs()

#df_cnv <-read.table(args[5], header=TRUE);
s1.calls<-read.table("/beegfs/scratch/ric.cosr/ric.cosr/Menarini/230710_A00626_0642_AHGN5YDRX3/CF/T24_3/T24_3_calls.txt", header=TRUE);
s2.calls<-read.table("/beegfs/scratch/ric.cosr/ric.cosr/Menarini/230710_A00626_0642_AHGN5YDRX3/CF/T24_3/T24_3_calls.txt", header=TRUE);
s3.calls<-read.table("/beegfs/scratch/ric.cosr/ric.cosr/Menarini/230710_A00626_0642_AHGN5YDRX3/CF/T24_3/T24_3_calls.txt", header=TRUE);

#out <- args[6]
out <- "CN_summary.pdf"
title <- "summary"
# print the plot
# gains reddish
# lossed bluish
#pdf(out, 30, 5)
pdf(out, 30, 10)
#kp <- plotKaryotype(chromosomes="chr1")
#kp <- plotKaryotype(chromosomes=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22"), plot.type = 4, main = title)
kp <- plotKaryotype(genome="hg38", chromosomes=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22"), plot.type = 4)


#plotLRR(kp, snps=s1)

#write.table(CNV.calls, file = out, append = FALSE, quote = FALSE, sep = "\t",
#            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
#            col.names = TRUE)



cn.calls <- list("Sample1"=s1.calls, "Sample2"=s2.calls, "Sample3"=s3.calls)
#kp <- plotKaryotype(chromosomes="chr1")
#plotCopyNumberCalls(kp, cn.calls, r1=0.3)

plotCopyNumberCalls(kp, cn.calls, loh.height = 0, r0=0.3,  cn.colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","#9F1111","#911919","#751515","#431919"))
#plotCopyNumberCalls(kp, cn.calls, r0=0, r1=0.20, cn.colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","#9F1111","#911919","#751515","#431919"))
#plotLRR(kp, LRR.calls, r0=0.50, r1=1)
cn.cols <- getCopyNumberColors(colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","#9F1111","#911919","#751515","#431919"))
plotCopyNumberSummary(kp, cn.calls, r1=0.25, direction = "out", gain.color = "red", loss.color = "blue")
legend("top", legend=names(cn.cols), fill = cn.cols, ncol=length(cn.cols))

dev.off()

