library(tidyverse)
set.seed(20230307)
lm <- lapply(
  1:1000,
  function(x) tibble(
    eps = rnorm(10000),
    y = eps,
    for (i in 2:10000){
      y[i] <- y[i-1] + eps[i]
    },
    yreg = y,
    x = c(0,y[1:9999])
  ) %>%
    lm(yreg~-1+x, .)
)

as_tibble(sapply(lm, coef)) %>% 
  ggplot(aes(x=value)) +
  geom_histogram(aes(y = ..density..), 
                 colour="black", fill="white")+ 
  geom_density(alpha = 0.2, fill = "#00AFBB") +
  xlab("beta")