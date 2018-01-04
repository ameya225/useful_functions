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