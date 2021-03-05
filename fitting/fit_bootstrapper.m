function [B,M,SE,CI]=fit_bootstrapper(type,X,bins,nBoot,prcntChoose,bPlot)

for i = 1:nBoot
    x=datasample(X,numel(X),'Replace',true);
    [p,P,G,Chi2]=fit_wrapper(type,x,bins);

    if i == 1
        flds=fieldnames(P);
        B=param_initializer(P,flds,nBoot);
    end

    for p = 1:length(flds)
        fld=flds{p};
        cols=repmat(',:',1,D.(fld));
        str=['B.(fld)(i' cols ')=P.(fld);'];
        eval(str);
    end
end

oneSide=(1-prcntChoose)/2;
M=struct();
SE=struct();
for p = 1:length(flds)
    fld=flds{p};
    M.(fld)=mean(B.(fld),1);
    SE.(fld)=std(B.(field),0,1);
    CI=quantile(M.(fld),[oneSide, 1-oneSide]);
end

% -------------------------
% FUNCTIONS
end
function [B,D]=param_initializer(P,flds,nBoot)
    B=struct();
    D=struct();
    for p = 1:length(flds)
        fld=flds{p};
        B.(fld)=zeros([nBoot,size(P.(fld))]);
        D.(fld)=ndims(P.(fld));
    end
end
