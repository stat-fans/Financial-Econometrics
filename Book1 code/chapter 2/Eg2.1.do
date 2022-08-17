use ~/Fama-French_Data.dta, replace
gen smalllobm_rf = smalllobm - rf 
reg smalllobm_rf mktrf smb hml
gen t = _b[hml]/_se[hml]
gen p = 2*ttail(e(df_r),abs(t)) 
dis p
regsave,tstat pval ci
texsave var coef stderr tstat pval ci_lower ci_upper using "example1.tex",replace
test hml = 0
test hml = 1
