suppressWarnings(library(CVXR, warn.conflicts=FALSE))
library(Matrix)
library(tidyverse)

# Set seed for reproducibility
set.seed(20230814)

# Define problem dimensions
n <- 128
K <- 256

# Generate random sparse matrix A
X <- matrix(rnorm(n * K), nrow = n, ncol = K)

# Generate random sparse vector b
beta <- rsparsematrix(K, 1, density = 0.1, rand.x = rnorm)
Y <- X %*% beta
beta_dense <- as.vector(beta)
df <- data.frame(index = 1:K, beta_true = beta_dense)

# Create the plot using ggplot2
ggplot(df, aes(x = index, y = beta_true)) +
  geom_point(color = "blue") +
  labs(title = "",x = "K", y = "beta")

betaHat <- Variable(K)
objective <- Minimize(cvxr_norm(betaHat,2))
constraints <- list(X %*% betaHat == Y)
problem <- Problem(objective, constraints)
solution <- solve(problem)
dfhat <- data.frame(index = 1:K, beta_hat = solution$getValue(betaHat))
ggplot(dfhat, aes(x = index, y = beta_hat)) +
  geom_point(color = "blue") +
  labs(title = "",x = "K", y = "Estimates of beta")
