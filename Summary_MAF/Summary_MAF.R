#lovely package to summaryze maf info https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html

library(maftools)

ESOCA20 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/VEP/MAF/DellabonaP_1153_NeoAg_esophagusK/MAFCALL_collect_overlap/ESOCA20_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA22 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/VEP/MAF/DellabonaP_1153_NeoAg_esophagusK/MAFCALL_collect_overlap/ESOCA22_somatic.filtered.COSMIC.funcotator.maf') 
ESOCA24 = read.maf('/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/ESOCA_mutect/VEP/MAF/DellabonaP_1153_NeoAg_esophagusK/MAFCALL_collect_overlap/ESOCA24_somatic.filtered.COSMIC.funcotator.maf') 

MAF_DellabonaP_1153_NeoAg_esophagusK = c(ESOCA20, ESOCA22, ESOCA24)


merge_DellabonaP_1153_NeoAg_esophagusK = maftools:::merge_mafs(MAF_DellabonaP_1153_NeoAg_esophagusK)

laml.maf = merge_DellabonaP_1153_NeoAg_esophagusK 

pdf("plotmafSummary_MAF_DellabonaP_1153_NeoAg_esophagusK_correct_overlap.pdf")
plotmafSummary(maf = laml.maf, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE, showBarcodes = T)
dev.off()

pdf("oncoplot_MAF_DellabonaP_1153_NeoAg_esophagusK_WES_new_1.pdf")
oncoplot(maf = laml.maf, top = 10)
dev.off()


laml.titv = titv(maf = laml.maf, plot = FALSE, useSyn = TRUE)

pdf("plotTiTv_MAF_DellabonaP_1153_NeoAg_esophagusK_WES_new_1.pdf")
plotTiTv(res = laml.titv)
dev.off()


