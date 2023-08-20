use oprobit_demo.dta, clear
global xvars gender edu age thealth familynum trisk  fassetw fdebtw
oprobit happiness index_aggregate $xvars, r nolog
predict p1 p2 p3 p4 p5
list p1 p2 p3 p4 p5 in 1/3
margins, dydx(*)
margins, dydx(*) atmeans
margins, dydx(index_aggregate) at (index_aggregate=115.0246)
