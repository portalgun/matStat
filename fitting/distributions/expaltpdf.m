function p = expaltpdf(x,beta)
%function p = expaltpdf(x,beta)
expalt = @(z) 1/beta.*exp(-z./beta);
N=integral(expalt,0,inf);
p=expalt(x);
p(isnan(p))=0;
p=p./N;
