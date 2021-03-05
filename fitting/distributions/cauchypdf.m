function p = cauchypdf(x,x0,gamma)
%function p = cauchypdf(x,x0,gamma)
cauchy=@(z) 1/(pi*gamma).*(gamma.^2)./((z-x0).^2 + gamma.^2);
N=integral(cauchy,-inf,inf);
p=cauchy(x);
p(isnan(p))=0;
p=p./N;
