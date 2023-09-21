*-------------------------------------*
*           Stata基础知识             *
*-------------------------------------*

******** Stata 的命令格式 *******
sysuse auto, clear //读取数据
summarize //输出所有变量的描述统计
summarize mpg price, separator(1) //输出mpg和price的描述统计
//选项separator(1)表示每个变量的结果用直线分割


******** Stata 命令结果的调用 *******
sysuse auto, replace
sum mpg
return list
dis r(mean) //dis为display的缩写

sysuse auto, replace
reg mpg price weight //reg为regress的缩写，mpg为因变量，其余为自变量
ereturn list
dis e(r2) //显示回归的拟合优度


******** 定义宏并显示宏指代的内容 ********
local a I love Stata //定义局部宏a，指代字符串 I love Stata
display "`a'" //输出 I love Stata
global b I love Stata //定义全局宏b，指代字符串 I love Stata
display "$b" //输出 I love Stata
local c = 2+2 //定义局部宏c，指代表达式 2+2 的计算结果
local d 2+2 //定义局部宏d，指代字符串2+2
local e: word count I love Stata
/*定义局部宏e，指代拓展函数word count string的返回值*/
display "`e'" //输出3
local f: word 1 of I love Stata
/*定义局部宏f，指代拓展函数word # of string的返回值*/


******** 用宏指代重复的命令片段 ********
sysuse nlsw88, replace //使用Stata系统自带的数据集nlsw88
reg wage hours age tenure
gen lnwage = log(wage) //生成新的变量lnwage
reg lnwage hours age tenure //线性回归，因变量是lnwage，自变量不变

/*由于两个回归方程中自变量没有发生变化，可使用宏来简化命令*/
local x hours age tenure
/*定义局部宏，宏的名称为x，指代变量为hours age tenure*/
reg wage `x'
reg lnwage `x'

local option beta vce(robust) noheader
reg wage `x',`option'
reg lnwage `x', `option'

local x hours age ttl_exp //将自变量tenure修改为ttl_exp
reg wage `x'
reg lnwage `x'


******** 条件函数 ********
sysuse auto, clear //读取数据集auto
gen bad1 = cond(rep78>=4,1,0) //生成新变量bad1，当rep78>=4时取值为1
replace bad1=. if rep78==. //rep78缺失时，bad1也缺失
list rep78 bad1 in 1/20 //列出rep78和bad1的前20个元素

* 第3-4行命令效果等价于：
gen bad2 = (rep78>=4) if rep78 !=.
* 或者，等价于：
gen bad2 = cond(missing(rep78),.,cond(rep78>=4,1,0))

gen bad3 = inrange(rep78, 1, 3) //生成bad3，当rep78属于[1,3]时取值为1
list rep78 bad3 in 1/20

* 生成bad4，当rep78的取值为1、2和4三者之一时bad4取值为1
gen bad4 = inlist(rep78, 1, 2, 4)
list rep78 bad4 in 1/20

* 生成bad5，将rep78的非缺失值截取在[1.5, 3.5]范围内
gen bad5 = clip(rep78, 1.5, 3.5)
list rep78 bad5 in 1/20

* 通常可以使用 drop if x==. 来删除x中的缺失值
* 使用missing可以批量删除多个变量的缺失值
drop if missing(rep78, mpg, weight)

******** 循环语句 ********
* 为新变量贴标签
sysuse auto, clear
drop if rep78==.
tab(rep78), gen(worse)
label define rep_status 0 "否" 1 "是" //定义值标签
forvalues i = 1/5{
label var worse`i' "第`i'次维修" //`i'表示调用局部宏
label val worse`i' rep_status //对变量添加值标签
}
describe

* 使用while
local i=1
while `i'<= 5{
label var worse`i' "第`i'次维修"
label val worse`i' rep_status
local ++i
}

* 对变量 weight length price 进行标准化处理
foreach var in weight length price{
qui sum `var' //qui用来隐藏输出结果
gen std_`var' = (`var' - r(mean)) / r(sd) //`var'是局部宏
}


 ******** 数据读入 ********
cd "~/Stata Data Code" //设置当前工作路径
* 读入扩展名为.xlsx的数据集
import excel "stockinfo.xlsx", sheet("Sheet1") firstrow clear
* 读入扩展名为.csv的数据集
insheet using "stockinfo.csv", clear
* 读入扩展名为.txt的数据集
infile str6 id str4 year bm lev roa using "stockinfo.txt", clear
* 读入扩展名为.dta的数据集
use "stockinfo.dta", clear


******** 数据录入 ********
input str20 name age female income
    "张三" 25 0 2500
    "李四" 32 1 4500
end

























