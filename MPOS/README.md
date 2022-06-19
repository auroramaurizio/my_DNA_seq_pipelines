# Check MPOS from VCF
  
Check where your variants occur on the sequenced read.
The ideal unbiased output is a bell shaped curve.
 
If the reads are 150 bp long we expect an X axes of 75. If the reads are 100 bp, the x-axis should be 50 bp long. 

This analysis helps to detect biases during the calling. 

![Example](Pictures/aftertrimming.png)


*A good symmetric curve*



![Example](Pictures/beforetrimming.png)
*A curve reflecting a bias.*
*The reads have not been trimmed, and soft clipped regions have not been excluded from calling.*
*This results in artifactual calling in the adapter region (first 5bp of the read)*

![Example](Pictures/adapterregion.png)
*Unbalnaced nucleotide content at the beginning of the reads. Artifact SNVs may be called if this region is not trimmed and soft-clipped regions are not excluded from calling. *
