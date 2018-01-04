# mat is the gene expression raw count matrix obtained from RSEM or HTSeq
# cpmvalue is the threshold counts per million value used for filtering lowly expressed genes. Default is 1
# propvalue is the proportion of samples for which the threshold value is achieved. Default is 0.5

filtgenes <- function(mat, cpmvalue, propvalue){
  if(missing(cpmvalue)){
    cpmvalue=1
  } else{
    cpmvalue=cpmvalue
  }
  if(missing(propvalue)){
    propvalue=0.5
  } else{
    propvalue=propvalue
  }
  mat[(rowSums((cpm(mat))>cpmvalue) >= propvalue*ncol(mat)),]
}