#!/usr/bin/env Rscript
library(karyoploteR)
library(CopyNumberPlots)

args <- commandArgs()

df_ratio <-read.table(args[4], header=TRUE);
df_cnv <-read.table(args[5], header=TRUE);

out <- args[6]
title <- args[7]


############################
#process the ratio dataframe
############################
df_ratio$Chromosome <- sub("^", "chr", df_ratio$Chromosome )

# remove sex chromosomes from the table
df_ratio = df_ratio[!grepl("chrX", df_ratio$Chromosome),]
df_ratio = df_ratio[!grepl("chrY", df_ratio$Chromosome),]

#print(head(df_ratio))

# select columns of interest
dftest_ratio = df_ratio[,c("Chromosome","Start","Ratio")]
# add the End coord to dftest
dftest_ratio$End = dftest_ratio$Start+1
dftest_ratio$LR = log2(dftest_ratio$Ratio)
dftest_ratio = dftest_ratio[,c("Chromosome","Start","End","LR")]
print(head(dftest_ratio))
#rename the columns
colnames(dftest_ratio) = c("chr","start","end","lrr")
# thransform the df in a GRanges object
LRR.calls <- loadSNPData(dftest_ratio)

############################
#process the cnv dataframe
############################

print(head(df_cnv))

colnames(df_cnv)=c("CNVchr","CNVstart","CNVend","CN","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue")

print(head(df_cnv))

#add prefix to chromosome name. eg. 1 --> chr1
df_cnv$CNVchr <- sub("^", "chr", df_cnv$CNVchr )

# remove sex chromosomes from the table
df_cnv = df_cnv[!grepl("chrX", df_cnv$CNVchr),]
df_cnv = df_cnv[!grepl("chrY", df_cnv$CNVchr),]


print(head(df_cnv))


# select columns of interest
dftest_cnv = df_cnv[,c("CNVchr","CNVstart","CNVend", "CN")]
# rename columns
colnames(dftest_cnv) = c("chr","start","end","cn")
# check CN range
unique(df_cnv$cn)
# thransform the df in a GRanges object
CNV.calls <- loadCopyNumberCalls(dftest_cnv)

##############


# print the plot
# gains reddish
# lossed bluish
pdf(out, 30, 5)
kp <- plotKaryotype(chromosomes=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22"), plot.type = 4, main = title)
#plotLRR(kp, snps=s1)


#plotCopyNumberCalls(kp, CNV.calls, r0=0, r1=0.20, cn.colors = c("#0000FF", "#5555FF", "#AAAAFF", "pink", "#FFAAAA", "red", "#bf0000"))
plotCopyNumberCalls(kp, CNV.calls, r0=0, r1=0.20, cn.colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","#9F1111","#911919","#751515","#431919"))
plotLRR(kp, LRR.calls, r0=0.50, r1=1)
#cn.cols <- getCopyNumberColors(colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","Burgundy","Carmine","Sangria"))
cn.cols <- getCopyNumberColors(colors = c("#0000FF", "lightblue", "white", "pink", "#FFAAAA", "red", "#bf0000","#9F1111","#911919","#751515","#431919"))
legend("center", legend=names(cn.cols), fill = cn.cols, ncol=length(cn.cols))

dev.off()

