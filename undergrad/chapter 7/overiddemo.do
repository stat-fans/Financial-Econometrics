use mus207mepspresdrugs.dta, clear
global controlvar totchr age female blhisp linc
ivregress 2sls ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar
estat overid
ivregress 2sls ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar, r
estat overid
ivregress gmm ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar
estat overid

ivreg2 ldrugexp (hi_empunion = ssiratio lowincome firmsz multlc) $controlvar, r orthog(lowincom firmsz)
