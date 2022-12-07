#summarize maf

#https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html
library("maftools")



ESOCA8 = read.maf('ESOCA8_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA10 = read.maf('ESOCA10_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA11 = read.maf('ESOCA11_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA12 = read.maf('ESOCA12_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA15 = read.maf('ESOCA15_somatic.filtered.COSMIC.funcotator.maf')
ESOCA17 = read.maf('ESOCA17_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA18 = read.maf('ESOCA18_somatic.filtered.COSMIC.funcotator.maf') 

MAF_DellabonaP_480_NeoAg_esophagusK = c(ESOCA8, ESOCA10, ESOCA11, ESOCA12, ESOCA15, ESOCA17, ESOCA18)


merge_DellabonaP_480_NeoAg_esophagusK = maftools:::merge_mafs(MAF_DellabonaP_480_NeoAg_esophagusK)

laml.maf = merge_DellabonaP_480_NeoAg_esophagusK
#Shows sample summary.
getSampleSummary(laml.maf)
#Shows gene summary.
getGeneSummary(laml)

pdf("plotmafSummary_MAF_DellabonaP_480_NeoAg_esophagusK.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = FALSE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE, showBarcodes = T)
dev.off()

