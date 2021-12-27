library("devtools")
library("ggplot2")
install_github(repo = "lcalviell/Ribo-seQC")

library("RiboseQC")

setwd("/home/ianis/Documents/Uni/RNAseq")

prepare_annotation_files(annotation_directory = "/home/ianis/Documents/Uni/RNAseq/annotations/",
                         twobit_file = "/home/ianis/Documents/Uni/RNAseq/annotations/Rattus_norvegicus.Rnor_6.0.dna.toplevel.2bit",
                         gtf_file = "/home/ianis/Documents/Uni/RNAseq/annotations/Rattus_norvegicus.Rnor_6.0.104.gtf",
                         scientific_name = "Rattus.norvegicus",
                         annotation_name = "Rnor_6",
                         export_bed_tables_TxDb = F,
                         forge_BSgenome = T,
                         create_TxDb = T)