###############################################################################
# calculate the FGA - FRACTION OF GENOME ALTERED / GII GENOME INSTABILITY INDEX

# from Sequenza output data
###############################################################################

library(ggplot2)
library(pheatmap)
library(openxlsx)
library(dplyr)

datalist = list()


centromeres <- read.xlsx("/Users/maurizio.aurora/Downloads/centromeres.xlsx")
telomeres <- read.xlsx("/Users/maurizio.aurora/Downloads/telomeres.xlsx")
head(centromeres)
head(telomeres)
centromeres_telomeres <- rbind(centromeres, telomeres)
head(centromeres_telomeres)
centromeres_telomeres$chr <- gsub("chr", "", centromeres_telomeres$chr)

# process my saples individually

S086BS <- read.table("086BS_segments.txt", header = T)
S086BS <- S086BS[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S086BS) <- c("chr","start","end","CNV")
S086BS$Patient <- "086BS"
S086BS$Sample <- "086BS"
head(S086BS)

S418FR <- read.table("418FR_segments.txt", header = T)
S418FR <- S418FR[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S418FR) <- c("chr","start","end","CNV")
S418FR$Patient <- "418FR"
S418FR$Sample <- "418FR"
head(S418FR)

S440MB <- read.table("440MB_segments.txt", header = T)
S440MB <- S440MB[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S440MB) <- c("chr","start","end","CNV")
S440MB$Patient <- "440MB"
S440MB$Sample <- "440MB"
head(S440MB)

S742RP <- read.table("742RP_segments.txt", header = T)
S742RP <- S742RP[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S742RP) <- c("chr","start","end","CNV")
S742RP$Patient <- "742RP"
S742RP$Sample <- "742RP"
head(S742RP)

S804CA <- read.table("804CA_segments.txt", header = T)
S804CA <- S804CA[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S804CA) <- c("chr","start","end","CNV")
S804CA$Patient <- "804CA"
S804CA$Sample <- "804CA"
head(S804CA)

S946CA <- read.table("946CA_segments.txt", header = T)
S946CA <- S946CA[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S946CA) <- c("chr","start","end","CNV")
S946CA$Patient <- "946CA"
S946CA$Sample <- "946CA"
head(S946CA)

SS01 <- read.table("S01_segments.txt", header = T)
SS01 <- SS01[, c("chromosome","start.pos","end.pos","CNt")]
colnames(SS01) <- c("chr","start","end","CNV")
SS01$Patient <- "S01"
SS01$Sample <- "S01"
head(SS01)

S283OA <- read.table("283OA_segments.txt", header = T)
S283OA <- S283OA[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S283OA) <- c("chr","start","end","CNV")
S283OA$Patient <- "283OA"
S283OA$Sample <- "283OA"
head(S283OA)

S428LM <- read.table("428LM_segments.txt", header = T)
S428LM <- S428LM[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S428LM) <- c("chr","start","end","CNV")
S428LM$Patient <- "428LM"
S428LM$Sample <- "428LM"
head(S428LM)

S644MD <- read.table("644MD_segments.txt", header = T)
S644MD <- S644MD[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S644MD) <- c("chr","start","end","CNV")
S644MD$Patient <- "644MD"
S644MD$Sample <- "644MD"
head(S644MD)

S778GF <- read.table("778GF_segments.txt", header = T)
S778GF <- S778GF[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S778GF) <- c("chr","start","end","CNV")
S778GF$Patient <- "778GF"
S778GF$Sample <- "778GF"
head(S778GF)

S824PR <- read.table("824PR_segments.txt", header = T)
S824PR <- S824PR[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S824PR) <- c("chr","start","end","CNV")
S824PR$Patient <- "824PR"
S824PR$Sample <- "824PR"
head(S824PR)

S947OS <- read.table("947OS_segments.txt", header = T)
S947OS <- S947OS[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S947OS) <- c("chr","start","end","CNV")
S947OS$Patient <- "947OS"
S947OS$Sample <- "947OS"
head(S947OS)

S326BC <- read.table("326BC_segments.txt", header = T)
S326BC <- S326BC[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S326BC) <- c("chr","start","end","CNV")
S326BC$Patient <- "326BC"
S326BC$Sample <- "326BC"
head(S326BC)

S439LBA <- read.table("439LBA_segments.txt", header = T)
S439LBA <- S439LBA[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S439LBA) <- c("chr","start","end","CNV")
S439LBA$Patient <- "439LBA"
S439LBA$Sample <- "439LBA"
head(S439LBA)

S736TG <- read.table("736TG_segments.txt", header = T)
S736TG <- S736TG[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S736TG) <- c("chr","start","end","CNV")
S736TG$Patient <- "736TG"
S736TG$Sample <- "736TG"
head(S736TG)

S798GI <- read.table("798GI_segments.txt", header = T)
S798GI <- S798GI[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S798GI) <- c("chr","start","end","CNV")
S798GI$Patient <- "798GI"
S798GI$Sample <- "798GI"
head(S798GI)

S889VAC <- read.table("889VAC_segments.txt", header = T)
S889VAC <- S889VAC[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S889VAC) <- c("chr","start","end","CNV")
S889VAC$Patient <- "889VAC"
S889VAC$Sample <- "889VAC"
head(S889VAC)

S948RG <- read.table("948RG_segments.txt", header = T)
S948RG <- S948RG[, c("chromosome","start.pos","end.pos","CNt")]
colnames(S948RG) <- c("chr","start","end","CNV")
S948RG$Patient <- "948RG"
S948RG$Sample <- "948RG"
head(S948RG)


cnv <- rbind(S086BS, S418FR, S440MB, S742RP, S804CA, S946CA, SS01,
      S283OA, S428LM, S644MD, S778GF, S824PR, S947OS, S326BC,
      S439LBA, S736TG, S798GI, S889VAC, S948RG)

# Filter out rows from summary that intersect with centromeres and telomeres
summary <- cnv %>%
  filter(!apply(., 1, function(row) {  # Use . to refer to the data frame
    any(
      centromeres_telomeres$chr == row['chr'] & 
        centromeres_telomeres$Start <= row['end'] & 
        centromeres_telomeres$End >= row['start']
    )
  }))



summary <- cnv
df_ratio = summary[!grepl("X", summary$chr),]
df_ratio = summary[!grepl("Y", summary$chr),]
dftest_ratio = df_ratio
head(dftest_ratio)

dftest_ratio$length = dftest_ratio$end -  dftest_ratio$start
head(dftest_ratio)
unique(dftest_ratio$Sample)
total_genome_size= 3209286105


datalist = list()
for (i in unique(dftest_ratio$Sample) ) {
  test = dftest_ratio[grepl(i, dftest_ratio$Sample),]
  head(test)
  # sum the total length
  all =  3209286105
  gain = test[test$CNV > 2, ]
  tot_gain = sum(gain[, 'length'])
  loss = test[test$CNV < 2, ]
  tot_loss = sum(loss[, 'length'])
  #sum gain loss
  sum = tot_gain + tot_loss
  # fraction 
  GII = sum/all
  dat <- data.frame(i, GII)
  colnames(dat)=c("cell","GII")
  datalist[[i]] <- dat
}

head(datalist)

big_data = do.call(rbind, datalist) 

head(big_data)

colnames(big_data)=c("cell","GII")
big_data$Group <- big_data$cell
head(big_data)
metadata <- read.xlsx("/Users/maurizio.aurora/ECRIN_metadata.xlsx")
combine <- merge(big_data,metadata, by = "Group", all.x = TRUE)
combined <- unique(combine)
head(combined)

boxplot(combined$GII)

head(combined,2)

#combined_tp <- combined[combined$GII < 0.3, ]
combined_tp <- combined
#table(combined_tp$Group)

#combined_tp <- combined_tp[!grepl("670CR", combined_tp$Group), ]

head(combined_tp)
head(combined_tp)
library(ggplot2)
# Basic violin plot
p <- ggplot(combined_tp, aes(x=Disease, y=GII, fill=Disease)) + 
  geom_violin() +  
  geom_boxplot(width=0.1) + 
  scale_fill_manual(values = c("MBL" = "orange", "CLL" = "red")) + 
  theme_minimal()

library(ggpubr)

pdf("GII_Disease_ecrin.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none") 
dev.off()




# Example plot with boxplot inside the violin
# Create the plot with correct dodging for both violin and boxplot
p <- ggplot(combined_tp, aes(x=Disease, y=GII, fill=Sex)) + 
  geom_violin(position = position_dodge(width = 0.9), trim = FALSE) +  # Violin plot with dodging by Sex
  geom_boxplot(width=0.1, position = position_dodge(width = 0.9)) +    # Boxplot with matching dodging
  scale_fill_manual(values = c("M" = "lightblue", "F" = "pink")) +     # Custom colors for Sex
  theme_minimal()


p <- ggplot(combined_tp, aes(x=Disease, y=GII, fill=Sex)) + 
  geom_violin(position = position_dodge(width = 0.9), trim = FALSE) +  # Violin plot with dodging by Sex
  geom_boxplot(width=0.1, position = position_dodge(width = 0.9)) +    # Boxplot with matching dodging
  scale_fill_manual(values = c("M" = "lightblue", "F" = "pink")) +     # Custom colors for Sex
  theme_minimal()



pdf("GII_Sex_ecrin.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()



combined_tp$Patient <- combined_tp$Group
combined_tp <- combined_tp[order(combined_tp$Disease), ]
combined_tp$Patient <- factor(combined_tp$Patient, levels = unique(combined_tp$Patient[order(combined_tp$Disease)]))


p <- ggplot(combined_tp, aes(x=Patient, y=GII, fill=Disease)) + 
  geom_violin() +
  geom_boxplot(width=0.1, position = position_dodge(width = 0.9)) +
  scale_fill_manual(values = c("MBL" = "orange", "CLL" = "red")) + 
  theme(
    strip.text = element_text(size=25),
    text = element_text(size=20),
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels
  )

# Save to PDF
pdf("GII_patient_Disease.pdf", 15, 4)
print(p)
dev.off()

combined_tp <- combined_tp[!grepl("670CR", combined_tp$Sample), ]

combined_tp <- combined_tp[order(combined_tp$Sex), ]
combined_tp$Sex <- factor(combined_tp$Sex, levels = unique(combined_tp$Sex))

# Create the Patient factor based on the ordering of Sex
combined_tp$Patient <- factor(combined_tp$Patient, 
                              levels = unique(combined_tp$Patient[order(combined_tp$Sex)]))

# Create the plot
p <- ggplot(combined_tp, aes(x=Patient, y=GII, fill=Sex)) + 
  geom_violin() +
  geom_boxplot(width=0.1, position = position_dodge(width = 0.9)) +
  scale_fill_brewer(palette="Dark2") +
  scale_fill_manual(values = c("M" = "lightblue", "F" = "pink")) +   
  theme(
    strip.text = element_text(size=25),
    text = element_text(size=20),
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels
  )

# Save to PDF
pdf("GII_patient_Sex.pdf", 15, 4)
print(p)
dev.off()

getwd()

write.xlsx(combined_tp, "ECRIN_GII.xlsx")
