use mus207mepspresdrugs.dta, clear
global controlvar totchr age female blhisp linc
reg ldrugexp ssiratio multlc $controlvar, r
test ssiratio multlc

gen ytrans = ldrugexp - (-0.8)*hi_empunion
reg ytrans ssiratio multlc $controlvar, r
test ssiratio multlc

condivreg ldrugexp (hi_empunion = ssiratio multlc) $controlvar, 2sls ar test(0)
condivreg ldrugexp (hi_empunion = ssiratio multlc) $controlvar, 2sls ar test(-0.8)
