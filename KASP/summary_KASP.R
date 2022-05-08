suppressMessages(library(openxlsx))

setwd("/beegfs/scratch/ric.cosr/ric.cosr/DellabonaP/gbprova/CNA/CNVkit/output/tumor")

############################
#process the ratio dataframe
############################

list.files()
########

ESOCA10_OCT = read.table("ESOCA10_OCT_markdup.cns", header = T)
ESOCA17_OCT = read.table("ESOCA17_OCT_markdup.cns", header = T)
ESOCA24T = read.table("ESOCA24T_markdup.cns", header = T)
ESOCA29T = read.table("ESOCA29T_markdup.cns", header = T)
ESOCA34T = read.table("ESOCA34T_markdup.cns", header = T)
ESOCA40_T = read.table("ESOCA40_T_markdup.cns", header = T)
ESOCA48_T = read.table("ESOCA48_T_markdup.cns", header = T)
ESOCA54_T = read.table("ESOCA54_T_markdup.cns", header = T)
ESOCA11_OCT = read.table("ESOCA11_OCT_markdup.cns", header = T)
ESOCA18_OCT = read.table("ESOCA18_OCT_markdup.cns", header = T)
ESOCA25T = read.table("ESOCA25T_markdup.cns", header = T)
ESOCA30T = read.table("ESOCA30T_markdup.cns", header = T)
ESOCA35_T = read.table("ESOCA35_T_markdup.cns", header = T)
ESOCA41_T = read.table("ESOCA41_T_markdup.cns", header = T)
ESOCA49_T = read.table("ESOCA49_T_markdup.cns", header = T)
ESOCA55_T = read.table("ESOCA55_T_markdup.cns", header = T)
ESOCA12_OCT = read.table("ESOCA12_OCT_markdup.cns", header = T)
ESOCA15_OCT= read.table("ESOCA15_OCT_markdup.cns", header = T)
ESOCA20T= read.table("ESOCA20T_markdup.cns", header = T)
ESOCA15_OCT= read.table("ESOCA15_OCT_markdup.cns", header = T)
ESOCA26T= read.table("ESOCA26T_markdup.cns", header = T)
ESOCA31T= read.table("ESOCA31T_markdup.cns", header = T)
ESOCA22T= read.table("ESOCA22T_markdup.cns", header = T)
ESOCA37_T= read.table("ESOCA37_T_markdup.cns", header = T)
ESOCA43_T= read.table("ESOCA43_T_markdup.cns", header = T)
ESOCA51_T= read.table("ESOCA51_T_markdup.cns", header = T)
ESOCA57_T= read.table("ESOCA57_T_markdup.cns", header = T)
ESOCA27T= read.table("ESOCA27T_markdup.cns", header = T)
ESOCA33T= read.table("ESOCA33T_markdup.cns", header = T)
ESOCA39_T= read.table("ESOCA39_T_markdup.cns", header = T)
ESOCA45_T= read.table("ESOCA45_T_markdup.cns", header = T)
ESOCA52_T= read.table("ESOCA52_T_markdup.cns", header = T)
ESOCA8_OCT= read.table("ESOCA8_OCT_markdup.cns", header = T)


dfList = list(
  ESOCA10_OCT,
  ESOCA17_OCT,
  ESOCA24T,
  ESOCA29T,
  ESOCA34T, 
  ESOCA40_T,
  ESOCA48_T, 
  ESOCA54_T,
  ESOCA11_OCT,
  ESOCA18_OCT,
  ESOCA25T,
  ESOCA30T,
  ESOCA35_T,
  ESOCA41_T, 
  ESOCA49_T, 
  ESOCA55_T,
  ESOCA12_OCT,
  ESOCA15_OCT,
  ESOCA20T,
  ESOCA15_OCT,
  ESOCA26T,
  ESOCA31T,
  ESOCA22T,
  ESOCA37_T,
  ESOCA43_T,
  ESOCA51_T,
  ESOCA57_T,
  ESOCA27T,
  ESOCA33T,
  ESOCA39_T,
  ESOCA45_T,
  ESOCA52_T,
  ESOCA8_OCT)



names(dfList)<- list(
  "ESOCA10",
  "ESOCA17",
  "ESOCA24",
  "ESOCA29",
  "ESOCA34", 
  "ESOCA40",
  "ESOCA48", 
  "ESOCA54",
  "ESOCA11",
  "ESOCA18",
  "ESOCA25",
  "ESOCA30",
  "ESOCA35",
  "ESOCA41", 
  "ESOCA49", 
  "ESOCA55",
  "ESOCA12",
  "ESOCA15",
  "ESOCA20",
  "ESOCA15",
  "ESOCA26",
  "ESOCA31",
  "ESOCA22",
  "ESOCA37",
  "ESOCA43",
  "ESOCA51",
  "ESOCA57",
  "ESOCA27",
  "ESOCA33",
  "ESOCA39",
  "ESOCA45",
  "ESOCA52",
  "ESOCA8")

length(dfList)

datalist = list()


for (i in names(dfList)) {
  df_ratio <- dfList[[i]]
  # remove Antitarget from the table
  df_ratio = df_ratio[!grepl("Antitarget", df_ratio$gene),]
  
  #print(head(df_ratio))
  
  # select columns of interest
  dftest_ratio = df_ratio[,c("chromosome","start","end","log2")]
  # add the length coord to dftest
  dftest_ratio$length = dftest_ratio$end -  dftest_ratio$start
  head(dftest_ratio)
  # sum the total length
  all = sum(dftest_ratio[, 'length'])
  head(all)
  # get only values higher than 0.5
  gain = dftest_ratio[dftest_ratio$log2 > 0.5, ]
  tot_gain = sum(gain[, 'length'])
  # get only values lower than -0.5
  loss = dftest_ratio[dftest_ratio$log2 < -0.5, ]
  tot_loss = sum(loss[, 'length'])
  #sum gain loss
  sum = tot_gain + tot_loss
  # fraction 
  GII = sum/all
  
  dat <- data.frame(i, GII)
  colnames(dat)=c("Patient","GII")
  datalist[[i]] <- dat
}

big_data = do.call(rbind, datalist) 
colnames(big_data)=c("Patient","GII")


WESsamplesESOCAupdate20220117 = read.table(file= "file.tsv", header = T)

head(WESsamplesESOCAupdate20220117)
#WESsamplesESOCAupdate20220117 = read.xlsx(file= "WESsamplesESOCAupdate20220117.xlsx", sheet = 2)

head(WESsamplesESOCAupdate20220117)

library(dplyr)
library(stringr)
mandard <- c("1", "2","4","5")
responders <- c("1", "2")
non_responders <- c("4","5")


mySubset <- WESsamplesESOCAupdate20220117[WESsamplesESOCAupdate20220117$Mandard %in% mandard, ]
head(mySubset)

mySubset$responders <- ifelse(mySubset$Mandard %in% responders,"responders","non-responders")

head(mySubset)

merged <- merge(big_data,mySubset,by="Patient")

head(merged)


merged$patients <- factor(merged$responders, 
                          levels=c("responders", "non-responders"))

# Basic violin plot
p <- ggplot(merged, aes(x=patients, y=GII, fill=patients)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white") + scale_fill_manual(values=c("blue", "red"))

pdf("GII_vln_abs05_cns.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()



library(ggplot2)
# Basic violin plot
p <- ggplot(merged, aes(x=responders, y=GII, fill=responders)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white")

pdf("GII_vln_abs05_cns.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20))
dev.off()







#############
# only gain
############


for (i in names(dfList)) {
  df_ratio <- dfList[[i]]
  # remove Antitarget from the table
  df_ratio = df_ratio[!grepl("Antitarget", df_ratio$gene),]
  
  #print(head(df_ratio))
  
  # select columns of interest
  dftest_ratio = df_ratio[,c("chromosome","start","end","log2")]
  # add the length coord to dftest
  dftest_ratio$length = dftest_ratio$end -  dftest_ratio$start
  head(dftest_ratio)
  # sum the total length
  all = sum(dftest_ratio[, 'length'])
  head(all)
  # get only values higher than 0.5
  gain = dftest_ratio[dftest_ratio$log2 > 0.5, ]
  tot_gain = sum(gain[, 'length'])
  
  # fraction 
  GII = tot_gain/all
  
  dat <- data.frame(i, GII)
  colnames(dat)=c("Patient","GII")
  datalist[[i]] <- dat
}

big_data = do.call(rbind, datalist) 
colnames(big_data)=c("Patient","GII")


WESsamplesESOCAupdate20220117 = read.table(file= "file.tsv", header = T)

head(WESsamplesESOCAupdate20220117)
#WESsamplesESOCAupdate20220117 = read.xlsx(file= "WESsamplesESOCAupdate20220117.xlsx", sheet = 2)

head(WESsamplesESOCAupdate20220117)

library(dplyr)
library(stringr)
mandard <- c("1", "2","4","5")
responders <- c("1", "2")
non_responders <- c("4","5")


mySubset <- WESsamplesESOCAupdate20220117[WESsamplesESOCAupdate20220117$Mandard %in% mandard, ]
head(mySubset)

mySubset$responders <- ifelse(mySubset$Mandard %in% responders,"responders","non-responders")

head(mySubset)

merged <- merge(big_data,mySubset,by="Patient")

head(merged)

library(ggplot2)
# Basic violin plot
p <- ggplot(merged, aes(x=responders, y=GII, fill=responders)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white")

pdf("GII_vln_abs05_gain_cns.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20))
dev.off()


#############
# only loss
############


for (i in names(dfList)) {
  df_ratio <- dfList[[i]]
  # remove Antitarget from the table
  df_ratio = df_ratio[!grepl("Antitarget", df_ratio$gene),]
  
  #print(head(df_ratio))
  
  # select columns of interest
  dftest_ratio = df_ratio[,c("chromosome","start","end","log2")]
  # add the length coord to dftest
  dftest_ratio$length = dftest_ratio$end -  dftest_ratio$start
  head(dftest_ratio)
  # sum the total length
  all = sum(dftest_ratio[, 'length'])
  head(all)
  # get only values higher than 0.5
  loss = dftest_ratio[dftest_ratio$log2 < 0.5, ]
  tot_loss = sum(loss[, 'length'])
  
  # fraction 
  GII = tot_loss/all
  
  dat <- data.frame(i, GII)
  colnames(dat)=c("Patient","GII")
  datalist[[i]] <- dat
}

big_data = do.call(rbind, datalist) 
colnames(big_data)=c("Patient","GII")


WESsamplesESOCAupdate20220117 = read.table(file= "file.tsv", header = T)

head(WESsamplesESOCAupdate20220117)
#WESsamplesESOCAupdate20220117 = read.xlsx(file= "WESsamplesESOCAupdate20220117.xlsx", sheet = 2)

library(dplyr)
library(stringr)
mandard <- c("1", "2","4","5")
responders <- c("1", "2")
non_responders <- c("4","5")


mySubset <- WESsamplesESOCAupdate20220117[WESsamplesESOCAupdate20220117$Mandard %in% mandard, ]
head(mySubset)

mySubset$responders <- ifelse(mySubset$Mandard %in% responders,"responders","non-responders")

head(mySubset)

merged <- merge(big_data,mySubset,by="Patient")

head(merged)

library(ggplot2)
# Basic violin plot
p <- ggplot(merged, aes(x=responders, y=GII, fill=responders)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white")

pdf("GII_vln_abs05_loss_cns.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20))
dev.off()

getwd()









