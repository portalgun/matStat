function obj=dstC_selector(type,data,varargin)
    if ~exist('data','var')
        data=[];
    end
    switch type
        case {'Normal','Norm','norm','normal','gauss','gaussian','Gaussian'}
            obj=dstNorm(data,varargin{:});
        case {'truncNorm','truncatedNormal','truncGauss','truncatedNorm'}
            obj=dstNormTrunc(data,varargin{:});
        case {'Cauchy','cauchy'}
            obj=dstCauchy(data,varargin{:});
        case {'Exp','exp','exponential','Exponential'}
            obj=dstExp(data,varargin{:});
        case {'laplace','Laplace','Laplacian','laplacian'}
            obj=dstLaplace(data,varargin{:});
        case {'wald','Wald','invGauss','invGaussian'}
            obj=dstWald(data,varargin{:});
        case {'beta','Beta'}
            obj=dstBeta(data,varargin{:});
        case {'betaRev','BetaRev'}
            obj=dstBetaRev(data,varargin{:});
        case {'gamma','Gamma','gam'}
            obj=dstGamma(data,varargin{:});
        otherwise
            error('Unhandled distribution!')
    end
end
