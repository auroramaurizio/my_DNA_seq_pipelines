#summarize maf

#https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html
library(maftools) 



#MAF_DellabonaP_1560_1561_WES


ESOCA35 = read.maf('ESOCA35_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA37 = read.maf('ESOCA37_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA39 = read.maf('ESOCA39_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA40 = read.maf('ESOCA40_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA41 = read.maf('ESOCA41_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA43 = read.maf('ESOCA43_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA45 = read.maf('ESOCA45_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA48 = read.maf('ESOCA48_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA49 = read.maf('ESOCA49_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA51 = read.maf('ESOCA51_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA52 = read.maf('ESOCA52_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA54 = read.maf('ESOCA54_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA55 = read.maf('ESOCA55_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA57 = read.maf('ESOCA57_somatic.filtered.COSMIC.funcotator.maf') 



MAF_DellabonaP_1560_1561_WES = c(ESOCA35, ESOCA37, ESOCA39, ESOCA40, ESOCA41, 
                                 ESOCA43, ESOCA45, ESOCA48, ESOCA49, ESOCA51,
                                 ESOCA52,ESOCA54,ESOCA55,ESOCA57)


merge_DellabonaP_1560_1561_WES = maftools:::merge_mafs(MAF_DellabonaP_1560_1561_WES)

laml.maf = merge_DellabonaP_1560_1561_WES 
#Shows sample summary.
getSampleSummary(laml.maf)
#Shows gene summary.
getGeneSummary(laml)


pdf("plotmafSummary_MAF_DellabonaP_1560_1561_WES_clip.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = FALSE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE, showBarcodes = T)
dev.off()

