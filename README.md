# RNA-Sequencing_HS21

### Repo for the RNA-Sequencing course 2021, University of Bern 
> Course: 467713-HS2021-0-RNA-sequencing

---

This repository documents the the workflow of the RNA-Sequencing course: **Ribosome Profiling**

## Data Availability 
---
> #### Disclaimer: 
> Due to the filesize the source data, intermediate results and final results are not attached to this repository.
> This repositorythus focuses on methodological insight and reproducibility by elaborating workflows and providing scripts. 


## Methods in Brief
---
A brief overview of the workflow will be given here. Bash and R scripts used to perform the described steps are available in the corresponding folders in this repository (`bashScripts` and `Rscripts`). Bash scripts were run on the IBU cluster (hence the SBATCH headers), while R-scripts were run on a local machine.

### Prefetching Data
Stomata and Neuropil polysome reads of Rattus norvegicus were obtained from https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA550323 using `prefetch`. The obtained .sra files were converted to fasta.gz files using `fastq_dump`. The obtained files are stored in a dedicated directory called `fastq`. These steps are carried out in the `prefetch.sh` script.

### Annotation Preperation
Fasta files containing undesired RNA were obtained from `Ensembl` (rRNA, snRNA and snoRNA), `GtRNAdb` (rRNA) and `NCBI` (rRNA) and concatenated for subsequent mapping of our reads. Likewise, a Rattus norvegicus reference genome (Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz)  and a corresponding .gtf file (Rattus_norvegicus.Rnor_6.0.104.gtf.gz) were obtained from `Ensembl` for subsequent whole genome mapping and structural information.
The obtained files (Rnor_r_sno_sn_t_RNA.fa, Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa and Rattus_norvegicus.Rnor_6.0.104.gtf) are assumed to be provided in a folder called `annotations` in the project folder for the next scripts to work.

The obtained genome and undesired RNA sequences were indexed using `bowtie`, which generated multiple .bwt files that remain stored in the `annotations` folder. These steps are performed in the `prepareIndices.sh` script.

### Data pre-processing
Adapter and linker sequences were removed from the fetched reads in the `fastq` using `cutadapt`. The resulting files remain stored in the `fastq` folder aswell with file name suffixes `_clipped` or `_clipped_tr` respectively. This step is executed by the `clipping.sh` script.

### Mapping the data
In a next step our reads were mapped to the undisired RNA sequence .bwt files in a manner to only keep sequences that didn't match. This gave rise to a `fastq.gz` file with the suffix `_no_r_sno_sn_t-RNA` in the `annotations` folder. This file only contains reads that do not correspond to undesired RNA. This step is performed using `bowtie` in is executed the `mapRNA.sh` script.

The resulting file is in turn mapped to the reference genome using `bowtie`. Resulting .sam files are converted to .bam files and stored in a dedicated folder `bam`. The obtained .bam files are sorted. This whole procedure is executed in the `mapGenome.sh` script. 

### FastQC Quality Control
Processing steps with `fastqc` for quality control and `fastp` for cleanup were done using

### RiboseQC Quality Control

```bash
#verify that your files are in your directory (ls -l)
fastqc -t 2 ${XX}_1.fastq.gz ${XX}_2.fastq.gz
```



