# WES pipeline #



### WES ###

![WES](Pictures/WES.png)

After read quality assessment, reads are aligned to the human reference genome GRCh38_Verily (https://cloud.google.com/life-sciences/docs/resources/public-datasets/reference-genomes) using BWA-MEM (Li et al., 2013). Sorting and indexing of bam alignment files are performed using samtools (Li et al. 2009). Duplicate reads are highlighted with Picard (http://picard.sourceforge.net/) to produce the mapping metrics with Qualimap (García-Alcalde) and Mosdepth (Pedersen et al. 2018). Copy number calling is performed in parallel with Sequenza (Favero et al. 2015) and Control-Freec (Boeva et al. 2012). Somatic SNV calls are predicted with GATK mutect2 (Van der Auwera et al. 2020).  Sample verification by means of genotype profiling - Kompetitive Allele Sample Profiling (KASP) - is performed computationally with GATK-haplotype caller (Van der Auwera et al. 2020, Pengelly et al. 2013) to validate data provenance of WES samples. CNAqc (Househam et al. 2021) was employed to assess quality of allele-specific Copy Number Alterations (CNA), somatic mutations and purity estimates generated from tumour bulk sequencing. Multi-threading was employed whenever possible to speed up each snakemake pipeline step (via slurms job scheduler) on the cluster.
