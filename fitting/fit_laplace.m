function [mu_hat,b_hat] = fit_laplace(X)
%[mu_hat,b_hat] = fit_laplace(X)
mu_hat=mean(X);
b_hat=mean(abs(X-mu_hat));
