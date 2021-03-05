classdef dstCauchy < handle & dstC
methods
    function obj=dstCauchy(data,x0,gamma)
        obj.data=data;
        obj.type='Cauchy';
        obj.pdfFun=@(X,x0,gamma) cauchypdf(X,x0,gamma);
        obj.cdfFun=@(X,x0,gamma) cauchycdf(X,x0,gamga);
        obj.rndFun=@(x0,gamma,sz) cauchyrnd(x0,gamma,sz);
        obj.support=[-inf,inf];
        obj.params={'x0','gamma'};
    end
    function obj = fit_fun(obj,X,toFit)
        if isempty(X)
            X=obj.data;
        end

        if (~exist('toFit','var') || isempty(toFit)) || isequal(toFit,[1 2])
            x0=NaN;
            gamma=NaN;
        elseif toFit==1
            x0=NaN;
            gamma=obj.hat.gamma;
        elseif toFit==2
            x0=obj.hat.x0;
            gamma=NaN;
        end
        out=cauchyfit(X,[x0 gamma]); % XXX
        obj.hat.x0=out(1);
        obj.hat.gamma=out(2);
    end
    function obj = fit_x0_g_hard(obj,X)
    % USE OTHER
        syms x0 g;
        fun1=sum((X-x0)./(g.^2+(X-x0).^2)) == 0;
        fun2=sum((g.^2)./(g.^2+(X-x0).^2))-length(X)./2 == 0;
        sol=solve([fun1,fun2],[x0 g]);
        obj.hat.x0=sol.x0;
        obj.hat.gamma=sol.g;
    end
end
end
