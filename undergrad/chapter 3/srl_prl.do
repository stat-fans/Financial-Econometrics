set seed 20221224 
clear 
set obs 100
gen x = rnormal() 
gen u  = rnormal(0,10) 
gen y  = 2 + 5*x + u 
reg y x 
dis _b[_cons], _b[x]
twoway (function PRL=2+5*x,range(-3 3) lcolor(black)) (lfit y x, lcolor(blue) lwidth(medium) lpattern(dash))  (scatter y x, mcolor(blue) msize(tiny)), title(PRL and SRL)
