clear all       
program weakivdemo, rclass                 
version 17.0
syntax [, obs(integer 1) pi(real 1) cor(real 1)] 
  drop _all
  set obs `obs'
  gen z = rnormal()
  gen v = rnormal()
  gen e = rnormal() + `cor'*v
  gen x = `pi'*z + v
  gen y = 2*`pi'*z + (2*v + e)
  reg y x
  return scalar bols = _b[x]
  return scalar seols = _se[x]
  ivregress 2sls y (x=z)
  return scalar biv = _b[x]
  return scalar seiv = _se[x]
  reg x z
  return scalar Fiv = e(F)
end   
simulate bols=r(bols) seols=r(seols) biv=r(biv) seiv=r(seiv) ///
         Fiv=r(Fiv), seed(20230526) reps(1000) nolegend nodots: ///
		 weakivdemo, obs(1000) pi(0.1) cor(0.5775) 
mean bols seols biv seiv Fiv
