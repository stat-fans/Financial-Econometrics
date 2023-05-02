clear all 
set seed 20230126
program define autocorrsim, rclass
version 17.0 
syntax [, obs(integer 1) sigma(real 1) phi(real 1)] 

    clear  
    set obs `obs' 
    gen x = rnormal(0,3)  
	gen e = rnormal(0,`sigma'/sqrt(1+`phi'^2))
	gen elag = e[_n-1]
	gen u2 = e - `phi'*elag
    gen u1  = rnormal(0,`sigma')  
	gen y1  = 3 + 2*x + u1
	gen y2  = 3 + 2*x + u2
    reg y1 x 
	return scalar b1 = _b[x]
	reg y2 x
	return scalar b2 = _b[x]
    end 

simulate beta1=r(b1) beta2=r(b2), reps(2000): autocorrsim, obs(300) sigma(2) phi(2)
sum beta1
gen bias1 = abs(r(mean)-2)
gen sd1 = r(sd)
sum beta2
gen bias2 = abs(r(mean)-2)
gen sd2 = r(sd)
hist beta1,frequency normal xtitle("beta1") name(h1,replace)
hist beta2,frequency normal xtitle("beta2") name(h2,replace)
swilk beta1
swilk beta2


   
