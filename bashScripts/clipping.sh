#!/bin/bash

#SBATCH --job-name=adapterClip
#SBATCH --partition=pall

# Load modules
module add UHTS/Quality_control/cutadapt/2.5

# Store current directory
cwd=$(pwd)

# Move to fastq directory
cd /data/users/${USER}/RNAseq/fastq

# Clip 3' adapter and 2 nt from the 5' end
for x in $(ls -d *.fastq.gz); do echo ${x}; \
cutadapt \
 -j 12 \
-a AGATCGGAAGAGCACACGTCTGAA\
 -q 25 \
--cut 2 \
--minimum-length 22 \
--discard-untrimmed \
--overlap 3 \
-e 0.2 \
-o $(basename ${x} .fastq.gz)_clpd.fastq.gz \
${x} 1> $(basename ${x} .fastq.gz)_clpd_log.txt; done


# Trim 10 nt (5 nt randomized bases + 5 nt Barcode) from the 3' end
for x in $(ls -d *_clpd.fastq.gz); do echo ${x}; \
cutadapt \
-j 12 \
-q 25 \
--cut -10 \
--minimum-length 22 \
-o $(basename ${x} .fastq.gz)_tr.fastq.gz \
${x} 1> $(basename ${x} .fastq.gz)_tr_log.txt; done

# Move to original directory
cd $cwd
