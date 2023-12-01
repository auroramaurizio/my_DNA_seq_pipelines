library(openxlsx)
library(stringr)
library(pheatmap)
library("ggplot2")


# prepare the ControlFreeC input for the heatmap

###########################################################################

touch merged.txt

# Loop through the files, concatenate, and add the prefix name
for file in *_*_markdup.bam_CNVs.p.value.filtered.txt; do
  # Extract the prefix name (everything before the second underscore)
  prefix_name=$(echo "$file" | awk -F_ '{print $1"_"$2}')
  
  # Concatenate the file and add the prefix name as a new column
  awk -v prefix="$prefix_name" '{print prefix, $0}' "$file" >> merged.txt
done

grep -v "#" merged.txt > combined.txt
# then remove useless columns and rename them so that you have:
chr	Start	End	CNV	P	Sample	Group	Rep
############################################################################



#------------
# FUNCTIONS -------------
#-------------------------------

################
cnvPfilt <- function(cnv, ratios, P_threshold = .01, binSize=5e3, chrNames = c(1:22,'X')) {
  #------
  cnvBins <- cnv
  cnvBins$Start <- round(cnvBins$Start/binSize)
  cnvBins$End <- round(cnvBins$End/binSize)
  chrBins <- sapply(chrNames, function(chrName) 
    round(max(
      c(subset(ratios, Chromosome == chrName)$Start/binSize,
        subset(cnvBins, chr == chrName)$End/binSize)
    )))
  #------
  df_names <- unlist(lapply(seq_along(chrBins), function(i) 
    apply(data.frame(
      Chr=names(chrBins)[i], 
      Start=sapply((0:(chrBins[i]-1))* binSize, deparse, control = "digits17"),
      End=sapply((1:(chrBins[i]))* binSize, deparse, control = "digits17")
    ), 1, paste, collapse='-')))
  #------
  sNames <- unique(cnv$Sample)
  cnvDF <- do.call('rbind', 
                   lapply(1:length(chrNames), function(chrName) {
                     chrDF <- sapply(sNames, function(s) {
                       tmp <- rep(2, chrBins[chrName])
                       cnvDF <- subset(cnvBins, Sample == s & chr == chrName)
                       if(nrow(cnvDF)>0)
                         for(i in 1:nrow(cnvDF))
                           tmp[(cnvDF[i,]$Start):(cnvDF[i,]$End)] <- cnvDF[i,]$CNV
                       return(tmp)
                     })
                   }))
  rownames(cnvDF) <- df_names
  return(cnvDF)
}

###############
cnvPlot <- function(cnv_mat, chrNames = c(1:22,'X'), ...) {
  # obtain chromosomes relative to each row
  row_chromosome <- sapply(strsplit(rownames(cnv_mat), '-'),'[',1)
  # select only rows corresponding to selected chrNames
  idx <- row_chromosome %in% chrNames
  cnv_mat <- cnv_mat[idx,]
  row_chromosome <- row_chromosome[idx]
  #------
  ann_row <- data.frame(Chr=factor(row_chromosome, levels = chrNames), 
                        row.names = rownames(cnv_mat))
  #------
  pheatmap(cnv_mat, cluster_rows = F,
           cluster_cols = T,
           annotation_row = ann_row,
           annotation_colors = annotation_colors,
           show_rownames = F,
           gaps_row = cumsum(table(ann_row$Chr)),
           gaps_col = 'black', ...)
}





cnv = read.xlsx("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/metadata/BLOOD_CNV_POS/combine/combined_blood.xlsx")
ratios = read.table("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/metadata/BLOOD_CNV_POS/combine/blood_ratios.txt", header = F)
colnames(ratios) = c("Chromosome","Start","Ratio","MedianRatio","CopyNumber")


cnv_01 <- cnvPfilt(cnv, ratios, P_threshold = 0.01, binSize = 1e6)
cnv_01_1e6 = cnv_01[!grepl("X", rownames(cnv_01)), ]
write.xlsx(cnv_01_1e6,"cnvpos_blood_bin1e6.xlsx", rowNames = T)

rownames(blood75_YES) = blood75_YES$cell

blood75_YES$age <- cut(blood75_YES$AGE, breaks=c(0,45,55,65,75,85,95))
blood75_YES$MULTIFOCAL <- factor(blood75_YES$MULTIFOCAL,
                                 levels=c("0", "1"))

unique(blood75_YES$TREATED)

blood75_YES$TREATED <- factor(blood75_YES$TREATED,
                              levels=c("0", "1"))

blood75_YES$SEX <- factor(blood75_YES$SEX,
                          levels=c("M", "F"))

blood75_YES$DAPI <- factor(blood75_YES$DAPI,
                           levels=c("0", "1"))


blood75_YES$"EPCAM/CLAU" <- factor(blood75_YES$"EPCAM/CLAU",
                                   levels=c("0", "1"))


blood75_YES$DAPI <- factor(blood75_YES$DAPI,
                           levels=c("1"))

blood75_YES$Vim <- factor(blood75_YES$Vim,
                          levels=c("0", "1"))

blood75_YES$IMMUNO <- factor(blood75_YES$IMMUNO,
                             levels=c("0", "1", "NA"))

blood75_YES$SMOKER <- factor(blood75_YES$SMOKER,
                             levels=c("S", "ES", "NS", "NA"))


blood75_YES$tumor <- factor(blood75_YES$tumor,
                            levels=c("MIBC (T2b)+adeno prostatico",
                                     "MIBC (T3b)",
                                     "Negativo",
                                     "Negativo/atipie",
                                     "NMIBC (Ta)",
                                     "NMIBC (T1)" ))



ann_col = blood75_YES[,c("patient", "DAPI",
                         "Vim","run","SEX",
                         "SMOKER","age","TREATED",
                         "MULTIFOCAL","IMMUNO" ,"tumor", "other_tumor" )]

unique(blood75_YES$patient)


annotation_colors = list(
  patient = c("180620" = "#CC0000",
              "240621" = "#CCCC00",
              "070521" = "#00CC00",
              "141220" = "#00CCCC",
              "191021" = "#0000CC",
              "210121" = "#CC00CC",
              "DER290720" = "#606060",
              "050221" = "#FF99FF",
              "060721" = "#CCFFFF",
              "080421" = "#FFFF99",
              "100321" = "grey",
              "160321" = "#0080FF",
              "230621" = "#660066",
              "260421" = "#CC0000",
              "300721" = "#FF66B2"),
  tumor = c("MIBC (T2b)+adeno prostatico"="#FF66B2",
            "MIBC (T3b)"="#CC0000",
            "Negativo" = "#660066", 
            "Negative/atipie"="#66CC00",
            "Negativo/atipie"="#CC6600",
            "NMIBC (Ta)"= "#6666FF",
            "NMIBC (T1)"= "#FFCC99"),
  run = c("210427_A00626_0270_BHLFM3DMXX"="#FF66B2",
          "211012_A00626_0347_AHLGCKDRXY"="#CC0000",
          "220105_A00626_0386_AHTMWGDRXY" = "#660066", 
          "210512_A00626_0275_BHTYTWDMXX"="#66CC00",
          "211104_A00626_0360_AHMVY5DRXY"="#CC6600",
          "210616_A00626_0290_AHG5VVDRXY"= "#6666FF",
          "201211_A00626_0211_BHVWTFDRXX"= "#FFCC99",
          "210422_A00626_0268_BH2H53DRXY" = "#FFFF33",
          "221117_A00626_0528_AHT7WYDRX2" = "#FF9933",
          "210622_A00626_0292_BHG7MHDRXY" = "#006633",
          "210930_A00626_0343_AHKMCGDRXY" = "#FF3333",
          "221028_A00626_0519_AHL57FDRX2" = "#66B2FF"),
  DAPI = c("1"="black"),
  Vim = c("0"="gray", "1"="black"),
  'EPCAM/CLAU' = c("0"="gray", "1"="black"),
  IMMUNO = c("0"="gray", "1"="black"),
  TREATED = c("0"="gray", "1"="black"),
  MULTIFOCAL = c("0"="gray", "1"="black"),
  SMOKER = c("S"="gray", "NS"="black", "ES" = "brown"),
  SEX = c(M="#66B2FF", F="pink"),
  other_tumor = c(NO="gray", YES="black"),
  age =  c("(0,45]" = "yellow", "(45,55]" = "orange", "(55,65]" = "red", "(65,75]" = "#FF33FF", "(75,85]" = "#99004C", "(85,95]" = "#330019" ))




ph_cnv_01_1e6_blood <- cnvPlot(cnv_01_1e6, 
                               annotation_col = ann_col, 
                               main = 'BLOOD CNV+',
                               breaks = seq(0,6,length.out=101),
                               legend=TRUE,
                               annotation_legend=TRUE)

pdf("Heatmap_CNVpos_blood.pdf", 15, 24)
ph_cnv_01_1e6_blood
dev.off()




