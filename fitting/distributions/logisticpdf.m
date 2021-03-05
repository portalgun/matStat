function p = logisticpdf(mu,s)
%function p = logisticpdf(mu,s)
logist=@(z) 1/4s * sech((z-mu)./(2*s)).^2;
N=integral(logist,-inf,inf);
p=logist(x);
p(isnan(p))=0;
p=p./N;
