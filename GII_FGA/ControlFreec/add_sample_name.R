#!/usr/bin/env Rscript
library(karyoploteR)
library(plyr)
args <- commandArgs()
print(args)

out <- args[5]
title <- args[6]


args <- commandArgs()

dataTable <- read.table(args[4], header=FALSE)
cnvs<- data.frame(dataTable)
colnames(cnvs)=c("CNVchr","CNVstart","CNVend","copy_number","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue")
cnvs = cnvs[!grepl("CNVchr", cnvs$CNVchr),]
#cnvs = cnvs[!grepl("Y", cnvs$CNVchr),]

print(head(cnvs))
cnvs$sample = title
cnvs = cnvs[,0:8]
colnames(cnvs)<-NULL
print(head(cnvs))
write.table(cnvs, file=args[5],sep="\t",quote=F,row.names=F)
