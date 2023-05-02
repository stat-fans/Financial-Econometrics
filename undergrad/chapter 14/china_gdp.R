mydata <- readxl::read_xlsx("~/Desktop/y-GDP-POP.xlsx")
library(xts)
gdp <- xts(as.numeric(mydata$GDP),mydata$年份)/10000
gdp <- gdp["1980/"]
plot(gdp,main = "GDP of China")
