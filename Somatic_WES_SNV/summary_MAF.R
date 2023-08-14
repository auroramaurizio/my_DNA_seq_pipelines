#summarize maf

#https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html



#if (!require("BiocManager"))
#  install.packages("BiocManager")
#BiocManager::install("maftools")

#install.packages('R.utils')

library(maftools)


library(maftools)


setwd="/Users/maurizio.aurora/Downloads"
getwd()

ESOCA20 = read.maf('ESOCA20_somatic.filtered.COSMIC.funcotator.maf') 

getSampleSummary(ESOCA20)
getGeneSummary(ESOCA20)

?getSampleSummary

1 #version 2.4
14 3'Flank
  34 3'UTR
19 5'Flank
  18 5'UTR
66 Frame_Shift_Del #
3 Frame_Shift_Ins #
16 IGR
10 In_Frame_Del #
447 Intron
233 Missense_Mutation #
11 Nonsense_Mutation #
35 RNA
100 Silent
32 Splice_Region
4 Splice_Site #
1 Variant_Classification

66+3+10+233+11+4
#Shows gene summary.
getGeneSummary(laml.maf)
#shows clinical data associated with samples
getClinicalData(laml.maf)
#Shows all fields in MAF
getFields(laml)
#Writes maf summary to an output file with basename laml.
write.mafSummary(maf = laml.maf, basename = 'laml')



#MAF_DellabonaP_480_NeoAg_esophagusK

ESOCA8 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/MAF_esophagusK/ESOCA8_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA10 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/MAF_esophagusK/ESOCA10_somatic.filtered.COSMIC.funcotator.maf') 

MAF_480_NeoAg_esophagusK = c("ESOCA8", "ESOCA10")


ESOCA20 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/MAF_esophagusK/ESOCA20_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA22 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/MAF_esophagusK/ESOCA22_somatic.filtered.COSMIC.funcotator.maf') 


MAF_1153_NeoAg_esophagusK = c(ESOCA20, ESOCA22)





laml.maf = MAF_1153_NeoAg_esophagusK 
getSampleSummary(laml.maf)
#Shows gene summary.
getGeneSummary(laml.maf)
#shows clinical data associated with samples
getClinicalData(laml.maf)
#Shows all fields in MAF
getFields(laml)
#Writes maf summary to an output file with basename laml.
write.mafSummary(maf = laml.maf, basename = 'laml')

getwd()

pdf("plotmafSummary_MAF_1153_NeoAg_esophagusK.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
dev.off()

pdf("oncoplot_MAF_1153_NeoAg_esophagusK_WES.pdf")
oncoplot(maf = laml.maf, top = 10)
dev.off()


laml.titv = titv(maf = laml.maf, plot = FALSE, useSyn = TRUE)

pdf("plotTiTv_MAF_1153_NeoAg_esophagusK_WES.pdf")
plotTiTv(res = laml.titv)
dev.off()


######


laml.maf = MAF_480_NeoAg_esophagusK 
getSampleSummary(laml.maf)
#Shows gene summary.
getGeneSummary(laml.maf)
#shows clinical data associated with samples
getClinicalData(laml.maf)
#Shows all fields in MAF
getFields(laml)
#Writes maf summary to an output file with basename laml.
write.mafSummary(maf = laml.maf, basename = 'laml')

getwd()

pdf("plotmafSummary_MAF_480_NeoAg_esophagusK.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
dev.off()

pdf("oncoplot_MAF_480_NeoAg_esophagusK.pdf")
oncoplot(maf = laml.maf, top = 10)
dev.off()


laml.titv = titv(maf = laml.maf, plot = FALSE, useSyn = TRUE)

pdf("plotTiTv_MAF_480_NeoAg_esophagusK.pdf")
plotTiTv(res = laml.titv)
dev.off()


######



alltogether = c(MAF_480_NeoAg_esophagusK, MAF_1153_NeoAg_esophagusK)

merge_alltogether = maftools:::merge_mafs(alltogether)

laml.maf = merge_alltogether 
getSampleSummary(laml.maf)
#Shows gene summary.
getGeneSummary(laml.maf)
#shows clinical data associated with samples
getClinicalData(laml.maf)
#Shows all fields in MAF
getFields(laml)
#Writes maf summary to an output file with basename laml.
write.mafSummary(maf = laml.maf, basename = 'laml')

getwd()

pdf("plotmafSummary_MAF_all.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
dev.off()

pdf("oncoplot_MAF_all.pdf")
oncoplot(maf = laml.maf, top = 10)
dev.off()

laml.titv = titv(maf = laml.maf, plot = FALSE, useSyn = TRUE)

pdf("plotTiTv_MAF_all.pdf")
plotTiTv(res = laml.titv)
dev.off()


