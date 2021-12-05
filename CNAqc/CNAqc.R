

#devtools::install_github("caravagnalab/CNAqc")

library(CNAqc)
require(dplyr)
require(vcfR)

getwd()

# from https://caravagnalab.github.io/CNAqc/articles/a7_example_MSeq.html

vcf_file <- "/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/MENARINI/Bioinfo/314_WES/Mutect2/sample_somatic_T_new_filtered.vcf.gz"

vcf <- read.vcfR( vcf_file, verbose = FALSE )

x = vcf_file

# Parsing with vcfR -- maybe Variant Annontation works better..
xfile = vcfR::read.vcfR(x, verbose = F)
  
# INFO field does not come out very nice -- so I omit it
# info_field = vcfR::extract_info_tidy(xfile)
  
# Genotype(s)
gt_field = vcfR::extract_gt_tidy(xfile, verbose = F)
head(gt_field)
  
if(!all(c("gt_AD", "Indiv") %in% colnames(gt_field))) stop("Missing required fields in the VCF (gt_AD, Indiv)")
  
gt_field = gt_field %>%
  tidyr::separate(gt_AD, sep = ',', into = c("NR", "NV")) %>%
  dplyr::mutate(
    NR = as.numeric(NR),
    NV = as.numeric(NV),
    DP = NV + NR,
    VAF = NV/DP
  ) %>%
  dplyr::rename(sample = Indiv)
  
na_muts = gt_field %>% dplyr::filter(is.na(VAF))
  
if(nrow(na_muts) > 0) {
  cat("There are n =", nrow(na_muts), "mutations with VAF that is NA; they will NOT be removed.\n")
}
  
# Fixed fields -- this should retain everything relevant
fix_field = xfile@fix %>%
  as_tibble()
  
if(!all(c("CHROM", "POS", "REF", "ALT") %in% colnames(fix_field))) stop("Missing required fields in the VCF (CHROM, POS, REF, ALT)")
  
fix_field = fix_field %>%
  dplyr::rename(
    chr = CHROM,
    from = POS,
    ref = REF,
    alt = ALT
  ) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    from = as.numeric(from),
    to = from + nchar(alt)
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(chr, from, to, ref, alt, dplyr::everything())
  
# Extract each sample
samples_list = gt_field$sample %>% unique
  
calls = lapply(
  samples_list,
  function(s){
    gt_field_s = gt_field %>% dplyr::filter(sample == s)
      
    if(nrow(fix_field) != nrow(gt_field_s))
      stop("Mismatch between the VCF fixed fields and the genotypes, will not process this file.")
      
    fits = list()
    fits$input = x
    fits$sample = s
    fits$caller = "Mutect"
    fits$mutations = dplyr::bind_cols(fix_field, gt_field_s) %>%
      dplyr::select(chr, from, to, ref, alt, NV, DP, VAF, dplyr::everything())
      
    fits
  })
names(calls) = samples_list
  
sample_mutations = calls$sample_T$mutations

head(calls)
head(sample_mutations)

info_tidy = vcfR::extract_info_tidy(vcf)

# Fixed fields (genomic coordinates)
fix_tidy = vcf@fix %>%
  as_tibble %>%
  dplyr::rename(
    chr = CHROM,
    from = POS,
    ref = REF,
    alt = ALT
  ) %>%
  mutate(from = as.numeric(from), to = from + nchar(alt))

head (fix_tidy)

head(info_tidy)
# Genotypes

#The function extract_gt_tidy let’s you pass in a vector of 
#the FORMAT fields that you want ex- tracted to a long format 
#data frame. If you don’t tell it which fields to extract it will 
#extract all the FORMAT columns detailed in the VCF meta section. 
#The function returns a tbl_df data frame of the FORMAT fields with an 
#additional integer column Key that associates each row in the output data 
#frame with each row (i.e. each CHROM-POS combination), in the original vcfR object x, 
#and an additional column Indiv that gives the name of the individual.


#https://baezortega.github.io/2018/06/03/decomposing-large-vcf-files/ VCF format of caravagna

#https://gatk.broadinstitute.org/hc/en-us/articles/360035531692-VCF-Variant-Call-Format my VCF format

#geno_tidy = vcfR::extract_gt_tidy(vcf) %>%
#  group_split(Indiv)

#head(geno_tidy)


#Allele depth (AD) and depth of coverage (DP). 
#These are complementary fields that represent
#two important ways of thinking about the depth of the data for this sample at this site.

#AD is the unfiltered allele depth, i.e. the number of reads that support each of 
#the reported alleles. All reads at the position (including reads that did not pass the variant caller’s filters) 
#are included in this number, except reads that were considered uninformative. Reads are considered uninformative 
#when they do not provide enough statistical evidence to support one allele over another.

#DP is the filtered depth, at the sample level. This gives you the number of filtered reads 
#that support each of the reported alleles. You can check the variant caller’s documentation 
#to see which filters are applied by default. Only reads that passed the variant caller’s filters are included in this number. 
#However, unlike the AD calculation, uninformative reads are included in DP.

# Sample mutations in the CNAqc format

# Copy Number data

#Sequenza calls are available in the same repository. 

#We use an extra function to load a solution (so we can easily compare multiple runs etc etc.).


getwd()
URL = "/Users/maurizio.aurora/Dropbox (HSR Global)/WORKSPACE/MENARINI/Bioinfo/314_WES/Sequenza"
sample = "sample"

# Load Sequenza output
load_SQ_output = function(URL, sample)
{
  # We can directly read them from remote URLs
  segments_file = paste0(URL, '/', sample, '/', sample, '_segments.txt')
  purity_file = paste0(URL, '/', sample, '/', sample, '_confints_CP.txt')
  # Get segments
  segments = readr::read_tsv(segments_file, col_types = readr::cols()) %>%
    dplyr::rename(
      chr = chromosome,
      from = start.pos,
      to = end.pos,
      Major = A,
      minor = B
    ) %>%
    dplyr::select(chr, from, to, Major, minor, dplyr::everything())
  # Get purity and ploidy
  solutions = readr::read_tsv(purity_file, col_types = readr::cols())
  purity = solutions$cellularity[2]
  ploidy = solutions$ploidy.estimate[2]
  
  return(
    list(
      segments = segments,
      purity = purity,
      ploidy = ploidy
    )
  )
}


# Final sequenza run (good calls)
Sequenza_good_calls = load_SQ_output(URL, sample = 'sample')
print(Sequenza_good_calls)


# Calls analysis

# Single-nucleotide variants with VAF >5%
snvs = sample_mutations %>% 
  filter(ref %in% c('A', 'C', "T", 'G'), alt %in% c('A', 'C', "T", 'G'))
  #filter(VAF > 0.05) # da levare

head(snvs)
# CNA segments and purity
cna = Sequenza_good_calls$segments
purity = Sequenza_good_calls$purity


#Full CNAqc analysis. First we create the object.

# CNAqc data object
x = CNAqc::init(snvs,
                cna,
                purity,
                ref = "GRCh38")
print(x)

#Sample Purity: 29% ~ Ploidy: 3.

## Data 

#Show the CNA data for this sample.


pdf("sample_T_CNAqc_plot_1.pdf", 15, 10)
cowplot::plot_grid(
  plot_gw_counts(x),
  plot_gw_vaf(x, N = 10000),
  plot_gw_depth(x, N = 10000),
  plot_segments(x, highlight = c("1:0", "1:1", "2:0", "2:1", '2:2')),
  align = 'v', 
  nrow = 4, 
  rel_heights = c(.15, .15, .15, .8))
dev.off()

pdf("sample_T_CNAqc_plot_1circ.pdf", 10, 10)
plot_segments(x, circular = TRUE)
dev.off()

pdf("sample_T_CNAqc_plot_1cust.pdf", 10, 10)
plot_segments(x, highlight = c("2:1", "2:0", "2:2")) + labs(title = "Annotate different karyotypes")
dev.off()

pdf("sample_T_CNAqc_plot_summary.pdf", 10, 10)
ggpubr::ggarrange(
  plot_karyotypes(x),
  plot_karyotypes(x, type = 'number'),
  common.legend = TRUE,
  legend = 'bottom'
)
dev.off()


pdf("sample_T_CNAqc_plot_seg_size_dist.pdf", 10, 10)
plot_segment_size_distribution(x)
dev.off()

pdf("sample_T_CNAqc_plot_inspect_segmen.pdf", 30, 5)
inspect_segment(x)
dev.off()
#Show the mutation data for this sample.


pdf("sample_T_CNAqc_plot_2.pdf", 15, 10)
ggpubr::ggarrange(
  plot_data_histogram(x, which = 'VAF'),
  plot_data_histogram(x, which = 'DP'),
  plot_data_histogram(x, which = 'NV'),
  ncol = 3,
  nrow = 1
)
dev.off()



## Peak detection 

#Perform peak detection and show its results. 

# Peaks
x = CNAqc::analyze_peaks(x, matching_strategy = 'closest')
print(x)

peak_plot =  suppressWarnings(suppressMessages(CNAqc::plot_peaks_analysis(x)))

#For this sample these calls are passed by CNAqc.

# Do not assemble plots, and remove karyotypes with no data associated

Plot3 <- plot_peaks_analysis(x, empty_plot = FALSE, assembly_plot = FALSE)
pdf("sample_T_CNAqc_plot_3.pdf", 15, 10)
Plot3
dev.off()

#Perform CCF computation detection with the `ENTROPY` method.

# CCF
x = CNAqc::compute_CCF(x, method = 'ENTROPY')
print(x)

#CCF can be estimated well for this sample.

Plot4 <- plot_CCF(x, assembly_plot = FALSE, empty_plot = FALSE)
# Do not assemble plots, and remove karyotypes with no data associated
pdf("sample_T_CNAqc_plot_4.pdf", 15, 10)
Plot4
dev.off()

Plot5 <- plot_CCF(x, strip = TRUE)

CCF_plot =  suppressWarnings(suppressMessages(CNAqc::plot_CCF(x, strip = TRUE)))

## Other analyses 

#Smooth segments with gaps up to 10 megabases (does not affect segments in this sample).

#x = CNAqc::smooth_segments(x)
#print(x)

#Perform fragmentation analysis (no excess of short segments in this sample).

#x = CNAqc::detect_arm_overfragmentation(x)
#print(x)

        segments_plot = cowplot::plot_grid(
            suppressWarnings(suppressMessages(CNAqc::plot_gw_depth(x))),
            suppressWarnings(suppressMessages(CNAqc::plot_segments(x, highlight = c('1:0', '1:1', '2:0', '2:1', '2:2')))),
            align = 'v',
            nrow = 2,
            rel_heights = c(.15, .8)
          )
       
          # Data histograms
          hist_plot = ggpubr::ggarrange(
              suppressWarnings(suppressMessages(CNAqc::plot_data_histogram(x, which = 'CCF'))),
              suppressWarnings(suppressMessages(CNAqc::plot_data_histogram(x, which = 'VAF'))),
              suppressWarnings(suppressMessages(CNAqc::plot_data_histogram(x, which = 'DP'))),
              suppressWarnings(suppressMessages(CNAqc::plot_data_histogram(x, which = 'NV'))),
              nrow = 1,
              ncol = 4,
              common.legend = TRUE,
              legend = 'bottom'
            )


          
          figure = ggpubr::ggarrange(
            segments_plot,
            hist_plot,
            peak_plot,
            CCF_plot,
            ncol = 1,
            nrow = 4,
            heights = c(1.1, .9, .9, .9)
          )
          
          
pdf("sample_T.pdf", 30, 30)
figure
dev.off()



