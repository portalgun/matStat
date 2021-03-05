function [MM,SEM,CI]= bootMeanBasic(data,nBoot,prcntChoose)
%BOOTSTRAP ERRORS
M=zeros(nBoot,1);
data=data(~isnan(data));
for b=1:nBoot
    y=datasample(data,numel(data),'Replace',true);
    M(b)=mean(y);
end
SEM=std(M);
MM =mean(M);
oneSide=(1-prcntChoose)/2;
CI=quantile(M,[oneSide, 1-oneSide]);
