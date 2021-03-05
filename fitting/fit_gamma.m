function [alpha,beta]=fit_gamma(X)
    phat=gamfit(X);
    alpha=phat(1);
    beta=phat(2);
end
