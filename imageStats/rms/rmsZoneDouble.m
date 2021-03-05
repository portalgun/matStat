function rmsBino=rmsZoneDouble(Limg,Rimg,Lmask,Rmask)
%RMS HANDLER
    L_kRMS=rmsZone(Limg,Lmask);
    R_kRMS=rmsZone(Rimg,Rmask);
    rmsBino=(L_kRMS+R_kRMS)/2;
end
