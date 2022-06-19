# GATK4 mutect (gatk4=4.2.2.0) variant calling pipeline

In this pipeline we take care of problems such as:

## Bad quality bases at the beginning of the reads (residues of adapters, primers etc.)
(https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

## Bad quality of tiles (resulting from the presence of dust, bubbles, scratches on the flowcell surface or caused by overloadaded flowcell)
## that can result in artifactual insertion and deletion calls as described here:
https://sequencing.qcfail.com/articles/position-specific-failures-of-flowcells/

(https://github.com/abiswas-odu/Disco/blob/master/bbmap/filterbytile.sh)


## Short insert sizes resulting in overlapping FW and REV PE reads 
(https://genome.sph.umich.edu/wiki/BamUtil:_clipOverlap)


