function w=edgeTap(im,num)
    % XXX low pass filtering?
    Iv=IderivTap(im,num,1,'v');
    Ih=IderivTap(im,num,1,'h');
    w=sqrt(Iv.^2+Ih.^2);
    % XXX divisive normalization?
end
