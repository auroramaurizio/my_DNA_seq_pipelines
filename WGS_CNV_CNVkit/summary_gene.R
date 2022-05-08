
library("magrittr")
#library(clusterProfiler)
library("dplyr")
library("tidyr")

setwd("/beegfs/scratch/ric.cosr/ric.cosr/CNA/CNVkit/output/gene_anno/files")

############################
#process the ratio dataframe
############################

list.files()
########

#cnvkit.py call Sample.cns -o Sample.call.cns

ESOCA10_OCT = read.table("ESOCA10_OCT_markdup.call.cns", header = T) #1
ESOCA17_OCT = read.table("ESOCA17_OCT_markdup.call.cns", header = T) #2
ESOCA24T = read.table("ESOCA24T_markdup.call.cns", header = T) #3
ESOCA8_OCT= read.table("ESOCA8_OCT_markdup.call.cns", header = T) #33


ESOCA8_OCT[grepl("MET", ESOCA8_OCT$gene),]

dfList = list(
  ESOCA10_OCT,
  ESOCA17_OCT,
  ESOCA24T,
  ESOCA8_OCT)





length(names(dfList))
names(dfList)<- list(
  "ESOCA10",
  "ESOCA17",
  "ESOCA24",
  "ESOCA8")

length(dfList)



datalist = list()

for (i in names(dfList)) {
  df_ratio <- dfList[[i]] 
  colnames(df_ratio)
  # select columns of interest
  dftest_ratio = df_ratio[,c("gene","cn")]
  # add the sample name
  dftest_ratio$sample = i
  head(dftest_ratio)
  # get only values higher than 2
  gain = dftest_ratio[dftest_ratio$cn > 2, ]
  dat = gain %>%
    mutate(gene = strsplit(gsub("[][\"]", "", gene), ",")) %>%
    unnest(gene)
  dat = dat[,c("gene","sample")]
  datalist[[i]] <- dat
}

names(dfList[i])
big_data = do.call(rbind, datalist)

head(big_data)
nrow(big_data)
unique = unique(big_data)
nrow(unique)

head(unique)
grouped_by_gene  <- unique %>%
  group_by(gene) %>%
  summarise(temp = toString(sample)) %>%
  ungroup()


colnames(grouped_by_gene) = c("gene", "sample_with_CNV")
grouped_by_gene = grouped_by_gene[-1,]
grouped_by_gene$number_of_samples = count.fields(textConnection(grouped_by_gene$sample_with_CNV), sep = ",")

write.table(grouped_by_gene, 'gains_cnvkit.tsv', sep='\t', quote=F)

#grouped_by_gene[grepl("ZFY-AS1", grouped_by_gene$gene),]






datalist = list()

for (i in names(dfList)) {
  df_ratio <- dfList[[i]] 
  colnames(df_ratio)
  # select columns of interest
  dftest_ratio = df_ratio[,c("gene","cn")]
  # add the sample name
  dftest_ratio$sample = i
  head(dftest_ratio)
  # get only values higher than 2
  loss = dftest_ratio[dftest_ratio$cn < 2, ]
  dat = loss %>%
    mutate(gene = strsplit(gsub("[][\"]", "", gene), ",")) %>%
    unnest(gene)
  dat = dat[,c("gene","sample")]
  datalist[[i]] <- dat
}

names(dfList[i])
big_data = do.call(rbind, datalist)

head(big_data)
nrow(big_data)
unique = unique(big_data)
nrow(unique)


grouped_by_gene  <- unique %>%
  group_by(gene) %>%
  summarise(temp = toString(sample)) %>%
  ungroup()


colnames(grouped_by_gene) = c("gene", "sample_with_CNV")


head(grouped_by_gene)
grouped_by_gene = grouped_by_gene[-1,]
grouped_by_gene$number_of_samples = count.fields(textConnection(grouped_by_gene$sample_with_CNV), sep = ",")

write.table(grouped_by_gene, 'losses_cnvkit.tsv', sep='\t', quote=F)




table = read.table("gains_cnvkit.tsv", sep = "\t")

head(table)
filename_xls <- 'gene_gains_cnvkit.xlsx'
write.xlsx(table,
           file= filename_xls, 
           row.names = F,
           asTable = T)

table = read.table("gains_cnvkit.tsv", sep = "\t")

table = read.table("losses_cnvkit.tsv", sep = "\t")

head(table)
filename_xls <- 'gene_losses_cnvkit.xlsx'
write.xlsx(table,
           file= filename_xls, 
           row.names = F,
           asTable = T)


for (i in names(dfList)) {
  df_ratio <- dfList[[i]] 
  dftest_ratio = df_ratio[,c("gene","cn")]
  print(dftest_ratio[grepl("MET", dftest_ratio$gene),])}



colnames(ESOCA8_OCT)

df_ratio <- ESOCA8_OCT
colnames(df_ratio)
# select columns of interest
dftest_ratio = df_ratio[,c("gene","cn","chromosome","start","end")]
# add the sample name
dftest_ratio$sample = i
head(dftest_ratio)
# get only values higher than 2
dat = dftest_ratio %>%
  mutate(gene = strsplit(gsub("[][\"]", "", gene), ",")) %>%
  unnest(gene)

dat[grepl("^MET$", dat$gene),]

dat = dat[,c("gene","cn")]
unique = unique(dat)
nrow(unique)


grouped_by_gene  <- unique %>%
  group_by(gene) %>%
  summarise(temp = toString(cn)) %>%
  ungroup()

grouped_by_gene[grepl("MET", grouped_by_gene$gene),]


ESOCA8_OCT

dftest_ratio = ESOCA8_OCT[,c("gene","cn")]
dftest_ratio[grepl("MET", dftest_ratio$gene),]
ESOCA8_OCT


head(grouped_by_gene)
dat <- data.frame(i, GII)
colnames(dat)=c("Patient","GII")

