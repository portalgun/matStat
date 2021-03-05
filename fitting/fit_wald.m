function [mu_hat,lambda_hat]=fit_wald(X,w)
%function [mu_hat,lambda_hat]=fit_wald(X,w)
if ~isvar('w')
    w=ones(size(X));
end
% [mu_hatlambda_hat]=fit_wald(X,w)
% AKA inverse gaussian
n=size(X,1);
mu_hat=sum(w.*X,1)./sum(w,1);
invLambda_hat=mean(1./X-1./mu_hat);
lambda_hat=1./invLambda_hat;
