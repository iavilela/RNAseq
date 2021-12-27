#!/bin/bash

#SBATCH --job-name=bowtiealign
#SBATCH --partition=pall

# Load modules
module add UHTS/Aligner/bowtie/1.2.0

# Store current direcory
cwd=$(pwd)

# Move to directory
cd /data/users/${USER}/RNAseq/annotations

# Build indices of undesired RNAs and R. norvegicus genome.
# This step assumes that the annotations directory and files are provided,
bowtie-build Rnor_r_sno_sn_t_RNA.fa Rnor_r_sno_sn_t_RNA
bowtie-build Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa Rattus_norvegicus.Rnor_6.0.dna.toplevel

# Move to original direcotry 
cd $cwd
