function p=cumlogisticpdf(mu,s)
logist=@(z) .5+.5*tanh((x-mu)/(2*s));
N=integral(logist,-inf,inf);
p=logist(x);
p(isnan(p))=0;
p=p./N;
