import delimited "/Users/xuqiuhua/default.csv", varnames(1) clear
capture program drop mylogit 
program mylogit
version 17.0
args lnf Xbeta
quietly replace `lnf' = -ln(1+exp(-`Xbeta')) if $ML_y1==1
quietly replace `lnf' = -`Xbeta' - ln(1+exp(-`Xbeta')) if $ML_y1==0
end
gen default_n = 1 if default == "Yes"
replace default_n = 0 if default == "No"
ml model lf mylogit (default_n = balance income)
ml maximize


 
