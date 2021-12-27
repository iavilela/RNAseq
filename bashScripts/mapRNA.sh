#!/bin/bash
#SBATCH --job-name=mapReads
#SBATCH --partition=pall

# Load modules
module add UHTS/Aligner/bowtie/1.2.0

# Store current directors
cwd=$(pwd)

# Move to fastq directory
cd /data/users/ivilela/RNAseq/fastq

# Unzip trimmed files
gunzip *tr.fastq.gz

# Map clipped reads to undesired RNA and only keep reads that do not match.
for x in $(ls -d *tr.fastq); \
do echo ${x}; \
bowtie \
-S \
-t \
-p 4 \
/data/users/${USER}/RNAseq/annotations/Rnor_r_sno_sn_t_RNA ${x} \
--un $(basename ${x} .fastq)_no_r_sno_sn_t-RNA.fastq \
2> $(basename ${x} .fastq)_no_r_sno_sn_t-RNA_log.txt > /dev/null; done

# Return to original directory
cd $cwd
