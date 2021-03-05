function [kRMS grd] = rmsZone(img,mask)
    mask=logical(mask);
    img=img(mask);
    img=img(:);
    Lbar=nanmean(img);
    Iweb=(img-Lbar)./Lbar;
    kRMS=sqrt(nanmean(Iweb.^2));
end
