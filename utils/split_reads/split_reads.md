# Split reads in chunks with seqkit in PE mode

https://bioinf.shenwei.me/seqkit/usage/

## Example

### Input files:

CELL3326_S16_L001_R1_001.fastq.gz
CELL3326_S16_L001_R2_001.fastq.gz
CELL3326_S16_L002_R1_001.fastq.gz
CELL3326_S16_L002_R2_001.fastq.gz

### Command:

seqkit split2 -1 CELL3326_S16_L001_R1_001.fastq.gz -2 CELL3326_S16_L001_R2_001.fastq.gz -p 2 -O CELL3326_S16_L001_split2 -f
seqkit split2 -1 CELL3326_S16_L002_R1_001.fastq.gz -2 CELL3326_S16_L002_R2_001.fastq.gz -p 2 -O CELL3326_S16_L002_split2 -f


### Comment:

seqkit splits the total reads in the original PE files in N chunks (in this case 2 chunks was enough) so that:
the first read of the original R1 file goes to R1_part_001 file, 
the second read of the original R1 file goes to R1_part_002 file, 
the third read of the original R1 file goes to R1_part_001 file, 
the fourth read of the original R1 file goes to R1_part_002 file and so on.
The same goes for R2 reads.
R1 and R2 reads are matched in R1_part_001 and R2_part_001 files, as well as in R1_part_002 and R2_part_001.
