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

# Counts reads by gene ID
featureCounts -T 4 -t CDS -g gene_id -a /data/users/${USER}/RNAseq/annotations/Rattus_norvegicus.Rnor_6.0.104.gtf -o CDS_counts_rawfile.txt /data/users/${USER}/RNAseq/bam/*_sorted.bam

# Extract Gene ID and sample columns
cut -f 1,7-12 CDS_counts_rawfile.txt > CDS_counts_processed.txt

# Move to initial directory
cd $cwd

