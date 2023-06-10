clear all       
program weakivbias, rclass                 
version 17.0
syntax [, obs(integer 1) pi(real 1)] 
  drop _all
  set obs `obs'
  gen v = rnormal()
  gen e = rnormal() + 0.2*v
  gen z = 0.01*e + rnormal()
  gen x = `pi'*z + v
  gen y = 2*x + e
  reg y x
  return scalar bols = _b[x]
  return scalar seols = _se[x]
  ivregress 2sls y (x=z)
  return scalar biv = _b[x]
  return scalar seiv = _se[x]
end   
simulate bols=r(bols) seols=r(seols) biv=r(biv) seiv=r(seiv), ///
         seed(20230526) reps(1000) nolegend nodots: ///
		 weakivbias, obs(500) pi(0.1)
mean bols seols biv seiv
