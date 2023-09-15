# scWGS #



### WGS ###

![WGS](Pictures/WGS.png)

The pipeline is written using Snakemake (Köster et al. 2012), a workflow management and development system for data analysis, which ensures reproducibility, scalability, and portability of the code. Reproducibility and portability are granted by automatically deploying the dependencies of workflow steps (rules) while scalability is obtained through the automatic parallelization of rules. 
Snakemake automatically infers which rules are independent of each other and can be run in parallel. This reduces idle CPU time, leading to faster task completion. In addition, Conda (https://docs.conda.io/en/latest/) is used for version control, leading to a simple installation without the risk of dependency conflicts. The workflow contains all analysis steps from - read merging, mapping, contaminant detection, and duplicate removal - to the copy number variant (CNV) call and annotation. Each step is coded in a different rule and each rule that has additional dependencies has a separate Conda environment that will be automatically created when starting the workflow for the first time. Snakemake is python-based but it was further extended using the rule-based Snakemake syntax with Python, R scripts, and shell commands. Eventually the pipeline allows processing of 0.1X data from raw reads up to CNV annotation in a single cell within minutes.


Quality (FastQC, Andrews et. al 2010) and contaminant check (Kraken2, Wood et. al 2019) are preliminary, mandatory steps of the analysis. Excessive amplification of exogenous DNA may arise when the initial material is insufficient or of subpar quality, as indicated by Salter et al. and Merchant et al. in their 2014 studies, potentially resulting in both wastage of reagents and erroneous experimental conclusions. Common laboratory contaminants include bacteria such as P. aeruginosa and E. coli, viruses, as well as cross species contamination, presumably due to the manipulation of DNA samples extracted from different organisms in the lab. We established a quality threshold for each cell based on the originating bio-specimen, requiring a minimum of 75% or 90% of reads mapping to the human genome to be considered as good quality.


Then trimming is performed with Trimmomatic (Bolger et. al 2014). As our libraries are prepared with PicoPlex Gold Single Cell DNA Seq protocol (Takara Bio) the first 14 bases of the reads should be trimmed. These bases originate from the Pre-Amplification primers introduced during the PicoPLEX Gold Single Cell DNA-Seq library preparation. Subsequent alignment is performed over the human reference genome with BWA-MEM (Li et al., 2013). Among the different assembly of the human genome we decided to use GRCh38_Verily (https://cloud.google.com/life-sciences/docs/resources/public-datasets/reference-genomes) to reduce the loss of reads that could result from ambiguous mapping over non-canonical chromosomes. GRCh38_Verily genome has the following characteristics: excludes all patch sequences, omits alternate haplotype chromosomes, includes decoy sequences, and masks out duplicate copies of centromeric regions. After sorting and indexing of bam alignment files performed using samtools (Li et al. 2009), duplicate reads are first highlighted with Picard (http://picard.sourceforge.net/)to produce the mapping metrics with Qualimap (García-Alcalde et al. 2012) and then removed from the alignment files. Sample quality metrics are collected in an html report by MultiQC (Ewels et al., 2016). 


Only files with at least 1M reads mapping over the human genome after duplicate removal are further processed. Deduplicated files are provided as input to Control-FREEC (Boeva et al. 2012) for Copy Number Variation (CNV) assessment. The popular CNV caller is highly customizable. Imposing a proper coefficient of variation in the configuration file allowed us to precisely evaluate the appropriate window size for each single cell according to its coverage. When the control sample (lymphocyte) is present it is used to normalize the raw CNPs, if no control (paired normal DNA to putative tumor cells) cell is available Control-FREEC accurately calls genotype status using GC-content and mappability profiles to normalize read count. Uniformity of coverage across the genome was evaluated for each sample with the Gini index (Zeileis et. al 2009). The Gini coefficient value varies between 0 and 1, where 0 is the most uniform and 1 is the most extreme. In our configuration samples with extremely high Gini coefficients (greater than 0.35) appeared to be low quality (degraded and often highly contaminated) therefore excluded from the analysis, samples with Gini coefficients lower than than 0.2 were considered normal, compatible with a lymphocyte flat genomic profile. Samples with a Gini index >= 0.2 and <= 0.35 were considered CNV altered. The Lorenz curve was plotted for each sample. The area under the Lorenz curve represents the cumulative fraction of reads as a function of the cumulative fraction of the genome. Perfect coverage uniformity results in a straight line with slope 1 (normal – control samples). The wider the curve below the line, the lower the coverage uniformity of the samples (samples with aneuploidies or degraded). These steps are followed by the analysis of predicted regions of gains and losses in order to assign copy numbers to each segment. We apply two independent statistical tests such as Wilcoxon test and Kolmogorov-Smirnov test to the data in order to select significant CNA (pvalue< 0.01 in both tests). Only copy number changes predicted in autosomes are considered to classify the cells as putative tumor or non-tumor cells. Genome-instability index (GII) (aka FGA-fraction of genome altered or Copy Number Burden) was calculated for each sample as the percentage of genome affected by copy number gains or losses. Plots of significant gain/loss CNA distribution across the genome are generated for each cell (Gel et al., 2017). Gene annotation is then performed on significant CNA calls. CNV-level and gene-level summary tables for each patient are reported as the final output of the pipeline. 



 

 

### References 

Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/ 

 

Boeva, Valentina, et al. "Control-FREEC: a tool for assessing copy number and allelic content using next-generation sequencing data." Bioinformatics 28.3 (2012): 423-425. 


 
Bolger, Anthony, and F. Giorgi. "Trimmomatic: A flexible read trimming tool for Illumina NGS data." Bioinformatics 30.15 (2014): 2114-2120.



García-Alcalde, Fernando, et al. "Qualimap: evaluating next-generation sequencing alignment data." Bioinformatics 28.20 (2012): 2678-2679. 

 

Garvin, Tyler, et al. "Interactive analysis and assessment of single-cell copy-number variations." Nature methods 12.11 (2015): 1058-1060. 

 

Gel, Bernat, and Eduard Serra. "karyoploteR: an R/Bioconductor package to plot customizable genomes displaying arbitrary data." Bioinformatics 33.19 (2017): 3088-3090.



Ewels, Philip, et al. "MultiQC: summarize analysis results for multiple tools and samples in a single report." Bioinformatics 32.19 (2016): 3047-3048. 

 

Köster, Johannes, and Sven Rahmann. "Snakemake—a scalable bioinformatics workflow engine." Bioinformatics 28.19 (2012): 2520-2522.



Li, Heng. "Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM." arXiv preprint arXiv:1303.3997 (2013). 

 

Li, Heng, et al. "The sequence alignment/map format and SAMtools." Bioinformatics 25.16 (2009): 2078-2079. 

 

Merchant, Samier, Derrick E. Wood, and Steven L. Salzberg. "Unexpected cross-species contamination in genome sequencing projects." PeerJ 2 (2014): e675.



Picard. [http://picard.sourceforge.net/] 



Van der Auwera, Geraldine A., and Brian D. O'Connor. Genomics in the Cloud: Using Docker, GATK, and WDL in Terra. O'Reilly Media, 2020. 

 

Pedersen, Brent S., and Aaron R. Quinlan. "Mosdepth: quick coverage calculation for genomes and exomes." Bioinformatics 34.5 (2018): 867-868. 

 

Pengelly, Reuben J., et al. "A SNP profiling panel for sample tracking in whole-exome sequencing studies." Genome medicine5.9 (2013): 1-7. 

 

Salter, Susannah J., et al. "Reagent and laboratory contamination can critically impact sequence-based microbiome analyses." BMC biology 12.1 (2014): 1-12.



Wood, Derrick E., Jennifer Lu, and Ben Langmead. "Improved metagenomic analysis with Kraken 2." Genome biology 20.1 (2019): 1-13. 

 

Zeileis, Achim, Christian Kleiber, and Maintainer Achim Zeileis. "Package ‘ineq’." Tech. Rep. (2009). 

