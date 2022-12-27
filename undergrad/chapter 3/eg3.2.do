use WAGE1.dta, clear
gen bachelor = 1 if educ >= 16
replace bachelor = 0 if educ < 16
reg wage bachelor
sum wage if bachelor == 1
gen y1 = r(mean)
sum wage if bachelor == 0
gen y0 = r(mean)
dis y1-y0
