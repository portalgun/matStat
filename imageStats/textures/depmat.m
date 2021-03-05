function A = depmat(N,M,distFunc)
if ~isvar('distFunc') || strcmp(distfun,'c')
    distFunc='cityblock';
elseif strcmp(distfun,'e')
    distFunc='euclidean';
end
[X Y] = meshgrid(1:N,1:M);
X = X(:); Y = Y(:);
%A = squareform( pdist([X Y], distFunc) == 1 ); touching only
A = squareform(pdist([X Y], distFunc));
A=1./A; %weights are inverse of distance
A(logical(eye(size(A))))=0; %set diag equal to zero
