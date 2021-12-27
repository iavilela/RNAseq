#!/bin/bash

#SBATCH --job-name=featureCounts
#SBATCH --partition=pall

# Load modules
module add UHTS/Analysis/subread/2.0.1

# Store current directory
cwd=$(pwd)

# Create and move to analysis directory
mkdir /data/users/${USER}/RNAseq/analysis
cd /data/users/${USER}/RNAseq/analysis

# Extract reads mapped to different biotypes

featureCounts -T 4 -t exon -g gene_biotype -a /data/users/${USER}/RNAseq/annotations/Rattus_norvegicus.Rnor_6.0.104.gtf -o biotype_counts_rawfile.txt /data/users/${USER}/RNAseq/bam/*_sorted.bam

# Extract Biotype and Sample columns

cut -f 1,7-12 biotype_counts_rawfile.txt > biotype_counts_processed.txt

# Move to initial directory
cd $cwd

