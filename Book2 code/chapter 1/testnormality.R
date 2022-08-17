testnormality = function(X, numproj = 1000)
{
  p = ncol(X); n = nrow(X)
  x = matrix(rnorm(numproj * p), nrow = p)
  #### Generate 1,000 standard p-variate normal random variables.
  y = matrix(sqrt(apply(x^2, 2, sum)), nrow = p, ncol = numproj, by = T)
  z = x / y
  tempdat = as.matrix(X) %*% z
  #### This gives rise to a n x numproj matrix
  #### Perform Shapiro-Wilks' test and calculate individual p-values on each of the numproj observation sets.
  pvals = as.numeric(matrix(unlist(apply(tempdat,2,shapiro.test)),ncol=4,
                            by =T)[,2])
  #### Multiple hypthesis testing
  return(min(p.adjust(pvals,method="BH")))
}