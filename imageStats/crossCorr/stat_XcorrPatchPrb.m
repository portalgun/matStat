function =stat_XcorrPatchPrb(Opts)
if ~isfield(Opts,'tPlot')
    tPlot=0;
end
if ~isfield(Opts,'bRing')
    bRing=1;
end
if ~isfield(Opts,'bCropPrb')
    bCropPrb=0;
end
if ~isfield(Opts,'bCropCX')
    bCropCX=1;
end
if ~isfield(Opts,'weight')
    weight='euclid';
end
unpackOpts(Opts);
 % -----------------------------------
% X-Correlate with Probe

% XXX OLD
%D = depthProbeAdjustPrbInit(P,D,s);
%prbCrpLoc = get_prb_crp_loc(s,P,D,x,y);
%[PRB, IMG] =get_prb_img(s,prb,P,D,prbCrpLoc,bCropPrb,bRing);

%CX=normxcorr2(PRB,IMG);

%CROP CORRELELLOGRAM
if bCropCX==1
    RC=size(PRB)*2;
    CX=cropMat(CX,RC);

    buffer=size(PRB)-1;
    RC=size(CX)+1-buffer;

    lenR=ceil(1:RC(1)/2-1);
    CX(lenR,:)=[];
    lenR=floor(0:RC(1)/2-2);
    CX(end-lenR,:)=[];
end

%WEIGHTING BY DISTANCE
if s==1 && strcmp(weight,'euclid')
    n=floor(size(CX)/2);
    wr=abs(-n(1):n(1));
    wc=abs(-n(2):n(2));
    wr=1./wr;
    wc=1./wc;
    [x,y]=meshgrid(wc,wr);
    y(y==Inf)=1;
end

if s==1
    xCorr=zeros(size(CX,1),size(CX,2),length(P.LorRall));
    XcorrSum=zeros(length(P.LorRall),1);
    XcorrMax=zeros(length(P.LorRall),1);
end
Xcorr(:,:,s)=CX;
XcorrSum(s)=sumall(CX.*y);
XcorrMax(s)=maxall(CX.*y);

% -----------------------------------
% X-Correlate with Whole Mono Zone

% GET ZONE
if P.LorRall(s)=='L'
    ZONE=P.LmonoBGmain(:,:,s).*P.LccdRMS(:,:,s);
elseif P.LorRall(s)=='R'
    ZONE=P.RmonoBGmain(:,:,s).*P.RccdRMS(:,:,s);
end

CX=normxcorr2(ZONE,IMG);

%CROP CORRELELLOGRAM
if bCropCX==1
    CX=cropMat(CX,RC);
end

if s==1
    XcorrZone=zeros(size(CX,1),size(CX,2),length(P.LorRall));
    XcorrZoneSum=zeros(length(P.LorRall),1);
    XcorrZoneMax=zeros(length(P.LorRall),1);
end
XcorrZone(:,:,s)=CX;
XcorrZoneSum(s)=sumall(CX);
XcorrZoneMax(s)=maxall(CX);

% -----------------------------------
%PLOT
if ismember(1,tPlot)
    plot_1(s,cax,PRB,IMG);
end
if ismember(2,tPlot)
    plot_2(IMG,ZONE);
end
end


function [] = plot_1(s,cax,PRB,IMG)
    ssz=[1 2];
    if ~isvar('cax')
        cax=[];
    end

    figure(1)

    subPlot(ssz,1,1);
    imagesc(IMG.^.4)
    if s ==1 || isempty(cax)
        cax=caxis;
    else
        caxis(cax)
    end
    formatImage;

    subPlot(ssz,1,2);
    imagesc(PRB.^.4)
    formatImage;
    caxis(cax)
end

function []=plot_2(IMG,ZONE)
    figure(1)
    ssz=[3,1];

    subPlot(ssz,1,1)
    imagesc(CX)
    caxis([0 1])
    formatImage;
    subPlot(ssz,1,1)
    colormap cool

    subPlot(ssz,2,1)
    imagesc(IMG.^.4)
    cax=caxis;
    formatImage;

    subPlot(ssz,3,1)
    imagesc(ZONE.^.4)
    formatImage;
    caxis(cax)
    drawnow
    waitforbuttonpress
end
