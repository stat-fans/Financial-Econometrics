 insheet using "~/Default.csv", clear
 gen def = 0
 replace def = 1 if default=="Yes"
 logit def balance income, nolog
