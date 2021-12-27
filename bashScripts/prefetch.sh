#!/bin/bash

#SBATCH --job-name=prefetch
#SBATCH --partition=pall

# Loading modules
module add UHTS/Analysis/sratoolkit/2.10.7

# Safe current path
cwd=$(pwd)

# Creating  directories
mkdir /data/users/${USER}/RNAseq
mkdir /data/users/${USER}/RNAseq/fastq

# Moving to directory
cd /data/users/${USER}/RNAseq/fastq
 
#Creating .txt file
touch samples.txt

# Writting needed samples to text file
echo "SRR9596295.sra" > samples.txt
echo "SRR9596296.sra" >> samples.txt
echo "SRR9596300.sra" >> samples.txt
echo "SRR9596310.sra" >> samples.txt
echo "SRR9596303.sra" >> samples.txt
echo "SRR9596304.sra" >> samples.txt

# Prefetching .sra files
prefetch --option-file samples.txt
rm smaples.txt

# Covert .sra to .fastq files
fastq-dump --gzip SRR*.sra

# Renaming files
mv ./SRR9596295.fastq.gz ./Biever_Somata_Poly_1.fastq.gz
mv ./SRR9596296.fastq.gz ./Biever_Somata_Poly_2.fastq.gz
mv ./SRR9596300.fastq.gz ./Biever_Somata_Poly_3.fastq.gz
mv ./SRR9596310.fastq.gz ./Biever_Neuropil_Poly_1.fastq.gz
mv ./SRR9596303.fastq.gz ./Biever_Neuropil_Poly_2.fastq.gz
mv ./SRR9596304.fastq.gz ./Biever_Neuropil_Poly_3.fastq.gz

#move to original direcotry
cd $cwd

