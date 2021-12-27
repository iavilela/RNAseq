library("RiboseQC")

setwd("/home/ianis/Documents/Uni/RNAseq/riboseQC")

genome_bam <- c("/home/ianis/Documents/Uni/RNAseq/bam/Biever_Neuropil_Poly_1_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam",
                "/home/ianis/Documents/Uni/RNAseq/bam/Biever_Neuropil_Poly_2_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam",
                "/home/ianis/Documents/Uni/RNAseq/bam/Biever_Neuropil_Poly_3_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam",
                "/home/ianis/Documents/Uni/RNAseq/bam/Biever_Somata_Poly_1_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam",
                "/home/ianis/Documents/Uni/RNAseq/bam/Biever_Somata_Poly_2_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam",
                "/home/ianis/Documents/Uni/RNAseq/bam/Biever_Somata_Poly_3_clpd_tr_no_r_sno_sn_t-RNA_Rnor_6_sorted.bam")

RiboseQC_analysis(annotation_file ="/home/ianis/Documents/Uni/RNAseq/riboseQC/Rattus_norvegicus.Rnor_6.0.104.gtf_Rannot",
                  bam_files = genome_bam,
                  fast_mode = T,
                  report_file = "Rnor_Biever_QC.html",
                  sample_names = c("Neuropil_Poly_1", "Neuropil_Poly_2", "Neuropil_Poly_3",
                                   "Somata_Poly_1", "Somata_Poly_2", "Somata_Poly_3"),
                  dest_names = c("Neuropil_Poly_1", "Neuropil_Poly_2", "Neuropil_Poly_3",
                                 "Somata_Poly_1", "Somata_Poly_2", "Somata_Poly_3"),
                  write_tmp_files = F)
