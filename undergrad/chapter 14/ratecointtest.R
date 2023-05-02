mydata <- readxl::read_xlsx("~/BondRate.xlsx")
mydata <- mydata[which(mydata$Y10Rate>0),]
fit <- lm(Y10Rate~Y1Rate,data = mydata)
fUnitRoots::adfTest(residuals(fit),lags = 24,type = "ct")
tseries::po.test(mydata[,2:3])
