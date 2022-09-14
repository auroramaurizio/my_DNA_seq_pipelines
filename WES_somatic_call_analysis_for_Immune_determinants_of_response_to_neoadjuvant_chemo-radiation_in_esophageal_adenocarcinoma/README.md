# WES Analysis scripts for "Immune determinants of response to neoadjuvant chemo-radiation in esophageal adenocarcinoma".
## Methods complete section

#### Sequencing Data Processing and Alignment
Three paired end sequencing batches were analyzed independently (Batch1: samples 8, 10, 11, 12, 15, 17, 18; Batch2: samples 20, 22, 24, 25, 26, 27, 29, 30, 31, 33, 34 ; Batch3: samples 35, 37, 39, 40, 41, 43, 45, 48, 49, 51, 52, 54, 55, 57) using Snakemake [Köster, Johannesand Rahmann, 2012], a workflow management and development system for data analysis, to ensure reproducibility, scalability, and portability of the code . Conda (https://docs.conda.io/en/latest/) was used for version control.
Quality check of raw sequencing data was performed with  FastQC v0.11.9 [Andrews et al. 2010]. Trimming was performed with BBMap bbduck v38.90 [BBMap - Bushnell B. - sourceforge.net/projects/bbmap/] (with parameters k=23 mink=11 rcomp=t ktrim=f kmask=N qtrim=rl trimq=5 forcetrimleft=5 forcetrimright2=0 overwrite=true) to remove adapter sequencences and low-quality bases from the reads. BBMap filterbytile.sh v38.90 (with parameters ud=0.75 qd=1 ed=1 ua=.5 qa=.5 ea=.5) was used to clean the FastQ files from the loss in quality associated with some tiles of the flowcell in Batch2 samples. FastQC was then re-applied to verify the quality of the reads after the above pre-filtering processes. 
Clean reads in FastQ format were aligned to the reference human genome (GATK_bundle Hg38, v0) by Burrows-Wheeler Aligner (bwa-mem2 v2.1) [Li, 2013]. Duplicate reads were highlighted with picard MarkDuplicates v2.24.2 [http://picard.sourceforge.net/] after sorting and indexing of bam alignment files performed using samtools v1.11 [Li et al. 2009]. BamUtil ClipOverlap v1.0.15 [Jun, Goo et al, 2015] was applied afterwards to BAM files in order to correct for the effect of overlapping read pairs on SNV coverage. Overlapping fragments in paired end reads otherwise would have carried potential PCR amplification/sequencing errors to both paired reads. The risk in these scenarios is that a single-base error may appear as two independent mismatches, resulting in false positive variant calls. Mapping metrics were generated with Qualimap v.2.2.2-dev [García-Alcalde, 2012] and picard CollectHsMetrics v2.24.2. Sample quality metrics were collected in an html report by MultiQC v1.9 [Ewels et al., 2016].

#### Somatic Mutation Variant Detection

Somatic single nucleotide variations (SNVs) and small indels were identified from the clean sequencing data by GATK MuTect2 v4-4.2.2.0 [Benjamin, et al.] following the Somatic short variant discovery Best Practices.  Base Quality Score Recalibration (BQSR) steps were applied to the tumor and matched normal BAM files in order to correct for systematic bias that affect the assignment of base quality scores by the sequencer. First, recalibration tables for BQSR were generated starting from BAM files with GATK BaseRecalibrator v4-4.2.2.0. These tables then were provided with the BAM files as input to GATK ApplyBQSR to recalibrate the base qualities of the input reads.
A panel of normals (PoN) containing germline and artifactual sites present in normal samples was then created with GATK GenomicsDBImport v4-4.2.2.0 and GATK CreateSomaticPanelOfNormals v4-4.2.2.0.
In order to call somatic variants only, GATK MuTect2 v4-4.2.2.0 was used in tumor with matched normal mode providing the tumor match normal, the panel of normals, the Agilent probe interval list, and the gnomad Hg38 germline-resource. Soft clipped bases were excluded from the call imposing the optional parameter --dont-use-soft-clipped-bases true.
GATK FilterMutectCalls v4-4.2.2.0 was used to filter the raw output of Mutect2. GATK Funcotator v4-4.2.2.0, and SnpSift annotate v4.3t [Cingolani et al, 2012] were employed to add respectively gene-level, and COSMIC v95 [Tate et al, 2019] information to each variant and Ensembl Variant Effector Predictor (VEP) [McLaren, 2016] helped to predict the effect of the detected variants. The resulting tumor somatic Variant Call Files (VCFs) were converted to Mutation Annotation Format (MAF) files with vcf2maf.pl v2.0 [Kandoth, 2020]. Summary plots and statistics were generated with Maftools v2.6.5 [Mayakonda, Anand, et al. 2019] and bcftools stats v1.8. VCFs MPOS field was checked to exclude the presence of calling biases along the read length.


#### Ploidy and purity estimates

Recalibrated BAM files from the 32 samples were used to estimate tumor cellularity and ploidy, and to calculate allele-specific copy number profiles with Sequenza v3.0.0 [Favero et al, 2015 ] (optional params low_ploidy=1, up_ploidy=7, cellularity=seq(low_cell, up_cell, 0.01) where low_cell is the sample cellularity estimated by the pathologist -20% and up_cell is the sample cellularity estimated by the pathology +20%).



#### References:


Andrews, S. (2010). FastQC:  A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/

Benjamin, David, et al. "Calling somatic SNVs and indels with Mutect2." BioRxiv (2019): 861054.

BBMap - Bushnell B. - sourceforge.net/projects/bbmap/

Cingolani, Pablo, et al. "Using Drosophila melanogaster as a model for genotoxic chemical mutational studies with a new program, SnpSift." Frontiers in genetics 3 (2012): 35.

Cyriac Kandoth. mskcc/vcf2maf: vcf2maf v1.6.19. (2020). doi:10.5281/zenodo.593251

Favero, Francesco, et al. "Sequenza: allele-specific copy number and mutation profiles from tumor sequencing data." Annals of Oncology 26.1 (2015): 64-70.

García-Alcalde, Fernando, et al. "Qualimap: evaluating next-generation sequencing alignment data." Bioinformatics 28.20 (2012): 2678-2679.

Ewels, Philip, et al. "MultiQC: summarize analysis results for multiple tools and samples in a single report." Bioinformatics 32.19 (2016): 3047-3048.

Jun, Goo, et al. "An efficient and scalable analysis framework for variant extraction and refinement from population-scale DNA sequence data." Genome research 25.6 (2015): 918-925.


Köster, Johannes, and Sven Rahmann. "Snakemake—a scalable bioinformatics workflow engine." Bioinformatics 28.19 (2012): 2520-2522.

Li, Heng. "Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM." arXiv preprint arXiv:1303.3997 (2013).

Li, Heng, et al. "The sequence alignment/map format and SAMtools." Bioinformatics 25.16 (2009): 2078-2079.

McLaren, William, et al. "The ensembl variant effect predictor." Genome biology 17.1 (2016): 1-14.

Mayakonda, Anand, et al. "Maftools: efficient and comprehensive analysis of somatic variants in cancer." Genome research 28.11 (2018): 1747-1756.

Picard. [http://picard.sourceforge.net/]

Tate, John G., et al. "COSMIC: the catalogue of somatic mutations in cancer." Nucleic acids research 47.D1 (2019): D941-D947.



