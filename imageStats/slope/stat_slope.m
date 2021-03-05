function [R2fg,err,model]=stat_slope(LorR,x,y,z,bInd,bIndInterp,Opts)
    if ~isfield(Opts,'tPlotSurf')
        Opts.tPlotSurf=0;
    end
    if ~isfield(Opts,'bRemoveNan')
        Opts.bRemoveNan=0;
    end
    if ~isfield(Opts,'norma')
        Opts.norma='on';
    end
    if ~isfield(Opts,'bSmear')
        Opts.bSmear=1;
    end
    if ~isfield(Opts,'TYPE')
        Opts.TYPE={'linearinterp'};
    end
    unpackOpts(Opts);

    %Values at binocular background
    Xbino=x(bInd);
    Ybino=y(bInd);
    Zbino=z(bInd);

    %Remove or Interpolate at nans in Zbino
    if bRemoveNan
        nanInd=isnan(Zbino);
        Xbino(nanInd)=[];
        Ybino(nanInd)=[];
        Zbino(nanInd)=[];
    else
        nanInd=isnan(Zbino);
        Xq=Xbino(nanInd);
        Yq=Ybino(nanInd);
        if ~isempty(nanInd)
            Zbino(nanInd)=interp2(x,y,z,Xq,Yq);
            nanInd=isnan(Zbino);
        end

        nanInd=isnan(Zbino);
        Xq=Xbino(nanInd);
        Yq=Ybino(nanInd);
        if ~isempty(nanInd)
            Zbino(nanInd)=interp2(x,y,z,Xq,Yq,'nearest');
            nanInd=isnan(Zbino);
        end

        nanInd=isnan(Zbino);
        if ~isempty(nanInd)
            Zbino(nanInd)=nanmean(nanmean(Zbino));
        end
    end

    %Values in mono background
    bIndInterp=logical(bIndInterp);
    Xmono=x(bIndInterp);
    Ymono=y(bIndInterp);
    Zmono=z(bIndInterp);

    %Fit
    R2fgTmp=nan(length(TYPE),1);
    errTmp=nan(length(TYPE),1);
    ZbinoHatTmp=cell(length(TYPE),1);
    ZmonoHatTmp=cell(length(TYPE),1);
    for t = 1:length(TYPE)
        type=TYPE{t};
        [R2fgTmp(t),errTmp(t),ZbinoHatTmp{t},ZmonoHatTmp{t}]=fitting(Xbino,Ybino,Zbino,Xmono,Ymono,Zmono,type,norma);
    end
    if isempty(TYPE)
        t=0;
    end
    if bSmear
        [R2fgTmp(t+1), errTmp(t+1),ZbinoHatTmp{t+1},ZmonoHatTmp{t+1}] = smear(LorR,Xbino,Ybino,Zbino,Xmono,Ymono,Zmono);
    end
    maxi=min(errTmp);
    ind=find(errTmp==maxi);
    R2fg=R2fgTmp(ind);
    err=errTmp(ind);
    ZbinoHat=ZbinoHatTmp{ind};
    ZmonoHat=ZmonoHatTmp{ind};

    if ind==t+1
        model='smear';
    else
        model=TYPE{ind};
    end
    plot_fun(tPlotSurf,Xbino,Xmono,Ybino,Ymono,z,bInd,bIndInterp,ZmonoHat);
end

function [] = plot_fun(tPlotSurf,Xbino,Xmono,Ybino,Ymono,z,bInd,bIndInterp,ZmonoHat)
%PLOT
    if tPlotSurf
        PszXY=fliplr(size(bInd));
        subPlot([1 2],1,1)
        img=vecs2img(PszXY,[Xbino;Xmono],[Ybino;Ymono],[z(bInd); z(bIndInterp)]);
        e=edge(bIndInterp);
        [R,C]=find(e);
        hold off
        imagesc(img); hold on
        cax=caxis;
        formatImage;
        scatter(C,R,'.r')

        subPlot([1 2],1,2)
        img=vecs2img(PszXY,Xmono,Ymono,ZmonoHat);
        img(bInd)=z(bInd);
        hold off
        imagesc(img); hold on
        caxis(cax);
        formatImage;
        scatter(C,R,'.r')

        drawnow
        waitforbuttonpress
    end
end

function [R2fg, err,ZbinoHat,ZmonoHat]=fitting(Xbino,Ybino,Zbino,Xmono,Ymono,Zmono,type,norma)

    FIT=fit([Xbino,Ybino],Zbino,type,'Normalize',norma);

    %Evaluate
    ZbinoHat=FIT(Xbino,Ybino);
    ZmonoHat=FIT(Xmono,Ymono);

    %R^2 fg as a measure of reliability
    mu=mean(Zbino);
    ss_tot=sum((mu-Zbino).^2);
    ss_reg=sum((mu-ZbinoHat).^2);
    R2fg=1-(ss_reg./ss_tot);

    %X^2 as a GOF comparing to ground truth
    err=nansum((ZmonoHat-Zmono).^2);
    if sum(isnan(ZmonoHat))>(numel(ZmonoHat)/4)
        err=100;
    end
end

function [R2fg, err,ZbinoHat,ZmonoHat] = smear(LorR,Xbino,Ybino,Zbino,Xmono,Ymono,Zmono)
    mu=mean(Zbino);
    if LorR=='R'
        [YX,ind]=sortrows([Ybino,Xbino],'ascend');
    elseif LorR=='L'
        [YX,ind]=sortrows([Ybino,Xbino],'descend');
    end
    Zbino=Zbino(ind);
    ind=diff(YX(:,1));
    ind=find(ind);
    YX=YX(ind,:);
    ind=ismember([Ybino Xbino],YX,'rows');
    vals=Zbino(ind);
    ZmonoHat=zeros(length(Ymono),1);
    ZbinoHat=zeros(length(Ybino),1);
    for i = 1:size(YX,1)
        ZmonoHat(Ymono==YX(i,1))=vals(i);
        ZbinoHat(Ybino==YX(i,1))=vals(i);
    end

    %R^2 fg as a measure of reliability
    mu=mean(Zbino);
    ss_tot=sum((mu-Zbino).^2);
    ss_reg=sum((mu-ZbinoHat).^2);
    R2fg=1-(ss_reg./ss_tot);

    %X^2 as a GOF comparing to ground truth
    err=nansum((ZmonoHat-Zmono).^2);
end
