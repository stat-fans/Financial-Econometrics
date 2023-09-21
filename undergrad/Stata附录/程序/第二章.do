*-------------------------------------*
*         数据处理与Stata实现         *
*-------------------------------------*

******** 添加标签 ********
use "stockinfo.dta", clear
* 为数据集添加标签
label data "2011-2019年A股非ST公司主要财务指标"
* 为变量添加标签
label var id "股票代码"
label var year "年份"
label var bm "账面市值比"
label var lev "杠杆率"
label var roa "总资产收益率"
* 为起始年份添加值标签
label define begin_end 2011 "第一年" 2019 "最后一年"
label values year begin_end
describe


******** 删除重复观测 ********
use "stockinfo2.dta", clear
duplicates report             //报告重复观测情况
/*
--------------------------------------
   Copies | Observations       Surplus
----------+---------------------------
        1 |        15181             0
        2 |            4             2
--------------------------------------
*/
duplicates report id year     //报告指定变量的重复观测情况
duplicates list               //显示重复的观测
/*
  +------------------------------------------------+
  | Group   Obs   id   year       bm     lev       roa  |
  |------------------------------------------------|
  |     1    10    6   2011    .8794   .6529   .052165  |
  |     1    11    6   2011    .8794   .6529   .052165  |
  |     2   153   30   2018   1.0404   .3898   .074787  |
  |     2   154   30   2018   1.0404   .3898   .074787  |
  +------------------------------------------------+
 */
duplicates drop               //删除重复的观测
// 或者使用duplicates drop id year, force


******** 处理缺失值 ********
ssc install missings, replace   //安装missings程序包
use "stockinfo3.dta", clear
missings report                  //报告缺失值情况
/*
-----------
     |   #
-----+-----
  bm |   2                         //bm有两个缺失值
 lev |   1                         //lev有一个缺失值
-----------
*/
missings list                    //列出缺失值，第90个和第448个观测的bm缺失
missings dropobs bm, force       //删除缺失值
missings dropobs lev, force
// 或使用 drop if bm==.和 drop if lev==.

ipolate bm year, gen(bm1)        //利用线性插值填补bm的缺失值
list id year bm bm1 in 89/91


******** 数据筛选 ********
use "stockinfo.dta", clear
keep if id>=600000 & id<900000      //选择沪市主板A股公司
keep if id>=1 & id<2000             //选择深市主板A股公司
drop if id>=900000                  //删除上证B股公司
drop if id>=200000 & id<=300000     //删除深圳B股公司
drop if id>=2000 & id<3000          //删除中小板公司
drop if id>300000 & id<=400000      //删除创业板公司 


******** 数据排序 ********
sysuse auto, clear
sort mpg weight, stable
list mpg weight in 1/20
gsort mpg, gen(group)
gsort +mpg -price


******** 系统变量的使用 ********
sysuse auto, clear
generate price2 = price[_n-1]    //生成price的滞后一期变量
regress price mpg foreign rep78
display _b[mpg]                  //显示mpg的回归系数
* -292.43424
webuse dollhill2, clear          //加载Stata网站数据集
by age (smokes), sort: generate wgt=pyears[_N]
// 等价于bysort age (smokes): generate wgt=pyears[_N]


******** 数值型和字符型变量的相互转换 ********
* 将字符型变量转换成数值型变量
clear
input str6 stkcd str9 moutai
    "000010" "600519.SH"
end
destring stkcd, generate(stkcd_num)      //将stkcd转为数值型
* 也可以使用real命令
gen id = real(substr(moutai,1,6))        //substr用来提取字符串的子集
list                                     //id和stkcd_num都为数值型

* 将数值型变量转换为字符型变量
clear 
input stkcd                              //此处的stkcd为数值型
 	10
 	600519
end
tostring stkcd, generate(stkcd_str)
list                                     //stkcd_str为字符型


******** 字符型和数值型变量转换为日期型变量 ********
use "http://www.princeton.edu/~otorres/Stata/date.dta", clear
list in 1/3
/*
     +------------------------------+
     |    date1      date2    date3    |
     |------------------------------|
  1. | 1-Jan-95   1/1/1995   199511    |
  2. | 2-Jan-95   1/2/1995   199512    |
  3. | 3-Jan-95   1/3/1995   199513    |
     +------------------------------+
*/
gen datevar = date(date1,"DMY", 2022)     //DMY：日月年
format datevar %td                        //%td：日度数据
list in 1
/*
     +------------------------------------------+
     |    date1      date2    date3     datevar     |
     |------------------------------------------|
  1. | 1-Jan-95   1/1/1995   199511   01jan1995     |
     +------------------------------------------+
*/
gen datevar2 = date(date2,"MDY", 2022)
format datevar2 %td 
* date3情况比较复杂，Stata无法直接理解199511，可按如下方式处理：
tostring date3, gen(date3a)
gen len = length(date3a)
gen year = substr(date3a,1,4)
gen month = substr(date3a,5,1) if len == 6   //长度为6时第5位是月份
gen day = substr(date3a,6,1) if len == 6        //长度为6时第6位是日
replace month = substr(date3a,5,2) if len == 8 
replace day = substr(date3a,7,2) if len == 8
destring month day year, replace
gen datevar3 = mdy(month,day,year)              //利用mdy生成日期变量
format datevar3 %td
replace datevar3 = datevar3[_n-1] + 1 if datevar3 == .
format datevar3 %tdCY-N-D                       //输出格式为1995-01-01

* 季度数据转换
use tsdata.dta, clear
// 数据来源：http://dss.princeton.edu/training/tsdata.dta 
gen date1=substr(date,1,7) 
gen datevar=quarterly(date1,"YQ")
format datevar %tq 


******** 长宽格式数据转换 ********
use "stockinfo.dta", clear
reshape wide bm lev roa, i(id) j(year)        //长格式转宽格式
reshape long bm lev roa, i(id) j(year)        //宽格式转长格式


******** 新变量创建和排序 ********
use "stockinfo.dta", clear
egen maxbm = max(bm), by(id)    //生成变量maxbm，取值为相同id中bm的最大值
order maxbm roa, after(bm)      //将maxbm和roa移到bm后


******** 生成随机数 ********
clear 
set obs 1000                  //设置样本量
set seed 202208               //设置随机种子
gen u1 = runiform()           //生成(0,1)区间上的均匀分布随机数
gen u2 = runiform(-1,1)       //生成(-1,1)区间上的均匀分布随机数
gen n1 = rnormal()            //生成服从标准正态分布的随机数
gen n2 = rnormal(0,2)         //生成期望为0标准差为2的正态分布随机数
gen c1 = rchi2(2)             //生成自由度为2的卡方分布随机数
gen t1 = rt(2)                //生成自由度为2的t分布随机数


******** 字符型变量的处理 ********
use "stockinfo.dta", clear
tostring id, gen(idstr)
replace idstr="0"*(6-length(idstr)) + idstr  
// 字符连接，对不足6位的idstr前面用0补齐至6位

tostring year, gen(yearstr)
gen year2 = substr(yearstr,3,2)         //提取年份数据的后两位

gen searchid = 1 if regexm(idstr, "002")
replace searchid = 0 if searchid == .
// 生成新变量searchid，股票代码里含有002时取1，否则取0

gen searchSH = 1 if regexm(idstr, "^6")
replace searchSH = 0 if searchSH == .
// 生成新变量searchSH，股票代码以6开始时取1，否则取0


******** 字符型变量的处理 ********
clear 
input str30 x
  "Programming&STATA 202208"
  "Financial Econometrics"
end
list

* 匹配：匹配变量中的"STATA"，匹配成功返回1，否则返回0
gen j1 = ustrregexm(x, "STATA")  

* 匹配变量中的"STATA"并提取，0表示提取满足条件的整个字符串
gen j2 = ustrregexs(0) if ustrregexm(x, "STATA")  

* 替换：寻找"STATA"中的任何一个元素，如果有就替换为"R"
gen j3 = ustrregexra(x, "[STATA]", "R") 

* 替换：将非"STATA"中的字符替换为空，最后只留下"STATA"
gen j4 = ustrregexra(x, "[^STATA]", "") 

* 字符串函数
gen t1 = strupper(x)          //将所有字母转换成大写
gen t2 = strlower(x)          //将所有字母转换成小写
gen t3 = strproper(x)         //将指定位置的字母大写
gen len = strlen(x)           //计算字符长度
gen count = wordcount(x)      //统计由空格隔开的词数量

* 分割
split x, parse(" ") gen(test) 
//将x中的字符串按照空格分割，并生成命名方式为test#的新变量，#代表1，2，...
list

* 字符搜索
capture drop t*               //删除以t开头的变量                  

* 提取字符串中的第一个单词   
gen t1 = ustrregexs(0) if ustrregexm(x, "\w+") 


******** 因子变量的使用 ********
sysuse nlsw88, clear      
des race               //查看race值标签名称，为racelbl
label list racelbl     //显示race值标签的赋值方式，black为2
gen black = 2.race     //生成black虚拟变量，黑人为1，否则为0
gen lwage = log(wage)
reg lwage black

* 加入种族race和职业类别occupation的交乘项
reg lwage i.race#i.occupation
* 除了交乘项之外也放入主项
reg lwage i.race##i.occupation
* 加入种族race和当前职业的工作年数tenure的交乘项
reg lwage i.race#c.tenure    
* 加入年龄age及其平方项
reg lwage c.age##c.age


******** 面板数据的固定效应 ********
use "stockltd.dta", clear
* 加入公司、年度固定效应
reg ltd bm lev i.id i.year
//或使用xtreg命令：
xtset id year         //设置面板数据的个体和时间变量
xtreg ltd bm lev i.year, fe
* 加入行业、年度固定效应
reg ltd bm lev i.indu i.year


******** 数据分组 ********
use "stockltd.dta", clear
bysort id (year): gen growth=(bm-bm[_n-1])/bm[_n-1]

// 分年度按roa升序将公司分组，使每组的公司数为20
bysort year: egen roarank = rank(roa)
gen group20 = int((roarank-1)/20) + 1

// 分组进行计算
* 计算不同代码股票ltd的累积和
bysort id: gen rsum=sum(ltd)
* 计算不同代码股票ltd的累积乘积
bysort id: gen rprod = exp(sum(ln(ltd)))

* 将2011年的所有公司按roa升序分为20组
egen rankroa = cut(roa) if year==2011, group(20)    
tab rankroa                          //统计每组公司个数、占比和累积和
                  
* 分年度将所有公司按roa升序分为20组
gen rankroa1 = .
forvalues i=2011/2019{
	 egen temp = cut(roa) if year==`i' & roa!=., group(20)
    replace rankroa1 = temp if year==`i' & roa!=.
	 drop temp
}
replace rankroa1 = (rankroa1+1)      //使第一组组号为1而不是0

* 生成虚拟变量mroa，当roa大于或等于其中位数时，mroa为1，否则为0
ssc install todummy, replace
todummy roa, median gen(mroa)


******** 数据横向合并 ********
use "stockltd.dta", clear
preserve                      //保存原始数据
keep id year bm lev
save d1.dta, replace          //第一份数据，包括id、year、bm和lev
restore                       //恢复原始数据
keep id year roa ltd
save d2.dta, replace          //第二份数据，包括连续变量roa和ltd

use "d1.dta", clear
* 从数据集d2.dta中合并roa数据
merge 1:1 id year using d2.dta, keepusing(roa)    
keep if _merge == 3           //保留匹配成功的数据
drop _merge                   //将创建的新变量_merge删除

* 从数据集indu.dta中合并行业类别，多对一匹配
merge m:1 id using indu.dta   
keep if _merge == 3
drop _merge
list in 1/3, clean noobs      //无分割线，无观测值序号


******** 数据纵向合并 ********
use "stockltd.dta", clear
preserve
keep if _n <=5
keep id year bm lev
save d3.dta, replace 
restore

keep if _n >=5 & _n <=10
keep id year bm lev
save d4.dta, replace 

use d3.dta, clear
append using d4.dta           //纵向合并
list, clean noobs


******** 数据模糊匹配 ********
ssc install reclink, replace
clear
input str13 name str14 city
	"Han meimei"  "Shanghai"
	"Li Lei"      "Chengdu"
	"Zhang, san"  "Beijing"
	"Si, Li"      "Shenzhen"
end
gen id1=_n
save name1.dta, replace
 
clear 
input str14 name str10 city
	"Han, meim"   "shaanghai"
	"LI lei"      "chengdou"
	"zhangSan"    "beijiang"
	"Li si"       "shezhen"
end
gen id2=_n
save name2.dta, replace

* 模糊匹配
use name1.dta, clear
reclink name city using name2.dta, idmaster(id1) idusing(id2) gen(matchscore)
list, clean noobs


******** 命令joinby的使用 ********
clear
input group str3 x1
	1  "A"
	1  "B"
	1  "C"
	1  "D"
end
save d5.dta, replace

clear
input group str3 x2
	1  "M"
	1  "M"
end
save d6.dta, replace

use d5.dta, clear
joinby group using d6.dta
list, clean noobs

































