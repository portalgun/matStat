function [GO]=GLCMsingle(img,mask,Version)
%GET G OBJECT HANDLER
    if isvar('mask')
        GO=GLCM(img,mask,Version);
    else
        GO=GLCM(img,[],Version);
    end
end
