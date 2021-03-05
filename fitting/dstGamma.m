classdef dstGamma < handle & dstC
methods
    function obj = dstGamma(data,alpha,beta)
        obj.toFit=[1,2];
        if exist('alpha','var')  && ~isempty(alpha)
            obj.fix.alpha=alpha;
            obj.rm_fit(1);
        else
            obj.fix.alpha=[];
        end
        if exist('beta','var')  && ~isemptpy(beta)
            obj.fix.beta=beta;
            obj.rm_fit(2);
        else
            obj.fix.sigma=[];
        end

        obj.data=data;
        obj.type='Gamma';
        obj.pdfFun=@(X,alpha,beta) gampdf(X,alpha,beta);
        obj.fitFun=@(X) fit_gamma(X);
        obj.rndFun=@(alpha,beta,sz) gamrnd(alpha,beta,sz);
        obj.support=[0,inf];
        obj.params={'alpha','beta'};
    end
    function obj=fit_fun(obj,X)
        if isempty(X)
            X=obj.data;
        end

        if isequal(obj.toFit,[1 2]) || obj.toFit==1
            phat=gamfit(X);
            obj.hat.alpha=phat(1);
            obj.hat.beta=phat(2);
        elseif obj.toFit==2
            phat=gamfit(X,obj.fix.alpha);
            obj.hat.beta=phat(2);
        end
    end
end
end
