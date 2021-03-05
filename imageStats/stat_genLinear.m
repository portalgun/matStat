modelspec='linear';
clear X Y GDINDALL
subj='DNW';

E=1:3;
SE=1:3;
for e = 1:2
for se= 1:3
    if e==1 & se==3
        continue
    end

    [ST ETall GDIND]=STATS(subj,SS,P,D,G,e,se);

    %GOOD INDECES
    if ~isvar('GDINDALL')
        GDINDALL=GDIND;
    else
        GDINDALL=GDINDALL & GDIND;
    end

    %REGRESSORS
    flds=fields(ST);
    for i=1:length(flds)
        if strcmp(flds{i},'statNames') || ndims(ST.(flds{i}))>2
            continue
        end

        STtmp=ST.(flds{i});

        if ~isvar('X')
            X=[ones(size(STtmp)) zscore(STtmp)];
        else
            X=[X zscore(STtmp)];
        end
    end

    %PREDICTORS
    if ~isvar('Y')
        Y=ETall;
    else
        Y=[Y ETall];
    end
end
end

GDINDALL=logical(GDINDALL);
X=X(GDINDALL,:)
Y=Y(GDINDALL,:)

[n,d] = size(Y);
Xcell = cell(1,n);
for i = 1:n
    Xcell{i} = [kron([X(i,:)],eye(d))];
end
%[beta,sigma,errs,V] = mvregress(Xcell,Y);
[beta,sigma,errs,V] = mvregress(X,Y);
se = sqrt(diag(V));
