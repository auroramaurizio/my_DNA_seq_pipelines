library(maftools)
library(openxlsx)
setwd("/Users/maurizio.aurora/Downloads/gistic")



all.lesions <- "all_lesions.conf_90-2.txt"
amp.genes <- "amp_genes.conf_90-2.txt"
del.genes <- "del_genes.conf_90-2.txt"
scores.gis <- "scores-2.gistic"

ClinData = read.xlsx("ClinData.xlsx")
library(stringr)
ClinData$numero.PTCL <- str_replace(ClinData$numero.PTCL, "A", "")
ClinData$Tumor_Sample_Barcode = ClinData$numero.PTCL
clinical_data = ClinData

laml.gistic = readGistic(gisticAllLesionsFile = all.lesions, gisticAmpGenesFile = amp.genes, gisticDelGenesFile = del.genes, gisticScoresFile = scores.gis, isTCGA = TRUE)

#get some stats
laml.gistic

laml.gistic@data

pdf("gisticChromPlot.pdf",30, 10)
gisticChromPlot(gistic = laml.gistic, markBands = "all")
dev.off()

pdf("gisticBubblePlot.pdf",5, 7)
gisticBubblePlot(gistic = laml.gistic)
dev.off()

#oncoplot

#This is similar to oncoplots except for copy number data.
#One can again sort the matrix according to annotations, if any.

colnames(clinical_data)

pdf("gisticOncoPlot_gender.pdf")
gisticOncoPlot(gistic = laml.gistic, clinicalData = clinical_data,  clinicalFeatures = c('Gender','Diagnosi','LDH_Abnormal','Stage_AA','N_extrasites','Progression','PIT.Score'), sortByAnnotation = TRUE, top = 20)
dev.off()
#gisticOncoPlot(gistic = laml.gistic, clinicalData = clinical_data, clinicalFeatures = 'FAB_classification', sortByAnnotation = TRUE, top = 10)



