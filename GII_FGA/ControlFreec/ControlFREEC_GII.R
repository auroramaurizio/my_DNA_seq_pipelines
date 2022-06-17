###############################################################################
# calculate the FGA - FRACTION OF GENOME ALTERED / GII GENOME INSTABILITY INDEX

# from ControlFREEC output data

# according to method https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8308111/
###############################################################################


suppressMessages(library(openxlsx))

setwd("/beegfs/scratch/ric.cosr/ric.cosr/prj/summary")

datalist = list()

summary = read.table("summary.tsv", header = F)
colnames(summary)  = c("CNVchr","CNVstart","CNVend","copynumber","status","WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue","sample")
head(summary)
tail(summary)

head(df_ratio)
unique(df_ratio$CNVchr)

  df_ratio = summary[!grepl("X", summary$CNVchr),]
  df_ratio = summary[!grepl("Y", summary$CNVchr),]
  
  # select columns of interest
  dftest_ratio = df_ratio[,c("CNVchr","CNVstart","CNVend","copynumber","sample")]
  # add the length coord to dftest
  dftest_ratio$length = dftest_ratio$CNVend -  dftest_ratio$CNVstart
  head(dftest_ratio)
  unique(dftest_ratio$sample)
  total_genome_size= 3209286105
  
  
  
  for (i in unique(dftest_ratio$sample) ) {
    test = dftest_ratio[grepl(i, dftest_ratio$sample),]
    head(test)
    # sum the total length
    all =  3209286105
    head(all)
    gain = test[test$copynumber > 2, ]
    tot_gain = sum(gain[, 'length'])
    loss = test[test$copynumber < 2, ]
    tot_loss = sum(loss[, 'length'])
    #sum gain loss
    sum = tot_gain + tot_loss
    # fraction 
    GII = sum/all
    test$tissue = substr(test$sample,1,4)
    dat <- data.frame(i, GII, unique(test$tissue))
    colnames(dat)=c("Patient","GII","tissue")
    datalist[[i]] <- dat
}

big_data = do.call(rbind, datalist) 
colnames(big_data)=c("cell","GII","tissue")
tail(big_data)

library(stringr)
big_data$patient = word(big_data$cell, 1, sep = "_")
head(big_data)
write.table(big_data, "GII.tsv", sep = "\t", col.names = TRUE)

library(ggplot2)
# Basic violin plot
p <- ggplot(big_data, aes(x=tissue, y=GII, fill=tissue)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white") + scale_fill_brewer(palette="Dark2")

pdf("GII_urin_utuc_ctrl.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()

unique(big_data$patient)

p <- ggplot(big_data, aes(x=patient, y=GII, fill=patient)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white") + scale_fill_brewer(palette="Dark2")

pdf("GII_urin_utuc_ctrl.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()


setwd("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/MENARINI/bioinfo/GII")

big_data = read.xlsx("GII.xlsx", colNames = TRUE, rowNames = TRUE)
head(big_data)

library(ggplot2)
# Basic violin plot
p <- ggplot(big_data, aes(x=sample, y=as.numeric(gini), fill=sample)) + 
  geom_violin() +  geom_boxplot(width=0.1, fill="white") + scale_fill_brewer(palette="Dark2")

pdf("gini_urin_utuc_ctrl.pdf")
p + theme(strip.text = element_text(size=25)) + theme(text = element_text( size = 20)) + theme(legend.position="none")
dev.off()

