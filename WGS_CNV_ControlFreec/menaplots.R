library("magrittr")
#library(clusterProfiler)
library("openxlsx")
library("dplyr")
library("reshape")
library("tidyr")
library(ggplot2)
#library(org.Hs.eg.db)\
#library("biomaRt")\
#library(assertr)\
#library("remotes")\
library("pheatmap")

############################\
###  PLOT\
############################\
args=commandArgs(trailingOnly=TRUE)

setwd("/Users/maurizio.aurora")
#out=args[4]\

#/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN171220/URIN171220_summary.tsv\
RT = read.table("/Users/maurizio.aurora/all_samples/CF/summary.tsv", sep="\t", header=TRUE)

head(RT)

colnames(RT)=c("chr","start","end","CN","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue", "g_chr", "g_start", "g_end", "gene", "sample")

RT$coord <- paste(RT$chr,":",RT$start,"-",RT$end, sep = "")

length(unique(RT$patient))
unique(RT$CN)

RT = RT[- grep("X", RT$chr),]
RT = RT[- grep("Y", RT$chr),]


RT$tissue = substr(RT$sample,1,4)

RT$patient = gsub("(.+?)(\\_.*)", "\\1", RT$sample)

metadata=unique(RT[,c("sample","patient","tissue")])
#metadata = read.xlsx("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN191020/metadata.xlsx")
metadata <-metadata[order(metadata$sample),]
head(metadata)

filename_xls <- 'summary_393_386_379_365_364_360_352_347_343_338.xlsx'
write.xlsx(RT,
           file= filename_xls, 
           row.names = T,
           asTable = T)


annotation_table_sub=RT[,c("sample","gene")]

annotation_table_sub = unique(annotation_table_sub)

head(annotation_table_sub)


annotation_table_sub <- unique(annotation_table_sub)

prova=xtabs( ~ gene+sample, data=annotation_table_sub)

prova1=xtabs( ~ sample+gene, data=annotation_table_sub)

#pheatmap(prova, show_rownames = F, cluster_rows = F, filename = 'Heatmap_CTCs.pdf')


#pdf('hc_CTC.pdf', width = 14, height = 10)
#hc = hclust(dist(prova1))
# very simple dendrogram\
#plot(hc)
#dev.off()



#PCA parameters\
pcx = 1
pcy = 2
centering = TRUE
scaling = FALSE

# PCA
pca = prcomp(prova1, center=centering, scale=scaling)

head(pca)
set.seed(786)

#pca = prcomp(t(prova), center=centering, scale=scaling)\
var = round(matrix(((pca$sdev^2)/(sum(pca$sdev^2))), ncol=1)*100,1)
score = as.data.frame(pca$x)

# plot paramters\
xlab = paste("PC", pcx, " (",var[pcx],"%)", sep="")
ylab = paste("PC", pcy, " (",var[pcy],"%)", sep="")
cum = var[pcx]+var[pcy]
names = rownames(pca$x)


score = as.data.frame(pca$x)
score$sample = metadata$sample
score$patient = metadata$patient
score$tissue = metadata$tissue
#score$marker = metadata$marker

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=patient))+
geom_point(size=5)+
labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
      axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
      axis.title.x = element_text(face = "bold", color = "black", size = 24),
      axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
      axis.title.y = element_text(face = "bold", color = "black", size = 24),
      legend.text = element_text(face = "bold", color = "black", size = 16),
      legend.position="right",
      panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCspatient.pdf', width = 14, height = 10)
pca_plot
dev.off()

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=tissue))+
   geom_point(size=5)+
   labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
   geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
   geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
   theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
         axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
         axis.title.x = element_text(face = "bold", color = "black", size = 24),
         axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
         axis.title.y = element_text(face = "bold", color = "black", size = 24),
         legend.text = element_text(face = "bold", color = "black", size = 16),
         legend.position="right",
         panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCstissue.pdf', width = 14, height = 10)
pca_plot
dev.off()




sort(colnames(prova))

annotation_column = metadata[,c('patient','tissue')]
rownames(annotation_column) <- colnames(prova)
head(prova)
pheatmap(prova, 
         show_rownames = F, 
         show_colnames = F,
         cluster_rows = F, 
         treeheight_row = 0,
         treeheight_col = 0,
         filename = 'Heatmap_CTCs.pdf', annotation_col = annotation_column, fontsize = 5)


#######################################################################################################


############################\
###  PLOT\
############################\
args=commandArgs(trailingOnly=TRUE)

setwd("/Users/maurizio.aurora")

#/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN171220/URIN171220_summary.tsv\
RT = read.table("/Users/maurizio.aurora/all_samples/CF/summary.tsv", sep="\t", header=TRUE)

head(RT)

colnames(RT)=c("chr","start","end","CN","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue", "g_chr", "g_start", "g_end", "gene", "sample")

RT$coord <- paste(RT$chr,":",RT$start,"-",RT$end, sep = "")

RT = RT[grep("loss", RT$status), ]


unique(RT$CN)

RT = RT[- grep("X", RT$chr),]
RT = RT[- grep("Y", RT$chr),]


RT$tissue = substr(RT$sample,1,4)

RT$patient = gsub("(.+?)(\\_.*)", "\\1", RT$sample)

metadata=unique(RT[,c("sample","patient","tissue")])
#metadata = read.xlsx("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN191020/metadata.xlsx")
metadata <-metadata[order(metadata$sample),]
head(metadata)


annotation_table_sub=RT[,c("sample","gene")]

annotation_table_sub = unique(annotation_table_sub)

head(annotation_table_sub)


annotation_table_sub <- unique(annotation_table_sub)

prova=xtabs( ~ gene+sample, data=annotation_table_sub)

prova1=xtabs( ~ sample+gene, data=annotation_table_sub)

#pheatmap(prova, show_rownames = F, cluster_rows = F, filename = 'Heatmap_CTCs.pdf')


#pdf('hc_CTC.pdf', width = 14, height = 10)
#hc = hclust(dist(prova1))
# very simple dendrogram\
#plot(hc)
#dev.off()



#PCA parameters\
pcx = 1
pcy = 2
centering = TRUE
scaling = FALSE

# PCA
pca = prcomp(prova1, center=centering, scale=scaling)

head(pca)
set.seed(786)

#pca = prcomp(t(prova), center=centering, scale=scaling)\
var = round(matrix(((pca$sdev^2)/(sum(pca$sdev^2))), ncol=1)*100,1)
score = as.data.frame(pca$x)

# plot paramters\
xlab = paste("PC", pcx, " (",var[pcx],"%)", sep="")
ylab = paste("PC", pcy, " (",var[pcy],"%)", sep="")
cum = var[pcx]+var[pcy]
names = rownames(pca$x)


score = as.data.frame(pca$x)
score$sample = metadata$sample
score$patient = metadata$patient
score$tissue = metadata$tissue
#score$marker = metadata$marker

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=patient))+
   geom_point(size=5)+
   labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
   geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
   geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
   theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
         axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
         axis.title.x = element_text(face = "bold", color = "black", size = 24),
         axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
         axis.title.y = element_text(face = "bold", color = "black", size = 24),
         legend.text = element_text(face = "bold", color = "black", size = 16),
         legend.position="right",
         panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCspatient_loss.pdf', width = 14, height = 10)
pca_plot
dev.off()

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=tissue))+
   geom_point(size=5)+
   labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
   geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
   geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
   theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
         axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
         axis.title.x = element_text(face = "bold", color = "black", size = 24),
         axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
         axis.title.y = element_text(face = "bold", color = "black", size = 24),
         legend.text = element_text(face = "bold", color = "black", size = 16),
         legend.position="right",
         panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCstissue_loss.pdf', width = 14, height = 10)
pca_plot
dev.off()




sort(colnames(prova))

annotation_column = metadata[,c('patient','tissue')]
rownames(annotation_column) <- colnames(prova)
head(prova)
pheatmap(prova, 
         show_rownames = F, 
         show_colnames = F,
         cluster_rows = F, 
         treeheight_row = 0,
         treeheight_col = 0,
         filename = 'Heatmap_CTCs_loss.pdf', annotation_col = annotation_column, fontsize = 5)




############################\
###  PLOT\
############################\
args=commandArgs(trailingOnly=TRUE)

setwd("/Users/maurizio.aurora")

#/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN171220/URIN171220_summary.tsv\
RT = read.table("/Users/maurizio.aurora/all_samples/CF/summary.tsv", sep="\t", header=TRUE)

colnames(RT)=c("chr","start","end","CN","status", "WilcoxonRankSumTestPvalue","KolmogorovSmirnovPvalue", "g_chr", "g_start", "g_end", "gene", "sample")

RT$coord <- paste(RT$chr,":",RT$start,"-",RT$end, sep = "")

RT = RT[grep("gain", RT$status), ]


head(RT)

RT = RT[- grep("X", RT$chr),]

#RT = RT[- grep("Y", RT$chr),]


RT$tissue = substr(RT$sample,1,4)

RT$patient = gsub("(.+?)(\\_.*)", "\\1", RT$sample)

metadata=unique(RT[,c("sample","patient","tissue")])
#metadata = read.xlsx("/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/Menarini/Bioinfo/553/AlfanoM_1001_Bladder_Menarini/CF/URIN191020/metadata.xlsx")
metadata <-metadata[order(metadata$sample),]
head(metadata)


annotation_table_sub=RT[,c("sample","gene")]

annotation_table_sub = unique(annotation_table_sub)

head(annotation_table_sub)


annotation_table_sub <- unique(annotation_table_sub)

prova=xtabs( ~ gene+sample, data=annotation_table_sub)

prova1=xtabs( ~ sample+gene, data=annotation_table_sub)

#pheatmap(prova, show_rownames = F, cluster_rows = F, filename = 'Heatmap_CTCs.pdf')


#pdf('hc_CTC.pdf', width = 14, height = 10)
#hc = hclust(dist(prova1))
# very simple dendrogram\
#plot(hc)
#dev.off()



#PCA parameters\
pcx = 1
pcy = 2
centering = TRUE
scaling = FALSE

# PCA
pca = prcomp(prova1, center=centering, scale=scaling)

head(pca)
set.seed(786)

#pca = prcomp(t(prova), center=centering, scale=scaling)\
var = round(matrix(((pca$sdev^2)/(sum(pca$sdev^2))), ncol=1)*100,1)
score = as.data.frame(pca$x)

# plot paramters\
xlab = paste("PC", pcx, " (",var[pcx],"%)", sep="")
ylab = paste("PC", pcy, " (",var[pcy],"%)", sep="")
cum = var[pcx]+var[pcy]
names = rownames(pca$x)


score = as.data.frame(pca$x)
score$sample = metadata$sample
score$patient = metadata$patient
score$tissue = metadata$tissue
#score$marker = metadata$marker

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=patient))+
   geom_point(size=5)+
   labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
   geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
   geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
   theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
         axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
         axis.title.x = element_text(face = "bold", color = "black", size = 24),
         axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
         axis.title.y = element_text(face = "bold", color = "black", size = 24),
         legend.text = element_text(face = "bold", color = "black", size = 16),
         legend.position="right",
         panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCspatient_gain.pdf', width = 14, height = 10)
pca_plot
dev.off()

pca_plot <- ggplot(score, aes(x=score[,pcx], y=score[,pcy], color=tissue))+
   geom_point(size=5)+
   labs(x=xlab, y=ylab, title=paste("PC",pcx," vs PC",pcy," scoreplot",sep="")) + 
   geom_hline(yintercept=0, linetype="dashed", color = "darkgrey") +
   geom_vline(xintercept=0, linetype="dashed", color = "darkgrey") +
   theme(plot.title = element_text(color="black", size=26, face="bold.italic"),
         axis.text.x = element_text(angle = 0, face = "bold", color = "black", size=22, hjust =.5), 
         axis.title.x = element_text(face = "bold", color = "black", size = 24),
         axis.text.y = element_text(angle = 0, face = "bold", color = "black", size=22),
         axis.title.y = element_text(face = "bold", color = "black", size = 24),
         legend.text = element_text(face = "bold", color = "black", size = 16),
         legend.position="right",
         panel.background = element_rect(fill = "white",colour = "black", size = 1, linetype = "solid")) 

options(repr.plot.width=13, repr.plot.height=7)
pdf('PCA_CTCstissue_gain.pdf', width = 14, height = 10)
pca_plot
dev.off()




ann_colors = list(
   tissue = c("BLAD" = 'orange',
              "URIN" = 'green',
              "UTUC" = '#D991EE',
              "CTRL" = 'red'))

sort(colnames(prova))

annotation_column = metadata[,c('patient','tissue')]
rownames(annotation_column) <- colnames(prova)
head(prova)

?pheatmap
pheatmap(prova, 
         show_rownames = F, 
         show_colnames = F,
         cluster_rows = F, 
         treeheight_row = 0,
         treeheight_col = 0,
         annotation_colors = ann_colors,
         filename = 'Heatmap_CTCs_gain.pdf', annotation_col = annotation_column, fontsize = 5)


pheatmap(prova, 
         show_rownames = F, 
         show_colnames = F,
         cluster_rows = F, 
         cluster_cols = TRUE,
         treeheight_row = 0,
         treeheight_col = 0,
         annotation_colors = ann_colors,
         filename = 'Heatmap_CTCs_gain_clust.pdf', annotation_col = annotation_column, fontsize = 5)




head(annotation_table_sub)
t = as.data.frame(table(annotation_table_sub$gene))
newdata <- unique(t[order(t$Freq,decreasing = TRUE),])

head(newdata)
nrow(annotation_table_sub[grep("ABHD17A", annotation_table_sub$gene),])

TP = head(newdata,20)
ggplot(TP, aes(x=Var1, y=Freq))+
geom_bar(stat='identity')+ 
theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#11.30 alla maxillofacciale


int = read.table("/Users/maurizio.aurora/Desktop/Twist_Exome_RefSeq_targets_hg38.bed", header = F)

head(int)


