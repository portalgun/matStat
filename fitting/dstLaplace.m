classdef dstLaplace < handle & dstC
methods
    function obj=dstLaplace(data,mu,b)
        obj.data=data;
        obj.type='Laplace';
        obj.pdfFun=@(X,mu,b) laplacepdf(X,mu,b);
        obj.fitFun=@(X) fit_laplace(X);
        obj.rndFun=@(mu,b,sz) laprnd(sz(1),sz(2),mu,b);
        obj.support=[-inf,inf];
        obj.params={'mu','b'};
    end
    function obj=fit_fun(obj,X)
        if isempty(X)
            X=obj.data;
        end

        if ~isvar('toFit') || isequal(toFit,[1 2])
            obj.fit_mu(X);
            obj.fit_b(X);
        elseif toFit==1
            obj.fit_mu(X);
        elseif toFit==2
            obj.fit_b(X);
        end

    end
    function obj=fit_mu(obj,X)
        obj.hat.mu=mean(X);
    end
    function obj=fit_b(obj,X)
        obj.hat.b=mean(abs(X-obj.hat.mu));
    end
end
end
