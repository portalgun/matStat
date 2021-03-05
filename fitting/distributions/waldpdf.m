function p = waldpdf(x,mu,lambda)
%function p = waldpdf(x,mu,lambda)
wald=@(z) sqrt(lambda./(2*pi*z.^3)).*exp(-(lambda.*(z-mu).^2)./(2*mu.^2.*z));
p=wald(x);
p(isnan(p))=0;
N=integral(wald,0,inf);
p=p./N;
