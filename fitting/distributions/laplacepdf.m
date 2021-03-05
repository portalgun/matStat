function p = laplacepdf(x,mu,b)
%p = laplacepdf(x,mu,b)
laplace = @(z) 1/(2*b).*exp(-abs(z-mu)/b);
N=integral(laplace,-inf,inf);
p=laplace(x);
p(isnan(p))=0;
p=p./N;
