use maketable5, clear
keep if baseco==1  //使用base sample
global controlvar lat_abst f_brit f_french
qui ivregress 2sls logpgp95 (avexpr=logem4) $controlvar
estat firststage, all
qui ivregress 2sls logpgp95 (avexpr=logem4) $controlvar, r
estat firststage, all forcenonrobust
weakivtest
