library(ggplot2)
library(dplyr)

#bedtools intersect -a urin_gains.bed -b rmsk.bed -wo > urin_gains_intersect_wo.txt
#bedtools intersect -a urin_losses.bed -b rmsk.bed -wo > urin_losses_intersect_wo.txt 
#bedtools intersect -a blood_losses.bed -b rmsk.bed -wo > blood_losses_intersect_wo.txt 
#bedtools intersect -a blood_gains.bed -b rmsk.bed -wo > blood_gains_intersect_wo.txt 

setwd("/beegfs/scratch/ric.cosr/ric.cosr/Menarini/repeats")

blood_gains <- read.table("blood_gains_intersect_wo.txt")
blood_losses <- read.table("blood_losses_intersect_wo.txt")
urin_gains <- read.table("urin_gains_intersect_wo.txt")
urin_losses <- read.table("urin_losses_intersect_wo.txt")

sum(urin_gains$size)
table(urin_gains$repClass)

rmsk <- read.table("rmsk.bed")

head(rmsk)
colnames(rmsk) = c("chr","start","end","repName","unk","strand", "repClass","repFamily")
rmsk$size <- rmsk$end - rmsk$start

# Barplot

rmsk_summary <- as.data.frame(rmsk %>% group_by(repClass) %>% summarise(size = sum(size)))
head(rmsk_summary)

rmsk_summary$elements <- "repeats"
bp<- ggplot(rmsk_summary, aes(x=elements, y=size, fill=repClass))+
  geom_bar(width = 1, stat = "identity")


#######################
blood_gains

colnames(blood_gains) = c("chr","start","end","GL", "patient","cell","Rchr","Rstart","Rend","repName","unk","Rstrand", "repClass","repFamily","size")
colnames(urin_gains) = c("chr","start","end","GL", "patient","cell","Rchr","Rstart","Rend","repName","unk","Rstrand", "repClass","repFamily","size")
colnames(blood_losses) = c("chr","start","end","GL", "patient","cell","Rchr","Rstart","Rend","repName","unk","Rstrand", "repClass","repFamily","size")
colnames(urin_losses) = c("chr","start","end","GL", "patient","cell","Rchr","Rstart","Rend","repName","unk","Rstrand", "repClass","repFamily","size")

sum(blood_gains$size)
sum(rmsk$size)

# Barplot
blood_gains_summary <- as.data.frame(blood_gains %>% group_by(repClass) %>% summarise(size = sum(size)))
colnames(blood_gains_summary) <- c("repClass","size")
blood_gains_summary$dataset <- "blood_gains"

blood_losses_summary <- as.data.frame(blood_losses %>% group_by(repClass) %>% summarise(size = sum(size)))
colnames(blood_losses_summary) <- c("repClass","size")
blood_losses_summary$dataset <- "blood_losses"

urin_gains_summary <- as.data.frame(urin_gains %>% group_by(repClass) %>% summarise(size = sum(size)))
colnames(urin_gains_summary) <- c("repClass","size")
urin_gains_summary$dataset <- "urin_gains"

urin_losses_summary <- as.data.frame(urin_losses %>% group_by(repClass) %>% summarise(size = sum(size)))
colnames(urin_losses_summary) <- c("repClass","size")
urin_losses_summary$dataset <- "urin_losses"

rmsk_summary = rmsk_summary[c("repClass","size")]
rmsk_summary$dataset <- "rmsk"




#put all data frames into list
df_list <- list(rmsk_summary,urin_gains_summary,urin_losses_summary, blood_gains_summary, blood_losses_summary)

#merge all data frames in list
all <- Reduce(function(x, y) merge(x, y, all=TRUE), df_list)
bound <- rbind(rmsk_summary,urin_gains_summary,urin_losses_summary, blood_gains_summary, blood_losses_summary)
head(bound)




library(RColorBrewer)

# Define a custom palette of 20 colors
custom_palette <- c(
  "#E41A1C",  # Red
  "#377EB8",  # Blue
  "#4DAF4A",  # Green
  "#FF7F00",  # Orange
  "#984EA3",  # Purple
  "#FFD700",  # Yellow
  "#A65628",  # Brown
  "#F781BF",  # Pink
  "#999999",  # Gray
  "#66C2A5",  # Teal
  "#FB9A99",  # Salmon
  "#8B4513",  # SaddleBrown
  "#F08080",  # LightCoral
  "#4682B4",  # SteelBlue
  "#B8860B",  # DarkGoldenrod
  "#556B2F",  # DarkOliveGreen
  "#6495ED",  # CornflowerBlue
  "#8A2BE2",  # BlueViolet
  "#DC143C",  # Crimson
  "#1E90FF"   # DodgerBlue
)

# Set the custom palette as the default ggplot colors
scale_colour_manual(values = custom_palette)
scale_fill_manual(values = custom_palette)





bp<- ggplot(bound, aes(x=dataset, y=size, fill=repClass))+
  geom_bar(width = 1, stat = "identity") + scale_fill_manual(values = custom_palette)



library(dplyr)

# Assuming your data frame is named df
df <- bound  # Read your data from a CSV file or replace with your data frame

# Calculate frequencies for each dataset and repClass combination
df <- df %>%
  group_by(dataset, repClass) %>%
  summarise(frequency = sum(size)) %>%
  ungroup()

# Calculate total frequencies for each dataset
total_freq <- df %>%
  group_by(dataset) %>%
  summarise(total = sum(frequency))

# Merge total frequencies with the original data
df <- left_join(df, total_freq, by = "dataset")

# Calculate percentage
df <- df %>%
  mutate(percentage = (frequency / total) * 100)

# Plot
library(ggplot2)

ggplot(df, aes(x = dataset, y = percentage, fill = repClass)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Stacked Barplot of Frequencies Percentages",
       x = "Dataset",
       y = "Percentage") +
  theme_minimal() +
  theme(legend.position = "right") + scale_fill_manual(values = custom_palette)



################################################################################



# Barplot


rmsk_summary <- as.data.frame(rmsk %>% group_by(repFamily) %>% summarise(size = sum(size)))
head(rmsk_summary)


# Barplot
blood_gains_summary <- as.data.frame(blood_gains %>% group_by(repFamily) %>% summarise(size = sum(size)))
colnames(blood_gains_summary) <- c("repFamily","size")
blood_gains_summary$dataset <- "blood_gains"

blood_losses_summary <- as.data.frame(blood_losses %>% group_by(repFamily) %>% summarise(size = sum(size)))
colnames(blood_losses_summary) <- c("repFamily","size")
blood_losses_summary$dataset <- "blood_losses"

urin_gains_summary <- as.data.frame(urin_gains %>% group_by(repFamily) %>% summarise(size = sum(size)))
colnames(urin_gains_summary) <- c("repFamily","size")
urin_gains_summary$dataset <- "urin_gains"

urin_losses_summary <- as.data.frame(urin_losses %>% group_by(repFamily) %>% summarise(size = sum(size)))
colnames(urin_losses_summary) <- c("repFamily","size")
urin_losses_summary$dataset <- "urin_losses"

rmsk_summary = rmsk_summary[c("repFamily","size")]
rmsk_summary$dataset <- "rmsk"




#put all data frames into list
df_list <- list(rmsk_summary,urin_gains_summary,urin_losses_summary, blood_gains_summary, blood_losses_summary)

#merge all data frames in list
all <- Reduce(function(x, y) merge(x, y, all=TRUE), df_list)
bound <- rbind(rmsk_summary,urin_gains_summary,urin_losses_summary, blood_gains_summary, blood_losses_summary)
head(bound)


length(unique(rmsk$repFamily))
# Generate a palette with 68 colors from the viridis palette

library(viridis)
install.packages(viridis)
custom_palette <- viridis(68)



bp<- ggplot(bound, aes(x=dataset, y=size, fill=repFamily))+
  geom_bar(width = 1, stat = "identity") 

# Assuming your data frame is named df
df <- bound  # Read your data from a CSV file or replace with your data frame

# Calculate frequencies for each dataset and repFamily combination
df <- df %>%
  group_by(dataset, repFamily) %>%
  summarise(frequency = sum(size)) %>%
  ungroup()

# Calculate total frequencies for each dataset
total_freq <- df %>%
  group_by(dataset) %>%
  summarise(total = sum(frequency))

# Merge total frequencies with the original data
df <- left_join(df, total_freq, by = "dataset")

# Calculate percentage
df <- df %>%
  mutate(percentage = (frequency / total) * 100)

# Plot
library(ggplot2)

ggplot(df, aes(x = dataset, y = percentage, fill = repFamily)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Stacked Barplot of Frequencies Percentages",
       x = "Dataset",
       y = "Percentage") +
  theme_minimal() +
  theme(legend.position = "right") 



as.data.frame(df[order(df$percentage, decreasing = TRUE),])


###############################################################################

# Group CNVs by chromosome
cnv_by_chr <- blood_gains %>%
  group_by(chr) %>%
  summarize(total_length = sum(size))

# Plot the distribution of CNVs along chromosomes
ggplot(cnv_by_chr, aes(x = chr, y = total_length)) +
  geom_bar(stat = "identity") +
  labs(x = "Chromosome", y = "Total CNV Length") +
  ggtitle("Distribution of CNVs overlapping REP Along Chromosomes")  + ylim(0, 1000000000)

rmsk_sub <- rmsk[!grepl("_alt", rmsk$chr), ]
rmsk_sub <- rmsk_sub[!grepl("_random", rmsk_sub$chr), ]
rmsk_sub <- rmsk_sub[!grepl("_fix", rmsk_sub$chr), ]
rmsk_sub <- rmsk_sub[!grepl("chrUn_", rmsk_sub$chr), ]
rmsk_sub <- rmsk_sub[!grepl("chrM", rmsk_sub$chr), ]

# Group CNVs by chromosome
cnv_by_chr <- rmsk_sub %>%
  group_by(chr) %>%
  summarize(total_length = sum(size))

# Plot the distribution of CNVs along chromosomes
ggplot(cnv_by_chr, aes(x = chr, y = total_length)) +
  geom_bar(stat = "identity") +
  labs(x = "Chromosome", y = "Total CNV Length") +
  ggtitle("Distribution of repeats Along Chromosomes") + ylim(0, 1000000000)



te_counts <- table(blood_gains$repClass)

# Calculate frequencies of TE classes within CNVs
te_frequency <- prop.table(te_counts)

test <- as.data.frame(te_frequency)
sum(test$Freq)


?prop.table
library(ggplot2)

# Assuming you have the frequencies of TE classes within CNVs
# te_frequency <- prop.table(te_counts)

# Convert te_frequency to a data frame for plotting
te_frequency_df <- data.frame(TE_class = names(te_frequency),
                              Frequency = as.numeric(te_frequency))

# Create a bar plot
barplot <- ggplot(te_frequency_df, aes(x = TE_class, y = Frequency)) +
  geom_bar(stat = "identity") +
  labs(x = "TE Class", y = "Frequency", title = "Occurrences of TE Classes within CNVs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ylim(0,0.5)  # Rotate x-axis labels if needed

# Display the bar plot
print(barplot)

######################

library(ggplot2)

unique(rmsk_sub$chr)

te_counts <- table(rmsk_sub$repClass)

# Calculate frequencies of TE classes within CNVs
te_frequency <- prop.table(te_counts)

# Assuming you have the frequencies of TE classes within CNVs
# te_frequency <- prop.table(te_counts)

# Convert te_frequency to a data frame for plotting
te_frequency_df <- data.frame(TE_class = names(te_frequency),
                              Frequency = as.numeric(te_frequency))

# Create a bar plot
barplot <- ggplot(te_frequency_df, aes(x = TE_class, y = Frequency)) +
  geom_bar(stat = "identity") +
  labs(x = "TE Class", y = "Frequency", title = "Occurrences of TE Classes within CNVs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ylim(0,0.5)  # Rotate x-axis labels if needed

# Display the bar plot
print(barplot)

######################



te_counts <- table(urin_gains$repClass)

# Calculate frequencies of TE classes within CNVs
te_frequency <- prop.table(te_counts)

test <- as.data.frame(te_frequency)
sum(test$Freq)

# Assuming you have the frequencies of TE classes within CNVs
# te_frequency <- prop.table(te_counts)

# Convert te_frequency to a data frame for plotting
te_frequency_df <- data.frame(TE_class = names(te_frequency),
                              Frequency = as.numeric(te_frequency))

# Create a bar plot
barplot <- ggplot(te_frequency_df, aes(x = TE_class, y = Frequency)) +
  geom_bar(stat = "identity") +
  labs(x = "TE Class", y = "Frequency", title = "Occurrences of TE Classes within CNVs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ylim(0,0.5)  # Rotate x-axis labels if needed

# Display the bar plot
print(barplot)


################



te_counts <- table(urin_losses$repClass)

# Calculate frequencies of TE classes within CNVs
te_frequency <- prop.table(te_counts)

test <- as.data.frame(te_frequency)
sum(test$Freq)

# Assuming you have the frequencies of TE classes within CNVs
# te_frequency <- prop.table(te_counts)

# Convert te_frequency to a data frame for plotting
te_frequency_df <- data.frame(TE_class = names(te_frequency),
                              Frequency = as.numeric(te_frequency))

# Create a bar plot
barplot <- ggplot(te_frequency_df, aes(x = TE_class, y = Frequency)) +
  geom_bar(stat = "identity") +
  labs(x = "TE Class", y = "Frequency", title = "Occurrences of TE Classes within CNVs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ylim(0,0.5)  # Rotate x-axis labels if needed

# Display the bar plot
print(barplot)


#################
head(blood_losses)


te_counts <- table(blood_losses$repClass)

# Calculate frequencies of TE classes within CNVs
te_frequency <- prop.table(te_counts)

test <- as.data.frame(te_frequency)
sum(test$Freq)

# Assuming you have the frequencies of TE classes within CNVs
# te_frequency <- prop.table(te_counts)

# Convert te_frequency to a data frame for plotting
te_frequency_df <- data.frame(TE_class = names(te_frequency),
                              Frequency = as.numeric(te_frequency))

# Create a bar plot
barplot <- ggplot(te_frequency_df, aes(x = TE_class, y = Frequency)) +
  geom_bar(stat = "identity") +
  labs(x = "TE Class", y = "Frequency", title = "Occurrences of TE Classes within CNVs") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+ ylim(0,0.5)  # Rotate x-axis labels if needed

# Display the bar plot
print(barplot)
#################





# Load required libraries
library(GenomicRanges)
library(data.table)

# Assuming you have CNV coordinates and TE coordinates in data frames
# CNV data frame (cnv_df) should have columns: chrom, start, end
# TE data frame (te_df) should have columns: chrom, start, end, class


cnv_df <- blood_gains
cnv_df$chrom <- cnv_df$chr
te_df <- rmsk
te_df$chrom <- te_df$chr

library(GenomicRanges)

# Create GenomicRanges objects for CNVs and TEs
cnv_gr <- GRanges(seqnames = cnv_df$chrom,
                  ranges = IRanges(start = cnv_df$start, end = cnv_df$end))

te_gr <- GRanges(seqnames = te_df$chrom,
                 ranges = IRanges(start = te_df$start, end = te_df$end),
                 repClass = te_df$repClass)

# Perform overlap between CNVs and TEs
overlap <- findOverlaps(cnv_gr, te_gr)

# Convert the overlap object to a data frame
overlap_df <- as.data.frame(overlap)

library(data.table)
# Calculate the number of CNVs overlapping each TE class
overlap_summary <- data.table(cnv_df)[, .N, by = te_gr$repClass]

# Calculate the background distribution of TE classes
background_distribution <- table(te_df$repClass)

# Calculate enrichment
overlap_summary[, enrichment := N / background_distribution[repClass]]

# Filter for the particular TE class you are interested in
# For example, if you're interested in class "Alu" for SINEs:
enrichment_alu <- overlap_summary[class == "Alu", ]

# Display the enrichment results
print(enrichment_alu)

#############################################################


data_df <- blood_losses

# Install and load required packages
#install.packages("circlize")
library(circlize)

bed = generateRandomBed(nc = 2)
head(bed, n = 2)

circos.initializeWithIdeogram()
circos.genomicTrackPlotRegion(bed, panel.fun = function(region, value, ...) {
  if(CELL_META$sector.index == "chr1") {
    print(head(region, n = 2))
    print(head(value, n = 2))
  }
})

circos.genomicTrackPlotRegion(data, ylim = c(0, 1),
                              panel.fun = function(region, value, ...) {
                                circos.genomicPoints(region, value, ...)
                              })
circos.genomicTrackPlotRegion(data, numeric.column = c("value1", "value2"), 
                              panel.fun = function(region, value, ...) {
                                circos.genomicPoints(region, value, ...)
                              })



# Assuming you have your CNV and TE data loaded into a data frame called 'data_df'
# Replace 'data_df' with your actual data frame name

# Convert chromosome names to numeric values for ordering
data_df$chr_numeric <- as.numeric(gsub("chr", "", data_df$chr))

# Sort data by chromosome and start position
data_df <- data_df[order(data_df$chr_numeric, data_df$start), ]

# Create a GRanges object for CNVs
library(GenomicRanges)
cnv_gr <- GRanges(seqnames = data_df$chr,
                  ranges = IRanges(start = data_df$start, end = data_df$end))

# Create a GRanges object for TEs
te_gr <- GRanges(seqnames = data_df$Rchr,
                 ranges = IRanges(start = data_df$Rstart, end = data_df$Rend),
                 repName = data_df$repName)

#cytoband <- read.table("cytoBand.txt", header = FALSE, stringsAsFactors = FALSE,
#                       col.names = c("chrom", "start", "end", "band", "gieStain"))

# Read chromInfo file
#chrom_info <- read.table("chromInfo.txt", header = FALSE, stringsAsFactors = FALSE,
#                         col.names = c("chrom", "length"))

# Set up Circos plot parameters
circos.initializeWithIdeogram(track.height = 0.2)
#circos.initializeWithIdeogram(ideogram = cytoband, track.height = 0.2)

# Set up Circos plot parameters
#circos.initializeWithIdeogram(species = "human", track.height = 0.2)
?circos.genomicTrack
# Plot CNVs
circos.genomicTrack(data = blood_losses, 
                    panel.fun = function(region, value, ...) {
                      circos.genomicPoints(region, value, ...)
                      circos.genomicPoints(region, value)
                      # 1st column in `value` while 4th column in `data`
                      circos.genomicPoints(region, value, numeric.column = 1)
                    })

head(blood_losses)

# Plot TEs
circos.genomicTrack(data = blood_losses, )

# Add a legend
circos.trackPoints(1:2, c(1, 2), col = c("blue", "red"), lwd = 5, pch = 15, cex = 3, labels = c("CNV", "TE"))

# Draw the plot
circos.clear()
