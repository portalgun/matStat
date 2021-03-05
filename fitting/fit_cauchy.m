function [x0_hat,gamma_hat]= fit_cauchy(X)
%function [x0_hat,gamma_hat]= fit_cauchy(X)
syms x0 g;
fun1=sum((X-x0)./(g.^2+(X-x0).^2)) == 0;
fun2=sum((g.^2)./(g.^2+(X-x0).^2))-length(X)./2 == 0;
sol=solve([fun1,fun2],[x0 g]);
x0_hat=sol.x0;
gamma_hat=sol.g;
