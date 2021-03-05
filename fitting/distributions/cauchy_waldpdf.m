wald=@(z) sqrt(lambda./(2*pi*z.^3)).*exp(-(lambda.*(z-mu).^2)./(2*mu.^2.*z));
cauchy=@(z) 1/(pi*gamma).*(gamma.^2)./((z-x0).^2 + gamma.^2);
N=integral(cauchy,-inf,inf);

p(isnan(p))=0;
p=p./N;
