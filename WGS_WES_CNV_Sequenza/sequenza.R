#!/usr/bin/env Rscript
args <- commandArgs()

options(warn=-1)

#### Get inputs from 3.run_sequenza.sh ####

SEX <-read.table(args[5], header=F);

#if male use chrY, if female don't ####


colnames(SEX)=c("sample","sex")

#### If male use chrY, if female don't ####
is_female <- SEX$sex

chromosomes <- paste0("chr",c(1:22,"X"))
if (!as.logical(is_female)) {
  chromosomes <- c(chromosomes,'chrY')
}


# Run Rscript
#Rscript 3.analyse_sequenza.R seqz_files/${SAM}-bin50.seqz.gz ${SAM} ${Low_Cell} ${High_Cell} ${Low_Ploid} ${High_Ploid} ${Female}


#### Load sequenza library ####
library(sequenza)

seqzFile=args[4]

seqzExt <- sequenza.extract(file=seqzFile,chromosome.list=chromosomes,normalization.method='median',window=1e5,gamma=280,kmin=300,min.reads.baf=50,min.reads=50,min.reads.normal=15,max.mut.types= 1)

#### Fit cellularity and ploidy parameters ####
# Select only the more reliable autosomes for fitting cellularity and ploidy parameters
# sequenza.fit: run grid-search approach to estimate cellularity and ploidy
# CP <- sequenza.fit(test)
chr.fit <- paste0("chr",c(1:22))
# Read in arguments for min and max cellularity and ploidy (currently 0.05-1 and 1.8-5)

low_cell=0.05
up_cell=1
low_ploidy=1.8
up_ploidy=5

# Run sequenza.fit
paraSpace <- sequenza.fit(sequenza.extract=seqzExt,cellularity=seq(low_cell,up_cell,0.01),ploidy=seq(low_ploidy,up_ploidy,0.1),chromosome.list=chr.fit,female=as.logical(is_female))


#### Run Sequenza Analysis ####
# Read in sample name
sample_id <- "SNAME"
# Run sequenza.results

# sequenza.results: write files and plots using suggested or selected solution
# sequenza.results(sequenza.extract = test, cp.table = CP, sample.id = "Test", out.dir="TEST")
sequenza.results(sequenza.extract=seqzExt,cp.table=paraSpace,sample.id=sample_id,out.dir="SNAME", female=as.logical(is_female))


