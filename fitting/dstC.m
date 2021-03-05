classdef dstC < handle
% d=dstBets(data)
% d.get_fit();
% d.get_fit();
% d.plot_fit();
%{
Distributions
    beta
    logit-normal
    uniform
    chi
    chi2
    gamma | part numeric
    gen gamma
    pareto
    log normal | easy
    gen normal | numeric
    logistic | numeric
    students t distribution
    gig | numeric
    logistcdf
entropy
mgf
%}
properties
    fix
    params
    hat  %fit
    boot %fit_boot
    toFit

    figdata
    figfit
    figpdf
    data
    type
    pdfFun
    cdfFun
    rndFun
    fitFun
    support
    pdf

    gof
    x
end
properties(Hidden)
    fig
    theta
end
methods
    function rn = rnd(obj,sz)
        if ~isvar('sz')
            sz=1;
        end
        obj.hat2theta();
        rn=sort(obj.rndFun(obj.theta{:},sz));
    end
    function obj=hat2theta(obj)
        n= length(obj.params);
        obj.theta=cell(n,1);
        for i = 1:n
            p=obj.params{i};
            obj.theta{i}=obj.hat.(p);
        end
    end
    function obj = gen_data(obj,num)
        if ~isvar('sz')
            sz=[1000,1];
        end
        sigma=3;
        noise=rand(sz)*sigma;
        obj.data = obj.rnd([num,1])+noise;
    end

    function obj = get_fit(obj,data)
        if isvar('data')
            obj.data=data;
        elseif isempty(obj.data)
            obj.get_data;
        end
        if isprop(obj,'dataAlt') && ~isempty(obj.dataAlt)
            obj.fit_fun(obj.dataAlt);
        else
            obj.fit_fun(obj.data);
        end
    end
    function obj = get_pdf(obj,x)
        obj.hat2theta();
        if isempty(obj.hat)
            obj.get_fit();
        end
        if ~isvar('x') && isempty(obj.x)
            obj.x=linspace(obj.theta{1}-10,obj.theta{1}+10,1000);
        elseif isvar('x')
            obj.x=x;
        end
        obj.pdf=obj.pdfFun(obj.x,obj.theta{:});
        obj.pdf(isinf(obj.pdf))=0;
        obj.pdf=obj.pdf/sum(obj.pdf(:));
    end
    function obj=rm_fit(obj,ind)
        obj.toFit(obj.toFit==ind)=[];
    end
    function obj = get_boot_fit(obj,nBoot,prcntChoose)
    %get_boot_fit(data,nBoot,prcntChoose,vargParams)
        if ~isvar('nBoot')
            nBoot=1000;
        end
        if ~isvar('prcntCHoose')
            prcntChoose=.5;
        end
        obj.boot=struct();
        obj.boot.nBoot=nBoot;
        obj.boot.prcntChoose=prcntChoose;
        obj.boot.hats=zeros(nBoot,narargin);
        for b = 1:nBoot
            x=datasample(obj.data,numel(obj.data),'Replace',true);
            obj.fit_fun(x);
            obj.boot.hats(b,:)=obj.hat;
        end
        obj.fit_fun(obj.data);

        obj.boot.hats=obj.hats';
        obj.boot.mean=mean(obj.boot.hats,2);
        obj.boot.se=std(obj.boot.hats,0,2);
        oneSide=(1-prcntChoose)/2;
        obj.boot.ci=quantile(obj.boot.mean,[oneSide, 1-oneSide]);
    end

    function obj = plot_boot(obj,Opts)
    %plot_boot(Opts)
        Opts.figNum=nfn;
        obj.boot.figNum=Opts.figNum;
        obj.boot.fig=figure(Opts.figNum);
        obj.boot.figOpts=Opts;
        n=length(obj.boot.hats);
        for i = 1:n
            subPlot([1 n],1,n)
            plot_histograms(obj.boot.hats,[],[],Opts,0);
            Opts.title=['Bootstrapped ' obj.params{i}];
            gaxis(Opts);
        end
        gfigure(Opts)
    end
    function obj = plot_pdf(obj)
        if isempty(obj.pdf)
            obj=obj.get_pdf;
        end
        obj.figpdf=figure;
        plot(obj.x,obj.pdf,'k');
        axis square
        formatFigure('X','P',['PDF'  newline obj.type])
    end

    function obj = plot_data(obj)
        if isempty(obj.pdf)
            obj.get_data();
        end
        obj.figdata=figure;
        [cnt,bins]=hist(obj.data);
        bar(bins,cnt)
        axis square
        formatFigure('X','P',['Data' newline obj.type])
    end


    function obj = plot_fit(obj)
        obj.figdata=figure;
        O=obj.get_pdf([],obj.hat);
        plot(O.bins,O.pdf,'k')
        formatFigure('X','P',obj.type);
    end
%%%%
    function obj = get_g(obj)
        obj.hat2theta();
        pe=obj.pdfFun(obj.data,obj.theta{:});
        obj.gof.g=2*sum(obj.data.*log(obj.data./pe));
    end

    function obj = get_chi2(obj)
        obj.hat2theta();
        pe=obj.pdfFun(obj.data,obj.theta{:});
        obj.gof.chisq=sum((obj.data-pe).^2./pe);
    end

    function obj = gof_dist(obj)
        obj.get_chi2
        obj.get_g
    end
end
end
