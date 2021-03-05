function [GO]=GLCMdouble(Limg,Rimg,Lmask,Rmask,Version)
%GET COMBINED G OBJECT HANDLER
    if isvar('Lmask') && isvar('Lmask')
        GLO=GLCM(Limg,Lmask,Version);
        GRO=GLCM(Rimg,Rmask,Version);
    else
        GLO=GLCM(Limg,[],Version);
        GRO=GLCM(Rimg,[],Version);
    end

    flds=fieldnames(GLO);
    for i = 1:length(flds)
        GO.(flds{i})=(GLO.(flds{i})+GRO.(flds{i}))/2;
    end
end
