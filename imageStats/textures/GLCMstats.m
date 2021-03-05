function [S] = GLCMstats(G)
% G=graycomatrix(I) %GL spatial dep. mat.
P=G./sum(G(:));

S.Energy  = GLCMenergy(P);
S.Entropy = GLCMentropy(P);
S.Mean    = GLCMmean(G);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E=GLCMenergy(P)
%energy/uniformity/angular second momenty
    E=@(P) -sum( P(:).^2);
end
function H=GLCMentropy(P)
    H=-sum( P(:) .* ln(P(:)));
end
function Mu = GLCMmean(G,P)
   [N M]=size(P);
   k=2:(2*N);
   Mu=0;
   for i = 1:N
   for j = 1:M
     if ismember((i+j),k)
        Mu=Mu+P(i,j)
   end
   end
end

function [GLCMl,GLCMr]=GLCMmean2(G)
[m n]=size(G);
GLCMl=0  % left
GLCMr=0; % right
for x=1:m
    for y=1:n
        muL=GLCMl+x*G(x,y);
        muR=GLCMr+y*G(x,y);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
glcm
p_x
p_y

format long e
if (pairs == 1)
  newn = 1;
  for nglcm = 1:2:size(glcmin,3)
    glcm(:,:,newn)  = glcmin(:,:,nglcm) + glcmin(:,:,nglcm+1);
    newn = newn + 1;
  end
elseif (pairs == 0)
  glcm = glcmin;
end

size_glcm_1 = size(glcm,1);
size_glcm_2 = size(glcm,2);
size_glcm_3 = size(glcm,3);

p_xplusy = zeros((size_glcm_1*2 - 1),size_glcm_3); %[1]
for k = 1:size_glcm_3
  for i = 1:size_glcm_1
    for j = 1:size_glcm_2
      p_x(i,k) = p_x(i,k) + glcm(i,j,k);
      p_y(i,k) = p_y(i,k) + glcm(j,i,k); % taking i for j and j for i
      if (ismember((i + j),[2:2*size_glcm_1]))
        p_xplusy((i+j)-1,k) = p_xplusy((i+j)-1,k) + glcm(i,j,k);
      end
      if (ismember(abs(i-j),[0:(size_glcm_1-1)]))
        p_xminusy((abs(i-j))+1,k) = p_xminusy((abs(i-j))+1,k) +...
                                    glcm(i,j,k);
      end
    end
  end


for k = 1:(size_glcm_3)
  for i = 1:(2*(size_glcm_1)-1)
    out.savgh(k) = out.savgh(k) + (i+1)*p_xplusy(i,k);
                   % the summation for savgh is for i from 2 to 2*Ng hence (i+1)
    out.senth(k) = out.senth(k) - (p_xplusy(i,k)*log(p_xplusy(i,k) + eps));
  end
end
