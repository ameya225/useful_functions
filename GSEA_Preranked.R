# These functions can be used to obtain the desired input for GSEAPreranked algorithm for Broad's GSEA Desktop tool
# mat is the differentially expressed genes matrix obtained as an output from edgeR or limma
# GSEA.P.value is assigned the sign of log Fold Change in order to achieve a weighted analysis and easy interpretation

gsearankedp <- function(mat){
  mat[,"GSEA.P.value"] <- ifelse(mat[,"logFC"] < 0, yes = mat[,"P.Value"]*-1, no = mat[,"P.Value"]*1)
  return(mat)
}

genesym <- function(mat){
  colnames(mat)[1] <- "Gene_symbols"
  return(mat)
}

gseanewmat <- function(mat){
  mat <- cbind(as.character(mat[,1]), mat[,7])
  colnames(mat) <- c("Gene_Symbols", "GSEA.P.Value")
  return(mat)
}

gseap <- function(mat){
  mat <- gsearankedp(mat)
  mat <- genesym(mat)
  mat <- gseanewmat(mat)
  return(mat)
}
