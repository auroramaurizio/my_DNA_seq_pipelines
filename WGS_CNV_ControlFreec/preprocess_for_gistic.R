#Readapted code by https://github.com/kunstner/freec2gistic. Thanks kunstner!
#with respect to kunstner I have a 3 column cpn output: chr, start, cov.
#so I added the end column and removed columns he has but I do not.

library(tidyverse)
library(ggplot2)
library(GenomicRanges)



#Join BED files in R

#Files are joined and the ratio is transformed applying log2(ratio)-1 (according to https://www.biostars.org/p/426635/)
# list of files with pattern matching

files <- list.files(path = "/beegfs/scratch/ric.cosr/ric.cosr/Carniti_DNA/CF/bed", pattern="freec_segments.bed", full.names=TRUE)


segData <- NULL
for( i in files ) {
    tab <- read.table(i)
    id <- gsub(pattern = "/beegfs/scratch/ric.cosr/ric.cosr/Carniti_DNA/CF/bed/", replacement = "", i)
    id <- gsub(pattern = "_freec_segments.bed", replacement = "", id)
    tab$Sample <- id
    tab$Dummy <- 'NA'
    tab <- tab[, c("Sample", "V1", "V2", "V3", "Dummy", "V4")]
    # convert ratio to log2(ratio)-1
    tab$V4 <- log2(tab$V4) - 1
    segData <- rbind(segData, tab)
}

segData <- segData %>%
    dplyr::filter( V1 != 'chrX' & V1 != 'chrY') %>%
    dplyr::rename( Chromosome = V1, Start = V2, End = V3, log2ratio = V4 )

segData$Chromosome <- gsub(pattern = "chr", replacement = "", segData$Chromosome)

head(segData)
#Add coverage information and merge ratio and coverage
#Retrieve coverage information:

files <- list.files(path = "/beegfs/scratch/ric.cosr/ric.cosr/Carniti_DNA/CF/cpn", pattern="bam_sample.cpn", full.names=TRUE)
cpnData <- NULL

#i = "/beegfs/scratch/ric.cosr/ric.cosr/Carniti_DNA/CF/cpn/PTCL_0106_DNA_markdup.bam_sample.cpn"

tab <- read.table(i)
head(test)
for( i in files ) {
    if (file.info(i)$size != 0) {
    #print(i)
    tab <- read.table(i)
    tab$V4 <- tab$V2+ tab[2,2] -1
    #print(tab)
    id <- gsub(pattern = "/beegfs/scratch/ric.cosr/ric.cosr/Carniti_DNA/CF/cpn/", replacement = "", i)
    #print(id)
    id <- gsub(pattern = "_markdup.bam_sample.cpn", replacement = "", id)
    #print(id)
    tab$Sample <- id
    #head(tab)
    tab <- tab[, c("Sample", "V1", "V2", "V4", "V3")]
    cpnData <- rbind(cpnData, tab) }
}

colnames(cpnData) <- c("Sample", "Chromosome", "Start", "End", "Number")

head(cpnData)

#Combine coverage and ratios

segData_num <- NULL
for ( i in unique( cpnData$Sample ) ) {
    cpn.s <- cpnData %>% dplyr::filter( Sample == i ) %>% dplyr::select( -Sample ) %>% GRanges
    seg.s <- segData %>% dplyr::filter( Sample == i ) %>% dplyr::select( -Sample ) %>% dplyr::rename(Num_Probes=Dummy) %>% GRanges

    # sum features per interval
    for ( j in 1:nrow( data.frame(seg.s) ) ) {
        Num_Probes <- sum( data.frame( cpn.s[ c(data.frame( findOverlaps(seg.s[j,], cpn.s) )$subjectHits), ] )$Number )
        mcols( seg.s[j, ] )$Num_Probes <- Num_Probes
    }

    seg.s <- data.frame(seg.s)
    seg.s$Sample <- i
    segData_num <- rbind(segData_num, seg.s)

}

bk = segData_num
segData_num <- segData_num %>%
    dplyr::select( Sample, seqnames, start, end, Num_Probes, log2ratio)

#Finally, save all files

write.table(x = segData, file = "gistic.segments.txt", sep = "\t", row.names = F, col.names = F, quote = F)
write.table(x = segData_num, file = "gistic.segments.numProbes.txt", sep = "\t", row.names = F, col.names = F, quote = F)

#If necessary, common CNAs can be removed as described below. Here, a panel of common mutations for hg19 was retrieved
#from a Broad Institute panel of normals (ftp://ftp.broadinstitute.org/pub/GISTIC2.0/hg19_support/)


#common.cnvs <- GRanges( read.delim( file = "../data/CNV.hg19.bypos.111213.txt" ) )
# get index of all CNVs without a hit in common.cnv
#subsetByOverlaps( GRanges(cnvdata[4, 1:4]), common.cnvs )
#idx <- which( countOverlaps( GRanges(segData[, -1]), common.cnvs ) == 0 )
#segData <- segData[idx, ]
#rownames(segData) <- NULL
