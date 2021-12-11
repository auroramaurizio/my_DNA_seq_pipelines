#!/usr/bin/env Rscript
library(karyoploteR)
library(CopyNumberPlots)

args <- commandArgs()

df <-read.table(args[4], header=FALSE);

out <- args[5]
title <- args[6]

#df <-data.frame(dataTable)


print(head(df))

#  V1       V2        V3 V4   V5           V6           V7
#1 10        0 133797422  1 loss 9.230707e-07 1.650300e-06

colnames(df)=c("CNVchr","CNVstart","CNVend","CN","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue")

#add prefix to chromosome name. eg. 1 --> chr1
df$CNVchr <- sub("^", "chr", df$CNVchr )

# remove sex chromosomes from the table
df = df[!grepl("chrX", df$CNVchr),]
df = df[!grepl("chrY", df$CNVchr),]


print(head(df))


# select columns of interest
dftest = df[,c("CNVchr","CNVstart","CNVend", "CN")]
# rename columns
colnames(dftest) = c("chr","start","end","cn")
# check CN range
unique(df$cn)
# thransform the df in a GRanges object
s1.calls <- loadCopyNumberCalls(dftest)

# print the plot
# gains reddish
# lossed bluish
pdf(out, 30, 5)
kp <- plotKaryotype(chromosomes=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22"), plot.type = 4)
#plotLRR(kp, snps=s1)
plotCopyNumberCalls(kp, s1.calls, r0=0, r1=0.10, cn.colors = c("#0000FF", "#5555FF", "#AAAAFF", "pink", "#FFAAAA", "red", "#bf0000"))
cn.cols <- getCopyNumberColors(colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000"))
legend("center", legend=names(cn.cols), fill = cn.cols, ncol=length(cn.cols))


dev.off()

