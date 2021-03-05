function [table,names]=importTable(fname)
% for manually labelled data
    bTest=0; % NOTE

    if bTest==1
        fname='/home/dambam/Cloud/Code/mat/projects/depthProbeAdjust/trials.org'; % NOTE
    end

    [table,names]=init(fname);
    [table,names]=main(table,names,bTest);
end
function [TABLE,NAMES]=main(table,names,bTest)
    TABLE=zeros(0);
    NAMES={};
    prcnt=.2*size(table,1);
    for i = 1:size(table,2)
        col=table(:,i);
        colname=names{i};
        if isempty(col)
            continue
        end

        vals=get_vals(col);
        if bTest==1
            disp(newline);
            disp([num2str(i) ' ' colname]);
            disp(vals);
            waitforbuttonpress;
        end

        star=contains(col,'*');
        col=strrep(col,'*','');
        if numel(vals) > prcnt && sum(star,1)>0 && all(isnumstr(col))
            numel(vals)
            col=cellfun(@str2double,col);
            new=[col,star];
            newN=horzcat({colname},{[colname '__star']});
        elseif numel(vals) > prcnt && sum(star,1)>0
            error('');
        elseif numel(vals) > prcnt
            new=cellfun(@str2double,col);
            newN=colname;
        else
            newN=proc_names(names{i},vals);
            new=proc_column(col,vals);
        end

        TABLE=horzcat(TABLE,new);
        NAMES=horzcat(NAMES,newN);
    end
end

function [table,names]=init(fname)
    bTest=1;
    fid = fopen(fname);
    tlines={};
    tline = fgetl(fid);
    while ischar(tline)
        tlines{end+1,1}=tline;
        tline=fgetl(fid);
    end
    fclose(fid);

    names=tlines{1};
    names=strsplit(names,'|');
    names=strtrim(names);
    names=strrep(names,'#','Num');
    names=strrep(names,' ','_');

    tlines(1,:)=[];
    table=cell(length(tlines),length(names));
    for i = 1:length(tlines)
        table(i,:)=strsplit(tlines{i},'|');
    end

%remove leading whitespace
    for n = 1:numel(table)
        if isempty(table{n})
            continue
        end
        table{n}=strtrim(table{n});
    end

%remove empty columns
    for i = size(table,2):-1:1
        if isempty([table{:,i}])
            table(:,i)=[];
            names(:,i)=[];
        end
    end
end

function flds=get_vals(col)
% 3 - an
    flds=join(col,',');
    flds=flds{1};
    flds=unique(strsplit(flds,','));
    flds=strrep(flds,' ','');

    % XXX
    flds=strrep(flds,'???','?');
    flds=strrep(flds,'?)','?');
    flds=strrep(flds,'(','');
    for i = 1:length(flds)
        if ismember('?',flds{i});
            flds{i}=[strrep(flds{i},'?','') '?'];
        end
    end

    flds=unique(flds);
    flds(cellfun(@isempty,flds))=[];
end

function NEW=proc_column(col,vals)
    NEW=zeros(length(col),numel(vals));
    for i = 1:length(col)
        elem=col{i};
        if isempty(elem)
            continue
        end
        elem=strsplit(elem,',');
        elem=strrep(elem,' ','');

        % XXX
        elem=strrep(elem,'???','?');
        elem=strrep(elem,'?)','?');
        elem=strrep(elem,'(','');
        if ismember('?',elem)
            elem=[strrep(elem,'?','') '?'];
        end

        NEW(i,:)=contains(vals,elem);
    end
end

function NAMES=proc_names(name,vals)
    NAMES=cell(1,numel(vals));
    for i = 1:length(vals)
        NAMES{i}=[name '__' vals{i}];
    end
end
