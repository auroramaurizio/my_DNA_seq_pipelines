###############################################################################
# calculate the FGA - FRACTION OF GENOME ALTERED / GII GENOME INSTABILITY INDEX

# from CNVkit output data

# according to method https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8308111/
###############################################################################


suppressMessages(library(openxlsx))

setwd("/beegfs/scratch/ric.cosr/ric.cosr/DellabonaP/gbprova/CNA/CNVkit/output/tumor")

############################
#process the ratio dataframe
############################

########

ESOCA10_OCT = read.table("ESOCA10_OCT_markdup.cns", header = T)
ESOCA17_OCT = read.table("ESOCA17_OCT_markdup.cns", header = T)
ESOCA24T = read.table("ESOCA24T_markdup.cns", header = T)
ESOCA8_OCT= read.table("ESOCA8_OCT_markdup.cns", header = T)


dfList = list(
  ESOCA10_OCT,
  ESOCA17_OCT,
  ESOCA24T,
  ESOCA8_OCT)



names(dfList)<- list(
  "ESOCA10",
  "ESOCA17",
  "ESOCA24",
  "ESOCA8")


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
  # get only values higher than 0.2
  gain = dftest_ratio[dftest_ratio$log2 > 0.2, ]
  gain = gain[gain$length > 100000, ]
  tot_gain = sum(gain[, 'length'])
  # get only values lower than -0.2
  loss = dftest_ratio[dftest_ratio$log2 < -0.2, ]
  loss = loss[loss$length > 100000, ]
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

pdf("GII_vln_abs02_cns_100000.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()








library(ggplot2)
# Basic violin plot
p <- ggplot(merged, aes(x=responders, y=GII, fill=responders)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white")

pdf("GII_vln_abs02_cns_100000.pdf")
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
  # get only values higher than 0.2
  gain = dftest_ratio[dftest_ratio$log2 > 0.2, ]
  gain = gain[gain$length > 10000, ]
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

pdf("GII_vln_abs02_gain_cns_10000.pdf")
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
  # get only values higher than 0.2
  loss = dftest_ratio[dftest_ratio$log2 < 0.2, ]
  loss = loss[loss$length > 10000, ]
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

pdf("GII_vln_abs02_loss_cns_10000.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20))
dev.off()

getwd()









