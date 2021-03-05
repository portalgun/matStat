classdef dstExp < handle & dstC
methods
    function obj = dstExp(data,beta)
        obj.data=data;
        obj.pdfFun=@(X,beta) expaltpdf(X,beta);
        obj.fitFun=@(X) fit_expalt(X);
        obj.rndFun=@(beta,sz) ernd(beta,sz);
        obj.support=[0,inf];
        obj.params={'beta'}
    end
    function beta_hat=fit_fun(obj,X)
        if isempty(X)
            X=obj.data;
        end
        obj.hat.beta=mean(X);
    end
end
end
