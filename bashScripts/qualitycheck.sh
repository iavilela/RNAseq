#!/bin/bash

#SBATCH --job-name=qualitycheck
#SBATCH --partition=pall


# Load modules
module add UHTS/Quality_control/fastqc/0.11.9;

# Store current path
cwd=$(pwd)

# Move to data direcoty
cd /data/users/${USER}/RNAseq

# Create directories
mkdir ./fastqc

# Perform quality check
fastqc -o ./fastqc -f fastq ./fastq/*.fastq.gz

# Move to original directory
cd $cwd
