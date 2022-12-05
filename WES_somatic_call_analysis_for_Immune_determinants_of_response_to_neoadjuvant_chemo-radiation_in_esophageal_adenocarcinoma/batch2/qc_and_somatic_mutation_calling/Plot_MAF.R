#summarize maf

#https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html
#library("CNAqc")
require(dplyr) 
require(vcfR) 



ESOCA20 = read.maf('ESOCA20_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA22 = read.maf('ESOCA22_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA24 = read.maf('ESOCA24_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA25 = read.maf('ESOCA25_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA26 = read.maf('ESOCA26_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA27 = read.maf('ESOCA27_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA29 = read.maf('ESOCA29_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA30 = read.maf('ESOCA30_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA31 = read.maf('ESOCA31_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA33 = read.maf('ESOCA33_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA34 = read.maf('ESOCA34_somatic.filtered.COSMIC.funcotator.maf') 


MAF_DellabonaP_1153_NeoAg_esophagusK = c(ESOCA20, ESOCA22, ESOCA24, ESOCA25, ESOCA26, 
                                         ESOCA27, ESOCA29, ESOCA30, ESOCA31, ESOCA33, 
                                         ESOCA34)



merge_DellabonaP_1560_1561_WES = maftools:::merge_mafs(MAF_DellabonaP_1153_NeoAg_esophagusK)

laml.maf = merge_DellabonaP_1560_1561_WES 
getSampleSummary(laml.maf)


pdf("plotmafSummary_MAF_DellabonaP_1560_1561_WES_clip.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = FALSE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE, showBarcodes = T)
dev.off()


