# SurfR

Proteins at the cell surface connect intracellular and extracellular
 signaling networks and largely determine a cell’s capacity to 
communicate and interact with its environment. 

Importantly, variations in transcriptomic profiles are often observed
between healthy and diseased cells, presenting distinct sets 
of cell-surface proteins. Indeed, cell surface proteins 
i) may act as biomarkers for the detection of diseased cells
 in tissues or body fluids 
and 
ii) are the most prevalent target of human drugs:
 66% of approved human drugs listed in the DrugBank database 
target a cell-surface protein. 
The investigation of the cell surfaceome therefore could 
provide new possibilities for diagnosis, prognosis, 
treatment development, and therapy response evaluation.



## What is SurfR

The **SurfR** package aims to provide a streamlined end-to-end workflow  
for identifying surfaceome markers from expression data using computational prediction.



**SurfR**

-   Returns a list of of surface protein coding genes, starting from 
    a list of genes of interest, the raw count matrix of your own
    RNA-seq experiment, or from bulk transcriptomic data 
    automatically retrieved from public databases. Protein classification 
    is based on a recently developed surfaceome predictor, 
    called SURFY, based on machine learning. 
-   Allows automatic data retrieval from public databases such as 
    GEO and TCGA. GEO queries are based on the ArchS4 pipeline. 
    TCGA repository is interrogated through TCGAbiolinks.
-   Provides a function for differential gene expression analysis. 
    For this task it relies on DESeq2 package, starting from counts data. 
-   Offers the opportunity to increase the sample size of a cohort
    by integrating related datasets, therefore enhancing the power
    to detect differentially expressed genes of interest. 
    Meta-analysis can be performed through metaRNASeq, taking into
    account inter-study variability that may arise from technical
    differences among studies (e.g., sample preparation, library
    protocols, batch effects) as well as additional biological
    variability.
-   Gene ontology (GO) and pathway annotation can also be performed
    within **SurfR** to gain further insights about surface protein
    candidates.
-   **SurfR** includes functions to visualize DEG and enrichment results,
    including BarPlots, Histograms, Venn diagrams, and PCA plots to help 
    users achieve efficient data interpretation.



## Installation

Developement package version can be installed from GitHub using devtools:

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("SurfR")
    
devtools::install_github("auroramaurizio/SurfR.git")
```


## Dependencies
This package is supported for macOS, Windows and Linux. 
SurfR works with R v4.1 or greater.
Dependencies are indicated in the Description file, and can be 
automatically installed when installing SurfR pacakge. 

## Vignettes

A comprehensive vignette provides an introduction to the SurfR package. 
Examples and use-cases are covered for each function.


## Documentation

Instructions to run the main functions can be found consulting the vignette
 or by entering ?SurfR in the console after loading the package.


## Authors

Aurora Maurizio and Anna Sofia Tascini 

## Help, Suggestions, and Contributions

Any contribution is highly appreciated! If you are interested in contributing to this project, please open an issue.
