use mus218hk.dta, clear
list mode dbeach dpier dprivate dcharter in 1, clean
gen id = _n
reshape long d p q, i(id) j(fishmode beach pier private charter) string
list id fishmode mode d p q in 1/4, clean
cmset id fishmode
cmclogit d p q, casevars(income) base(beach) nolog vce(robust)
est store m1
cmclogit d p q, nolog nocons vce(robust)
est store m2
margins, dydx(*)
cmclogit d, casevars(income) base(beach) nolog vce(robust)
est store m3
