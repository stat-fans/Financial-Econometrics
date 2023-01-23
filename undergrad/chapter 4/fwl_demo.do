sysuse nlsw88, replace
reg wage hours age tenure
gen b1 = _b[tenure]
reg wage hours age
predict ey, res
reg tenure hours age
predict e, res
reg ey e, noc
dis _b[e] - b1
reganat wage hours age tenure,disp(tenure)

