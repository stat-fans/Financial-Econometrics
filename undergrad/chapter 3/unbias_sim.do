clear all 
set seed 20221227
program define ulrm, rclass 
version 17.0 
syntax [, obs(integer 1) mu(real 0) sigma(real 1)] 

    clear  
    set obs `obs' 
    gen x = rnormal(0,3)  
    gen u  = rnormal(`mu',`sigma')  
    gen y  = 3 + 2*x + u 
    reg y x 
    end 

simulate beta=_b[x], reps(1000): ulrm, obs(100) mu(0) sigma(1)
sum
hist beta
