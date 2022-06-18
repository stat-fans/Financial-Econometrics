use DDK2011.dta, replace
egen testscore = std(totalscore)
summclust tracking, yvar(testscore) xvar(girl agetest) cluster(schoolid)
reg testscore tracking girl agetest, cluster(schoolid) vce(jackknife,nodots)
jackknife, cluster(schoolid) nodots: reg testscore tracking girl agetest 
