#!/usr/bin/env Rscript
library(karyoploteR)

args <- commandArgs()

df <-read.table(args[4], header=FALSE);

out <- args[5]
title <- args[6]

#df <-data.frame(dataTable)

print(head(df))

#  V1       V2        V3 V4   V5           V6           V7
#1 10        0 133797422  1 loss 9.230707e-07 1.650300e-06

colnames(df)=c("CNVchr","CNVstart","CNVend","CN","status", "genotype","uncertainty","WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue")

# remove sex chromosomes from the table

df = df[!grepl("chrX", df$CNVchr),]
df = df[!grepl("chrY", df$CNVchr),]

#add prefix to chromosome name. eg. 1 --> chr1
df$CNVchr <- sub("^", "chr", df$CNVchr )


gg = df[grep("gain", df$status), ] 


ll = df[grep("loss", df$status), ]  


gains <- toGRanges(data.frame(chr=gg$CNVchr, start=gg$CNVstart,
                      end=gg$CNVend))
losses <- toGRanges(data.frame(chr=ll$CNVchr, start=ll$CNVstart,
                       end=ll$CNVend))


pdf(out)

#kp <- plotKaryotype(genome="hg38")
kp <- plotKaryotype(genome="hg38", plot.type=1, chromosomes=c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8", "chr9", "chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22"), main = title)

#kp <- plotKaryotype(genome="hg38", plot.type=1, main = title)

kpPlotRegions(kp, gains, col="#FFAACC")
kpPlotRegions(kp, losses, col="#66B2FF")

dev.off()


