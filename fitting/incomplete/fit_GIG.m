function [p,c,l]=fit_GIG(X)
% INCOMPLETE
% function fit_GIG(p,c,l)
% https://link.springer.com/content/pdf/10.1007/s10958-016-3035-3.pdf
    n=sqrt(c./p);
    w=sqrt(p.*c);

    w_hat
end
function p=GIG(p,c,l)
    A=(p./c).^(l./2);
    B= x.^(l-1)./(2.*K.*sqrt(c.*p));
    C=exp(-.5*(c./x+p.*x))
    P=A.*B.*C;
end
function D = D(z,l)
    D=Bessel(z,l+1).*Bessel(z,l-1)./(Bessel(z,l).^2)
end
function R = R(z,l)
    R=Bessel(z,l+1)./Bessel(z,l);
end
function K = Bessel(z,l)
    K_lfun=@(y) exp(-z.*cosh(y)).*cosh(l.*y)
    K=integral(Kfun,0,inf);
end
