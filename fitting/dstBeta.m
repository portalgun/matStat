classdef dstBeta < handle & dstC
methods
    function obj=dstBeta(data,alpha,beta,support)
        obj.toFit=[1,2];
        if exist('alpha','var')  && ~isempty(alpha)
            obj.fix.alpha=alpha;
            obj.rm_fit(1);
        else
            obj.fix.alpha=[];
        end
        if exist('beta','var')  && ~isempty(beta)
            obj.fix.beta=beta;
            obj.rm_fit(2);
        else
            obj.fix.beta=[];
        end
        if exist('data','var')
            obj.data=data;
        end

        obj.type='Beta';
        obj.pdfFun=@(X,alpha,beta) betapdf(X,alpha,beta);
        %obj.fitFun=@(X) fit_beta(X);
        obj.rndFun=@(alpha,beta,sz) betarnd(alpha,beta,sz);
        if exist('support','var')
            obj.support=support;
        else
            obj.support=[0 1];
        end
        obj.params={'alpha','beta'};
    end
    function obj = fit_fun(obj,X)
        out=betafit(X);
        obj.hat.alpha=out(1);
        obj.hat.beta=out(2);
    end
    function obj = fit_fun_old(obj,X)
        a=obj.support(1);
        c=obj.support(2);
        xbar=mean(X(:));
        xbar=(xbar-a)/(c-a);
        vbar=var(X(:));
        vbar=vbar./((c-a)^2);
        if vbar < xbar*(1-xbar)
            obj.hat.alpha=xbar*( ( (xbar*(1-xbar))./vbar ) -1 );
            obj.hat.beta=(1-xbar)*( ( (xbar*(1-xbar))./vbar ) -1 );
        else
            error('fitting code not complete for this type of data')
        end
    end
    function obj = fit_alpha(obj)
    end
end
end
