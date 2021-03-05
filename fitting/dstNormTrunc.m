classdef dstNormTrunc < handle & dstC
methods
    function obj=dstNormTrunc(data,mu,sigma)
        obj.toFit=[1,2];
        if exist('mu','var')  && ~isempty(mu)
            obj.fix.mu=mu;
            obj.rm_fit(1);
        else
            obj.fix.mu=[];
        end
        if exist('sigma','var')  && ~isempty(sigma)
            obj.fix.sigma=sigma;
            obj.rm_fit(2);
        else
            obj.fix.sigma=[];
        end

        obj.data=data;
        obj.type='Normal';
        obj.pdfFun=@(X,mu,sigma) normpdf(X,mu,sigma);
        obj.fitFun=@(X) fitdist_ntrunc(X);
        obj.rndFun=@(mu,sigma,sz) normrnd(mu,sigma,sz);
        obj.support=[-inf,inf];
        obj.params={'mu','sigma'};
    end
    function obj=fit_fun(obj,X)
        if isempty(X)
            X=obj.data;
        end

        if isequal(obj.toFit,[1 2])
            obj.fit_mu(X);
            obj.fit_sigma(X);
        elseif obj.toFit==1
            obj.fit_mu(X);
        elseif obj.toFit==2
            obj.fit_sigma(X);
        end
    end
    function fit_mu(obj,X)
        obj.hat.mu=mean(X);
    end
    function obj=fit_sigma(obj,X)
        obj.hat.sigma=sqrt(mean((X-obj.hat.mu).^2));
    end
end
end
