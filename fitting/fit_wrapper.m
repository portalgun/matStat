function [p,P,G,Chi2]=fit_wrapper(type,X,bins,bSkipPdf)
if ~isvar('bSkipPdf')
    bSkipPdf=0;
end
%function [p,G,Chi2]=fit_wrapper(type,X,xo,xe,bins)

switch type
    case 'norm'
        [P.muHat,P.sigmaHat]=fit_norm(X);
        if ~bSkipPdf
            p=normpdf(bins,P.muHat,P.sigmaHat);
            pe=normpdf(X,P.muHat,P.sigmaHat);
        end
    case 'wald'
        [P.muHat,P.lambdaHat]=fit_wald(X);
        if ~bSkipPdf
            p=waldpdf(bins,P.muHat,P.lambdaHat);
            pe=waldpdf(X,P.muHat,P.lambdaHat);
        end
    case 'laplace'
        [P.muHat,P.bHat]=fit_laplace(X);
        if ~bSkipPdf
            p=laplacepdf(bins,P.muHat,P.bHat);
            pe=laplacepdf(X,P.muHat,P.bHat);
        end
    case 'cauchy'
        %[x0Hat,gammaHat]=fit_cauchy(X);
        params=cauchyfit(X);
        P.x0Hat=params(1);
        P.gammaHat=params(2);
        if ~bSkipPdf
            p=cauchypdf(bins,P.x0Hat,P.gammaHat);
            pe=cauchypdf(X,P.x0Hat,P.gammaHat);
        end
    case 'exp'
        [P.lambdaHat]=fit_expalt(X);
        if ~bSkipPdf
            p=expaltpdf(bins,P.lambdaHat);
            pe=exppdf(X,P.lambdaHat);
        end
    otherwise
        error(['Distribution ' type ' not defined.'])
end
if bSkipPdf
    G=[];
    Chi2=[];
else
    G=2*sum(X.*log(X./pe));
    Chi2=sum((X-pe).^2./pe);
end
