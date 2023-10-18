use "/Users/xuqiuhua/Documents/BOOK/Econometrics/Bruce E. Hansen/Econometrics Data/CK1994/CK1994.dta", clear
gen emp = empft + 0.5*emppt + nmgrs
gen missing_emp = missing(emp)
bysort store (missing_emp): egen delete_store = max(missing_emp)
drop if delete_store == 1
sum emp if state == 1 & t==0   //state==1代表New Jersey州
gen n10 = r(mean) 
sum emp if state == 1 & t==1   //t==1代表工资调整之后
gen n11 = r(mean) 
sum emp if state == 0 & t==0
gen n00 = r(mean) 
sum emp if state == 0 & t==1
gen n01 = r(mean)
gen delta = (n11 - n10) - (n01 - n00)
dis delta
gen d = state*t
reg emp state t d, cluster(store)

xi: reg emp i.state*i.t, cluster(store)

xtset store t
xtreg emp d i.t, fe cluster(store)
