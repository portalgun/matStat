function [] = table2csv(fname)
%fname='/home/dambam/Cloud/Code/mat/projects/depthProbeAdjust/trials.org';
    [table,names]=importTable(fname);
    [fpath,fname]=fileparts(fname);
    fname=[fpath filesep fname '.csv'];
    %writematrix(table,'Delimiter',',');
    csvwrite(fname,table);

    names=join(names,',');
    names=names{1};

    S=fileread(fname);
    S=[names, char(10), S];
    fid=fopen(fname,'w');
    fwrite(fid, S, 'char');
    fclose(fid);
end
