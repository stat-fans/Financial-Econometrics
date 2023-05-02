clear all 
set seed 20230316
program define ovbdemo, rclass   
version 17.0                   
syntax [, obs(integer 1)] 
                                 
   clear 
   set obs `obs'
   gen e1 = rnormal(0,1)
   gen e2 = rnormal(0,1.5)
   gen x1 = e1 + 0.4 * e2 
   gen x2 = e1 + rnormal(0,3) 
   gen x3 = rnormal(0,2) 
   gen x4 = 0.3 * e2 + rnormal(0,1) 
   gen u  = rnormal(0,2)    
   gen y  = 3 + 2 * x1 + 4 * x2 + x3 + 5 * x4 + u 
   reg y x1 x2 x3 
   return scalar b1 = _b[x1]
   return scalar b2 = _b[x2]
   return scalar b3 = _b[x3]
  end                             

simulate beta1=r(b1) beta2 = r(b2) beta3=r(b3), reps(1000): ovbdemo, obs(1000)
                                       
sum                                  
                           
