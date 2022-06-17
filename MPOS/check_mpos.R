require(dplyr) 
require(vcfR)  


vcf_file = read.vcfR('Mutect2_filtered_UPN02_PRE_vs_UPN02_PG.vep.vcf.gz', verbose = FALSE) 

x = vcf_file

prova =extract_info_tidy(x, info_fields = "MPOS", info_types = TRUE, info_sep = ";")

POS= as.data.frame(as.numeric(prova$MPOS))

colnames(POS) = c("POS")
x = POS$POS
x<-x[!is.na(x)]

as.data.frame(table(x))

pdf("UPN02_PRE_mpos.pdf")
hist(x, # histogram
     col="peachpuff", # column color
     border="black",
     prob = TRUE, # show densities instead of frequencies
     xlab = "temp",
     breaks = 100,
     main = "UPN02_PRE")
lines(density(x, # density plot
              lwd = 2, # thickness of line
              col = "chocolate3"))
dev.off()

