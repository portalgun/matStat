function [mu_hat,sigma_hat]=fit_norm(X)
%function [mu_hat,sigma_hat]=fit_norm(X)
mu_hat=mean(X);
sigma_hat=sqrt(mean((X-mu_hat).^2));
