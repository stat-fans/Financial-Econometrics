#数据预处理
library(tidyverse)
cps09mar_subset <- haven::read_dta("~/cps09mar_subset.dta")
reg_data <- cps09mar_subset %>% 
  dplyr::mutate(experience=age-education-6,lw=log(earnings)) %>%
  dplyr::mutate(exp2=experience^2/100) %>%
  dplyr::select(c(lw,education,experience,exp2))

#截尾Bootstrap函数
"trimBootstrap" <- function(sample_data, tau=20, nter=1000){
  #sample_data: 原始样本数据集
  #tau: trimming number 
  #nter: B
  fit <- lm(lw~education+experience+exp2,data=sample_data)
  beta2 <- coefficients(fit)["experience"]
  beta3 <- coefficients(fit)["exp2"]
  hat_theta <- as.numeric(-50*beta2/beta3)
  n <- dim(sample_data)[1]
  theta_star=NULL
  for (b in 1:nter){
    index <- sample(n,replace = TRUE)
    current_data <- sample_data[index,]
    current_fit <- lm(lw~education+experience+exp2,data=current_data)
    current_beta2 <- coefficients(current_fit)["experience"]
    current_beta3 <- coefficients(current_fit)["exp2"]
    theta_star = c(theta_star, as.numeric(-50*current_beta2/current_beta3))
  }
  z_star = sqrt(n)*(theta_star - hat_theta)
  z_star2 = z_star*(abs(z_star) <= tau)
  trimmed_boot_var = var(z_star2)
  boot_sd = sqrt(trimmed_boot_var/n)
  trimBootstrap <- list(bootvalue=z_star2,trimmed_sd=boot_sd)
}

sd <- trimBootstrap(reg_data, tau=535, nter=10000)$trimmed_sd
