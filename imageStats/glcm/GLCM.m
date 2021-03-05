function GO=GLCM(img,mask,Version)
    if isvar('mask')
        img=imgPart(img,mask);
    end
    if strcmp(Version,'mat')
        G=graycomatrix(img);
        GO=graycoprops(G);
    elseif strcmp(Version,'ext')
        offset=[2 0;0 2];
        G = graycomatrix(img,'Offset',offset);
        GO=GLCM_Features1(G,0);
    elseif strcmp(Version,'vec')
        G = graycomatrix(img);
        GO=GLCM_Features(G);
    end
end
function img = imgPart(img,mask)
    img(~mask)=nan;
    img = img(:,all(~isnan(img)));
end
