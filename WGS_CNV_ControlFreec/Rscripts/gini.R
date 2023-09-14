#!/usr/bin/env Rscript
library(ineq)

args <- commandArgs()

df <-read.table(args[4], header=FALSE);

out <- args[5]
out_file <- args[6]
title <- args[7]


print(head(df))

colnames(df) = c("chr","start","cov")

# remove sex chromosomes from the table

df = df[!grepl("X", df$chr),]
df = df[!grepl("Y", df$chr),]
df = df[!grepl("Un", df$chr),]
df = df[!grepl("random", df$chr),]
df = df[!grepl("EBV", df$chr),]
df = df[!grepl("M", df$chr),]


#add prefix to chromosome name. eg. 1 --> chr1

row.names(df) = paste(df$chr, df$start, sep=":")
coverage=df$cov

write.table(ineq(coverage,type="Gini"),out_file) 

pdf(out)
plot(Lc(coverage))
dev.off()
