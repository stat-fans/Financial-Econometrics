clear all 
set seed 20230104
program define clt   
version 17.0                   
syntax [, obs(integer 1)] 
                                 
clear 
set obs `obs' 
gen e = rnormal()
gen elag = e[_n-1] 
gen data = e*elag             
sum data
end                               

simulate smean=r(mean), reps(2000): clt, obs(1000) 
                            
sum                                  
hist smean, frequency normal xtitle("Sample Mean")
swilk smean     
