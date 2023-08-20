use mus207mepspresdrugs.dta, clear
global controlvar totchr age female blhisp linc
capture program drop hausmantest
program define hausmantest, eclass
version 17.0
   tempname b bols biv
   reg ldrugexp hi_empunion $controlvar, r
   matrix `bols' = e(b)
   ivregress 2sls ldrugexp (hi_empunion = ssiratio multlc) $controlvar, r
   matrix `biv' = e(b)
   matrix `b' = `biv'-`bols'
   ereturn post `b'
end
bootstrap _b, reps(500) seed(202306) nodots: hausmantest
test hi_empunion
test hi_empunion $controlvar _cons
