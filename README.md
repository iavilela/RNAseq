# RNA-Sequencing_HS21

### Repository for the RNA-Sequencing course 2021, University of Bern 
> Course: 467713-HS2021-0-RNA-sequencing

---

This repository provides scripts and documents the workflow of the RNA-Sequencing course: **Ribosome Profiling**.
Bash scripts and R scripts are provided in respective directories. Moreover, manually downloaded and generated data needed to run the scripts is provided in the `data` folder. A brief methodological documentation `Methods in Brief` is provided below if interesrepted. Otherwise, a `Quick Guide` is given, which includes the order in which the scripts were run and other information. 

> #### Discalimer: 
> All included bash scripts are run on the IBU cluster. They are written such that IBU cluster users should be able run them and obtain the same results in `/data/users/${USER}/RNAseq`. However, reproducibility for other IBU cluster users was not a primary focus of this project an was thus not tested. If the scripts are run on another machine, file paths need to be adapted. 
> All included R scripts were run on a local machine. Therefore, the working directories and file paths need to be adapted individually to run them properly on other machines.     

## Quick Guide
Following scripts are intended to be run on the IBU cluster and produce their results in `/data/users/${USER}/RNAseq`

  **1. prefetch.sh**
  **2. prepareIndices.sh**
  
        Needs:    `.fa` files and `.gtf` file in the `data` folder provided here.
        Assumes:  Needed files to be in `/data/users/${USERS}/RNAseq/annotations` on IBU cluster (add manually). 

  **3. clipping.sh**
  **4. mapRNA.sh**
  **5. mapGenome.sh**
  **6. qualityCheck.sh**
  **7. featureCountsGeneID.sh**
  **8. featureCountsBiotype.sh**

Following scripts were run on a local machine and need individually adapted path names.
  
  1. **prepRiboseQC.R**
  
      Needs:  - `.2bit` and `.gtf` file in `data` folder provided here.
              - Sorted `.bam` files created by `mapGenome.sh`.
                
  2. **RiboseQC.R**
      
      Needs:  - `.Rnor6` folder generated by `prepRiboseQC.R`.
        
  3. **DEseq2.R**
      
      Needs:  - `CDS_counts_processed.txt` file generated by `featureCountsGeneID.sh`.
        
  **4. BiotypeIdentification.R**
      
      Needs:  - `biotype_counts_processed.txt` generated by `featureCountsBiotype.sh`.
        
  **5. OntologyAnalysis.R**
      
      Needs:  - `DESeq2_res.csv` file generated by `RiboseQC.R`.
  
## Methods in Brief
---
This section gives a step wise overview of the methodological approach. The used tools and corresponding scripts are mentioned for each step. 

### Prefetching Data
Stomata and Neuropil polysome reads of Rattus norvegicus were obtained from https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA550323 using `prefetch`. The obtained `.sra` files were converted to `fasta.gz` files using `fastq_dump`. The obtained files are stored in a dedicated folder called `fastq`. These steps are carried out in the `prefetch.sh` script.

### Annotation Preparation
Fasta files containing undesired RNA (rRNA, snRNA, snoRNA, tRNA, rRNA) were obtained from `Ensembl` (rRNA, snRNA and snoRNA), `GtRNAdb` (tRNA) and `NCBI` (rRNA) and concatenated for subsequent mapping of our reads. Likewise, a Rattus norvegicus reference genome (Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz)  and a corresponding `.gtf` file (Rattus_norvegicus.Rnor_6.0.104.gtf.gz) were obtained from `Ensembl` for subsequent whole genome mapping and structural information.

The obtained files (Rnor_r_sno_sn_t_RNA.fa, Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa and Rattus_norvegicus.Rnor_6.0.104.gtf) are in the `data` folder provided here. These files are needed for subsequent steps of the project and are assumed to be provided in a subfolder called `annotations` in the project root folder for the next script to work.

The obtained genome and undesired RNA sequences were indexed using `bowtie`, which generated multiple `.ebwt` files that remain stored in the `annotations` folder. These steps are performed in the `prepareIndices.sh` script.

### Data pre-processing
Adapter and linker sequences were removed from the fetched reads in the `fastq` folder using `cutadapt`. The resulting files remain stored in the `fastq` folder and have file name suffixes `_clipped` or `_clipped_tr` respectively. This step is executed by the `clipping.sh` script.

### Mapping the data
In a next step our reads were mapped to the undesired RNA sequence `.ebwt` files in a manner to only keep sequences that didn't match. This gave rise to a `fastq.gz` file with the suffix `_no_r_sno_sn_t-RNA` in the `annotations` folder. This file only contains reads that do not correspond to undesired RNA. This step is performed using `bowtie` in is executed the `mapRNA.sh` script.

The resulting file is in turn mapped to the reference genome using `bowtie`. Resulting `.sam` files are converted to `.bam` files and stored. The results are stored in a dedictaed folder called `bam`. This procedure is executed in the `mapGenome.sh` script. 

### FastQC Quality Control
The quality of our reads is assessed using `fastQC`. This is done in the script called `qualitycheck.sh` which applies fastQC on all `.fastq` files in the `fastq` folder. Hence, the quality control is performed for the raw reads as well as for clipped and trimmed reads with and without undesired RNA.  The results are stored in a dedicated folder called `fastqc`. 

### Ribo-seQC Quality Control
The quality of our ribosome profiling data was assessed with `Ribo-seQC`. This package requires a `.2bit` version of the reference genome, which was generated using `faToTwoBit` using following code. 

```bash
faToTwoBit Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa Rattus_norvegicus.Rnor_6.0.dna.toplevel.2bit
```
The `.2bit` file is in the `data` folder provided in this repository.

The script `prepRiboseQC.R` makes use of the `.ebwt`, `.gtf` files as well as the newly generated `.2bit` file. This script creates preparatory files in a directory called `BSgenome.Rattus.norvegicus.Rnor6`. The actual quality control is performed in the script called `RiboseQC.R`, which makes use of the files in `BSgenome.Rattus.norvegicus.Rnor6` and generates various outputfiles for quality assessment.

### Differential Expression Analysis
To perform a differential gene analysis a table was generated, which contains raw read counts for each gene. This is done using `featureCounts` and is executed in the script called `featureCountsGeneID.sh`. The script makes use of the `.gtf` and `.bam` files. The generated table is stored in the `analysis` folder. 

The Actual gene expression analysis makes use of `DEseq2` an is performed in the `DEseq2.R` script. This script takes the newly generated table as input and generates various output files for the assessment of differential expression analysis. Among the output files is a table called `DESeq2_res.csv`, which is needed for the gene ontology analysis (see below). 

### Biotype Analysis
Similarly as before `featureCounts.sh` was used to generate a table that contains raw read counts for different biotypes. This is performed in the script called `featureCountsBiotype.sh`. This table is stored in the `analysis` folder.

The generated table is used in the script called `BiotypeIdentification.R` to visualize the read counts for various biotypes.

### Gene Ontology Analysis
A gene ontology analysis is performed using `TopGo` in the script called `OntologyAnalysis.R`. This script makes use of the file `DESeq2_res.csv` that was previously generated by `DEseq2.R`. Several output files are generated for the assessment of ontology based regulations. 
