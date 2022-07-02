use DDK2011.dta, replace
egen testscore = std(totalscore)
summclust tracking, yvar(testscore) xvar(girl agetest) cluster(schoolid)
reg testscore tracking girl agetest, cluster(schoolid) vce(jackknife,nodots)
jackknife, cluster(schoolid) nodots: reg testscore tracking girl agetest 

//Bootstrap se
reg testscore tracking girl agetest, vce(bootstrap, reps(500))
bootstrap, reps(500): reg testscore tracking girl agetest

//Bootstrap ci
estat bootstrap, percentile
estat bootstrap, all

//BC ci
estat bootstrap

//BCa ci
reg testscore tracking girl agetest, vce(bootstrap, reps(500) bca seed(123))
estat bootstrap, all
estat bootstrap, bca

bootstrap, reps(500) bca seed(123): reg testscore tracking girl agetest
estat bootstrap, bca
