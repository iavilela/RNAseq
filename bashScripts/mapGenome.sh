#!/bin/bash
#SBATCH --job-name=mapReads
#SBATCH --partition=pall

# Load modules
module add UHTS/Aligner/bowtie/1.2.0
module add UHTS/Analysis/samtools/1.10;

# Store current directors
cwd=$(pwd)

# Move to fastq directory
cd /data/users/ivilela/RNAseq/fastq

# Rename fasta files
for x in $(ls -d *t-RNA*);
do mv $x ${x//-/};
done

# Map trimmed sequences to reference genome
for x in $(ls -d *RNA.fastq); \
do echo ${x}; \
bowtie \
-S \
-t \
-p 4 \
-v 1 \
-m 1 \
--best \
--strata \
/data/users/ivilela/RNAseq/annotations/Rattus_norvegicus.Rnor_6.0.dna.toplevel \
-q ${x} \
2> $(basename ${x} .fastq)_Rnor_6_log.txt | \
samtools view -h -F 4 -b > $(basename ${x} .fastq)_Rnor_6.bam; done

# Sorting the BAM file
for x in $(ls -d *.bam); \
do echo ${x}; \
samtools sort \
-@ 4 \
${x} \
-o $(basename ${x} .bam)_sorted.bam; done

# Moving .bam files to a dedicated directory
mkdir ../bam
mv *.bam ../bam

# Going back to initial directory
cd $(cwd)
