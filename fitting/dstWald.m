classdef dstWald  < handle & dstC
% AKA inverse gaussian
properties
    w
end
methods
    function obj=dstWald(data,mu,lambda,w)
        if isempty(obj.w)
            obj.w=ones(size(data));
        end

        obj.toFit=[1,2];
        if exist('mu','var')  && ~isempty(mu)
            obj.fix.mu=mu;
            obj.rm_fit(1);
        else
            obj.fix.mu=[];
        end
        if exist('sigma','var')  && ~isemptpy(lambda)
            obj.fix.lambda=lambda;
            obj.rm_fit(2);
        else
            obj.fix.lambda=[];
        end

        obj.data=data;
        obj.type='Wald';
        obj.pdfFun=@(X,mu,lambda) waldpdf(X,mu,lambda);
        obj.rndFun=@(mu,lambda,sz) obj.waldrand(mu,lambda,sz);
        obj.support=[0,inf];
        obj.params={'mu','lambda'};
    end
    function obj=fit_fun(obj,X)
        if isempty(X)
            X=obj.data;
        end

        if ~isvar('toFit') || isequal(toFit,[1 2])
            obj.fit_mu(X);
            obj.fit_lambda(X);
        elseif toFit==1
            obj.fit_mu(X);
        elseif toFit==2
            obj.fit_lambda(X);
        end
    end
    function out=waldrand(obj,mu,lambda,sz)
        [mu lambda]
        out=random('InverseGaussian',mu,lambda,sz);
    end
    function obj=fit_mu(obj,X)
        obj.hat.mu=sum(obj.w.*X,1)./sum(obj.w,1);
    end
    function obj=fit_lambda(obj,X)
        invLambda_hat=mean(1./X-1./obj.hat.mu);
        obj.hat.lambda=1./invLambda_hat;
    end
end
end
