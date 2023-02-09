mydata <- readxl::read_xlsx("~/q-GDP-UKCAUS.xlsx")
logdata <- log(mydata[,2:4])
gr_all <- logdata[2:dim(logdata)[1],]-logdata[1:(dim(logdata)[1]-1),]
gr_all <- gr_all*100
MTS::mq(gr_all,20)
MTS::VARorder(gr_all)
#MTS::ccm(gr_all)
m1 <- MTS::VAR(gr_all,p=1)
MTS::mq(m1$residuals,adj = 9)
#Causality Analysis
est <- vars::VAR(gr_all, lag.max =3, ic="SC")
vars::causality(est,cause = "USA")
vars::causality(est,cause = "CANADA")
vars::causality(est,cause = "UK")
#Impulse Response Functions
plot(vars::irf(est))
MTS::VARMAirf(Phi = m1$Phi, Sigma = m1$Sigma, lag = 12, orth = TRUE)
#Prediction
MTS::VARpred(m1,8)
#Forecast error variance decomposition
m2 = MTS::refVAR(m1)
MTS::FEVdec(m2$Phi,NULL,m2$Sig,lag=5)
