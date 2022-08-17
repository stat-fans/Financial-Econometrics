use cps09mar_subset.dta, replace
gen experience = age - education - 6
gen exp2 = experience^2/100
gen lw = log(earnings)
reg lw education experience exp2, vce(hc2)
mat list e(V)
nlcom -50*_b[experience]/_b[exp2]

jackknife (-50*_b[experience]/_b[exp2]), nodots: ///
   reg lw education experience exp2
   
bootstrap (-50*_b[experience]/_b[exp2]), reps(10000) ///
   nodots seed(123): reg lw education experience exp2
   
bootstrap (-50*_b[experience]/_b[exp2]), reps(10000) ///
   nodots seed(19810814): reg lw education experience exp2
