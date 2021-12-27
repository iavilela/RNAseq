
setwd("/home/ianis/Documents/Uni/RNAseq/BiotypeIdentification")

library(ggplot2)
library(RColorBrewer)
library(dplyr)

qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
Color = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))

data <- read.table(file = "biotype_counts_processed.txt", sep = "\t", header = TRUE)

# Renaming columns
colnames(data) <- c("Biotype",
                    "Neuropil_Poly_1", "Neuropil_Poly_2", "Neuropil_Poly_3",
                    "Somata_Poly_1", "Somata_Poly_2", "Somata_Poly_3")

# Transforming data
data_for_plot <- tidyr::gather(data, "Condition", "Reads", 2:7)

# Defining sample order
sample_order <- c("Biotype",
                  "Neuropil_Poly_1", "Neuropil_Poly_2", "Neuropil_Poly_3",
                  "Somata_Poly_1", "Somata_Poly_2", "Somata_Poly_3")

# Plot
pdf("RPF_biotypes.pdf", paper = "a4", useDingbats = FALSE)
ggplot(data_for_plot, 
       aes(x = factor(Condition, levels = sample_order),
           y = Reads,
           fill = Biotype)) + 
  geom_bar(position = "fill",
           stat = "identity",
           color = "black") +
  scale_fill_manual(values = Color) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90)) +
  xlab("") +
  ylab("Proportion of mapped reads")
dev.off()
