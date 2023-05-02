use JTRAIN_CPS1.dta, clear
global xvars age agesq educ educsq marr nodegree ///
          black hisp re74 re74sq re75 u74 u75 u74hisp
gen d = treat     
gen y = re78 

pscore d $xvars, pscore(myscore) comsup /// 
        blockid(myblock) level(0.005) logit
		
set seed 20230426
attnd y d, pscore(myscore) comsup bootstrap reps(100)

atts y d, pscore(myscore) blockid(myblock) comsup bootstrap reps(100)


psmatch2 d, out(y) pscore(myscore) n(3) common
pstest myscore, both
pstest $xvars, both




