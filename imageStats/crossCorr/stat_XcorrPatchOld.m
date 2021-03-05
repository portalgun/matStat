function OUT=stat_XcorrPatch(D,G,P,Opts)
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

cax=[];
% XXX OLD
%[D,prb]=get_probe_details(D,P,G);
[x,y]  =meshgrid(1:P.PszXY(1),1:P.PszXY(2));

for s = 1:length(P.LorRall)

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
    progressreport(s,50,length(P.LorRall));
end

OUT.XcorrZone=Xcorr;
OUT.XcorrZoneSum=XcorrSum;
OUT.XcorrZoneMax=XcorrMax;
OUT.XcorrZone=XcorrZone;
OUT.XcorrZoneSum=XcorrZoneSum;
OUT.XcorrZoneMax=XcorrZoneMax;

% =================================================================
% FUNCTIONS
end

function [prbCrpLoc] = get_prb_crp_loc(s,P,D,x,y)
    prbCurXYpix        = P.PszXY./2-D.prbXYoffsetPix;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % DEPTH OF IMAGE PROBE
    try
        if strcmp(P.LorRall(s),'L')
            depthTrue       = interp2(x,y,P.depthImgDisp(:,:,s),     prbCurXYpix(1),prbCurXYpix(2));
        elseif strcmp(P.LorRall(s),'R')
            depthTrue       = interp2(x,y,P.depthImgDisp(:,:,s),     prbCurXYpix(1)-3-P.width(s),prbCurXYpix(2));
        end
    catch
        depthTrue       = 0;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    prbCurXYscrnM=(prbCurXYpix-P.PszXY/2).*D.multFactorXY./D.pixPerMxy;
    prbPPTxyzM=[prbCurXYscrnM D.PPxyz(2,3)];

    %GET L & R CORRESPONDING POINTS OF IMAGE PROBE
    if P.LorRall(s)=='L'
        prbTxyzM=intersectLinesFromPoints(D.LExyz,prbPPTxyzM,[-2 0 depthTrue],[2 0 depthTrue]);
        LitpXYZ=prbPPTxyzM;
        RitpXYZ=intersectLinesFromPoints(D.RExyz,prbTxyzM,D.PPxyz(1,:),D.PPxyz(2,:));
    elseif P.LorRall(s)=='R'
        prbTxyzM=intersectLinesFromPoints(D.RExyz,prbPPTxyzM,[-2 0 depthTrue],[2 0 depthTrue]);
        RitpXYZ=prbPPTxyzM;
        LitpXYZ=intersectLinesFromPoints(D.LExyz,prbTxyzM,D.PPxyz(1,:),D.PPxyz(2,:));
    end

    LitpXYT=LitpXYZ(1:2) .*D.pixPerMxy+D.scrnCtr; %CORRESPONDING POINTS IN IMAGE-SCREEN COORDINATES
    RitpXYT=RitpXYZ(1:2) .*D.pixPerMxy+D.scrnCtr; %CORRESPONDING POINTS IN IMAGE-SCREEN COORDINATES

    %GET CROP LOCATION FOR PROBE
    prbCrpLoc(1,:)=fliplr(LitpXYT-D.scrnCtr+P.PszXY/2);
    prbCrpLoc(2,:)=fliplr(RitpXYT-D.scrnCtr+P.PszXY/2);
end

function [PRB, IMG]=get_prb_img(s,prb,P,D,prbCrpLoc,bCropPrb,bRing)
    stmLfull=P.LccdRMS(:,:,s);
    stmRfull=P.RccdRMS(:,:,s);
    rmpSz=6;
    stmLprb=stmLfull;
    stmRprb=stmRfull;
    try
        stmLR=cropImageCtrInterp(stmLprb,     prbCrpLoc(1,:),D.pixPerDegXY.*D.prbXYdeg+rmpSz,'linear',0);
    catch
        stmLR=ones(round(fliplr(D.pixPerDegXY.*D.prbXYdeg+rmpSz))).*D.gry;
    end
    try
        stmRR=cropImageCtrInterp(stmRprb,     prbCrpLoc(2,:),D.pixPerDegXY.*D.prbXYdeg+rmpSz,'linear',0);
    catch
        stmRR=ones(round(fliplr(D.pixPerDegXY.*D.prbXYdeg+rmpSz))).*D.gry;
    end

    %CIRCULAR WINDOW -> ALPHA C
    sz=max(size(stmLR))-rmpSz;
    szs=[size(stmLR,2) size(stmLR,1)];
    %XXX
    W=cosWindowFlattop(szs,sz-5,rmpSz+5);

    prbR{1}(:,:,1)=stmLR;
    prbR{1}(:,:,2)=stmLR;
    prbR{1}(:,:,3)=stmLR;
    prbR{1}(:,:,4)=W;

    prbR{2}(:,:,1)=stmRR;
    prbR{2}(:,:,2)=stmRR;
    prbR{2}(:,:,3)=stmRR;
    prbR{2}(:,:,4)=W;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% RING
    loc=prbCrpLoc(1,:);
    bFG = loc(2) > P.AitpRCfgnd(s,2)+D.prbRadius(1); %XXX 1?
    try
        if P.LorRall(s)=='L' && bFG
            bgnL=zeros(round(fliplr(size(prb(:,:,1)))));
        elseif P.LorRall(s)=='L'
            bgnL=cropImageCtrInterp(double(P.LmonoBGmain(:,:,s) | P.LbinoFGmain(:,:,s)), loc,sz,'linear',0);
        elseif P.LorRall(s)=='R' && bFG
            bgnL=zeros(round(fliplr(size(prb(:,:,1)))));
        elseif P.LorRall(s)=='R'
            bgnL=zeros(round(fliplr(size(prb(:,:,1)))));
        end
    catch
        bgnL=zeros(round(fliplr(size(prb(:,:,1)))));
    end

    loc=prbCrpLoc(2,:);
    bFG = loc(2) < P.AitpRCfgnd(s,2)+D.prbRadius(1);
    try
        if P.LorRall(s)=='L'  && bFG
            bgnR=zeros(round(fliplr(size(prb(:,:,1)))));
        elseif P.LorRall(s)=='L'
            bgnR=zeros(round(fliplr(size(prb(:,:,1)))));

        elseif P.LorRall(s)=='R' && bFG
            bgnR=zeros(round(fliplr(size(prb(:,:,1)))));
        elseif P.LorRall(s)=='R'
            bgnR=cropImageCtrInterp(double(P.RmonoBGmain(:,:,s) | P.RbinoFGmain(:,:,s)), loc,sz,'linear',0);
        end
    catch
        bgnR=zeros(round(fliplr(size(prb(:,:,1)))));
    end
    %%%%%%%%%%%%%

    %HIDE RING (BY ALPHA) IF OCCLUDED
    prbIL=prb(:,:,4);
    prbIR=prb(:,:,4);
    %XXX round?
    prbIL(logical(ceil(bgnR)))=0;
    prbIR(logical(ceil(bgnL)))=0;

    prbI{1}(:,:,1)=prb(:,:,1);
    prbI{1}(:,:,2)=prb(:,:,2);
    prbI{1}(:,:,3)=prb(:,:,3);
    prbI{1}(:,:,4)=prbIL;

    prbI{2}(:,:,1)=prb(:,:,1);
    prbI{2}(:,:,2)=prb(:,:,2);
    prbI{2}(:,:,3)=prb(:,:,3);
    prbI{2}(:,:,4)=prbIR;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    if P.LorRall(s)=='L'
        PRB=prbR{1};
        IMG=P.RccdRMS(:,:,s);
    elseif P.LorRall(s)=='R'
        PRB=prbR{2};
        IMG=P.LccdRMS(:,:,s);
    end

    if bCropPrb==1
        PRB=PRB(:,:,1).*PRB(:,:,4);
    else
        PRB=PRB(:,:,1);
    end
    PRB(1:3,:)=[];
    PRB(:,1:3)=[];
    PRB(:,end-1:end)=[];
    PRB(end-1:end,:)=[];

    if bRing==1
        if P.LorRall(s)=='L'
            RNG=prbI{1};
        elseif P.LorRall(s)=='R'
            RNG=prbI{2};
        end
        RNGA=(RNG(:,:,4));
        RNGA=imresize(RNGA,size(PRB),'bilinear');
        RNGA=RNGA/max(max(RNGA));

        RNGB=1-(RNG(:,:,4));
        RNGB=imresize(RNGB,size(PRB),'bilinear');
        RNGB=RNGB/max(max(RNGB));

        RNG=RNG(:,:,1).*RNG(:,:,4);
        RNG=imresize(RNG,size(PRB),'bilinear');
        RNG=RNG/max(max(RNG));

        PRB=(RNG.*RNGA)+(PRB.*(RNGB));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
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
