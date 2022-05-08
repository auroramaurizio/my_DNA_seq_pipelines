suppressMessages(library(openxlsx))
require(vcfR)
setwd("/Users/maurizio.aurora/Documents/ip0/KASP")

############################
#process the ratio dataframe
############################

list.files()
########

UPN02_DG = vcfR::read.vcfR("UPN02_DG_KASP.vcf.gz")
UPN02_PG = vcfR::read.vcfR("UPN02_PG_KASP.vcf.gz")
UPN02_PRE = vcfR::read.vcfR("UPN02_PRE_KASP.vcf.gz")
UPN02_REL = vcfR::read.vcfR("UPN02_REL_KASP.vcf.gz")

UPN03_DG = vcfR::read.vcfR("UPN03_DG_KASP.vcf.gz")
UPN03_PG = vcfR::read.vcfR("UPN03_PG_KASP.vcf.gz")
UPN03_PRE = vcfR::read.vcfR("UPN03_PRE_KASP.vcf.gz")
UPN03_REL = vcfR::read.vcfR("UPN03_REL_KASP.vcf.gz")

UPN04_DIA = vcfR::read.vcfR("UPN04_DIA_KASP.vcf.gz")
UPN04_DG = vcfR::read.vcfR("UPN04_DG_KASP.vcf.gz")
UPN04_PG = vcfR::read.vcfR("UPN04_PG_KASP.vcf.gz")
UPN04_PRE = vcfR::read.vcfR("UPN04_PRE_KASP.vcf.gz")
UPN04_REL = vcfR::read.vcfR("UPN04_REL_KASP.vcf.gz")

UPN05_DG = vcfR::read.vcfR("UPN05_DG_KASP.vcf.gz")
UPN05_PG = vcfR::read.vcfR("UPN05_PG_KASP.vcf.gz")
UPN05_PRE = vcfR::read.vcfR("UPN05_PRE_KASP.vcf.gz")
UPN05_REL = vcfR::read.vcfR("UPN05_REL_KASP.vcf.gz")

UPN06_DG = vcfR::read.vcfR("UPN06_DG_KASP.vcf.gz")
UPN06_PG = vcfR::read.vcfR("UPN06_PG_KASP.vcf.gz")
UPN06_PRE = vcfR::read.vcfR("UPN06_PRE_KASP.vcf.gz")
UPN06_REL = vcfR::read.vcfR("UPN06_REL_KASP.vcf.gz")


dfList = list(
  UPN02_DG,
  UPN02_PG,
  UPN02_PRE,
  UPN02_REL,
  UPN03_DG,
  UPN03_PG,
  UPN03_PRE,
  UPN03_REL,
  UPN04_DIA,
  UPN04_DG,
  UPN04_PG,
  UPN04_PRE,
  UPN04_REL,
  UPN05_DG,
  UPN05_PG,
  UPN05_PRE,
  UPN05_REL,
  UPN06_DG,
  UPN06_PG,
  UPN06_PRE,
  UPN06_REL
)


names(dfList)<- list(
  "UPN02_DG",
  "UPN02_PG",
  "UPN02_PRE",
  "UPN02_REL",
  "UPN03_DG",
  "UPN03_PG",
  "UPN03_PRE",
  "UPN03_REL",  
  "UPN04_DIA",
  "UPN04_DG",
  "UPN04_PG",
  "UPN04_PRE",
  "UPN04_REL", 
  "UPN05_DG",
  "UPN05_PG",
  "UPN05_PRE",
  "UPN05_REL", 
  "UPN06_DG",
  "UPN06_PG",
  "UPN06_PRE",
  "UPN06_REL" 
)

length(dfList)

datalist = list()


for (i in names(dfList)) {
  vcf <- dfList[[i]]
  df_temp = vcfR2tidy(vcf)
  df = df_temp$fix
  # select columns of interest
  dfsub = df[,c("CHROM","POS","AF")]
  # add the length coord to dftest
  dfsub$SAMPLE = i
  dfsub$LOC = paste(dfsub$CHROM, dfsub$POS, sep="_")
  dfn = dfsub[,c("LOC","AF","SAMPLE")]
  dat <- data.frame(dfn)
  colnames(dat)=c("LOC","AF","SAMPLE")
  datalist[[i]] <- dat
}




big_data = do.call(rbind, datalist) 
tail(big_data)
colnames(big_data)=c("LOC","AF","SAMPLE")

grouped_by_gene  <- big_data %>%
  group_by(LOC) %>%
  summarise(temp = toString(SAMPLE)) %>%
  ungroup()

head(grouped_by_gene)

colnames(grouped_by_gene) = c("LOC", "sample_SNP")

grouped_by_gene$number_of_samples = count.fields(textConnection(grouped_by_gene$sample_SNP), sep = ",")

head(grouped_by_gene)

write.xlsx(grouped_by_gene,file= "summary_KASP.xlsx")


library(dplyr)
library(tidyr)

library(reshape2)


mat <- acast(big_data, LOC ~ SAMPLE, function(x) {sort(as.character(x))[1]},
      value.var = 'AF', fill = '0')

class(mat) <- "numeric"

pheatmap(mat, show_rownames = F, cluster_rows = F, filename = 'Heatmap_KASP_clusterCols.pdf', cluster_cols = T)

pheatmap(mat, show_rownames = F, cluster_rows = T, filename = 'Heatmap_KASP_clusterRows.pdf')

write.xlsx(mat,file= "mat_KASP.xlsx")


