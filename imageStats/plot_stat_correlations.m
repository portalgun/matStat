bPlotAll=0;
plotfld='interpErr'
Type='Pearson';
disp([Type ' correlation between Error & ...'])
flds=fields(ST);
for i=1:length(flds)
    if strcmp(flds{i},'statNames') || ndims(ST.(flds{i}))>2 || iscell(ST.(flds{i}))
        continue
    end
    gdInd=GDIND & ~isnan(ST.(flds{i}));
    Etmp=ETall(gdInd);
    STtmp=ST.(flds{i})(gdInd);
    try
        C=corr(Etmp,STtmp,'Type',Type);
    catch
        continue
    end
    disp(['  ' flds{i} ' ' num2str(C)])
    if  (bPlotAll && contains(flds{i},'_') && abs(C)>plotthresh) || strcmp(flds{i},plotfld)
        figure(nFn)
        scatter(Etmp,STtmp,'.k')
        formatFigure('Normalized Error',strrep(flds{i},'_',' '))
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = indPlot(ST,P,i,stats)
    figure(659)
    clc
    for j = 1:length(stats)
        stat=stats{j};
        A= ST.([stat 'A'  ])(i);
        F= ST.([stat 'F'  ])(i);
        B= ST.([stat 'B'  ])(i);
        M= ST.([stat 'M'  ])(i);
        FB=ST.([stat '_FB'])(i);
        FM=ST.([stat '_FM'])(i);
        BM=ST.([stat '_BM'])(i);
        disp(stat);
        %size(ST.([stat 'F']))
        %size(ST.([stat 'B']))
        %size(ST.([stat 'M']))
        disp(['    A   ' num2str(A)]);
        disp(['    F   ' num2str(F)]);
        disp(['    B   ' num2str(B)]);
        disp(['    M   ' num2str(M)]);
        disp(['    F-B ' num2str(FB)]);
        disp(['    F-M ' num2str(FM)]);
        disp(['    B-M ' num2str(BM)]);
        disp(newline);
    end
    Limg=P.LccdRMS(:,:,i);
    Rimg=P.RccdRMS(:,:,i);

    subplot(4,1,1)
    imagesc([Limg Rimg].^.4)
    colormap gray

    subplot(4,1,2)
    imagesc([P.LbinoFG(:,:,i) P.RbinoFG(:,:,i)])

    subplot(4,1,3)
    imagesc([P.LbinoBG(:,:,i) P.RbinoBG(:,:,i)])

    subplot(4,1,4)
    imagesc([P.LmonoBG(:,:,i) P.RmonoBG(:,:,i)])

    drawnow
    waitforbuttonpress
end
