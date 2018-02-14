# Code by Ameya Kulkarni
# E-mail at echo blvmlbso@nbjm.fjotufjo.zv.fev | tr '[b-{' '[a-z]'

# This code can be used to convert Stringdb Ensembl protein ids to HGNC symbols using biomaRt
# The example code is shown for Human protein interaction data from experimental evidence only
# Human Protein Interaction data file can be downloaded from https://stringdb-static.org/download/protein.links.full.v10.5.txt.gz
# Protein pairs with experimental evidence of interaction can be extracted using 
# zgrep ^"9606\." protein.links.full.txt.gz | awk '($10 != 0) { print $1, $2, $10 }' > direct_experimental_data_human.txt

library(biomaRt)
library(dplyr)

ppi <- read.table("path-to-direct_experimental_data_human.txt") # Modify using path to direct_experimental_data_human.txt
ppi <- as.data.frame(sapply(ppi,gsub,pattern="9606.",replacement=""))
ppi <- ppi[,-3]

mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))

P1 <- as.data.frame(ppi$V1)
P2 <- as.data.frame(ppi$V2)
P1_uniq <- unique(P1)
G1_uniq <- getBM(filters= "ensembl_peptide_id", attributes= c("ensembl_peptide_id","hgnc_symbol"),values=P1_uniq,mart= mart)
P2_uniq <- unique(P2)
G2_uniq <- getBM(filters= "ensembl_peptide_id", attributes= c("ensembl_peptide_id","hgnc_symbol"),values=P2_uniq,mart= mart)

colnames(P1) <- "ensembl_peptide_id"
colnames(P2) <- "ensembl_peptide_id"

join1 <- dplyr::left_join(as_tibble(P1)%>%mutate(ensembl_peptide_id=as.character(ensembl_peptide_id)), as_tibble(G1_uniq)%>%mutate(ensembl_peptide_id=as.character(ensembl_peptide_id)), by="ensembl_peptide_id")
join2 <- dplyr::left_join(as_tibble(P2)%>%mutate(ensembl_peptide_id=as.character(ensembl_peptide_id)), as_tibble(G2_uniq)%>%mutate(ensembl_peptide_id=as.character(ensembl_peptide_id)), by="ensembl_peptide_id")

ppi_join <- as.data.frame(cbind(join1$hgnc_symbol, join2$hgnc_symbol))
ppi_join <- ppi_join[complete.cases(ppi_join),]

