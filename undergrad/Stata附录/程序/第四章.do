*-------------------------------------*
*              核密度估计             *
*-------------------------------------*

******** 核密度估计 ********
sysuse citytemp, clear
* 对每个region的1月温度分别进行核密度估计并保存结果
forvalues i=1/4 {
    capture drop x`i' d`i'
     //检查x`i'和d`i'是否已经被定义      
    kdensity tempjan if region== `i', generate(x`i'  d`i')
	 //核密度估计，用x`i'保存格点，d`i'保存格点处的核密度估计
}
gen zero = 0

* 绘制range plot with area shading
graph twoway rarea d1 zero x1, color("blue%20") ///不透明度达到20%
    ||  rarea d2 zero x2, color("green%20")            ///
    ||  rarea d3 zero x3, color("orange%20")           ///
    ||  rarea d4 zero x4, color("red%20")              ///
    title(January Temperatures by Region)              ///
    ytitle("Smoothed density")                         ///
    legend(ring(0) pos(2) col(1) order(2 "NC" 1 "NE" 3 "S" 4 "W"))      
graph export kernel1.pdf, replace
