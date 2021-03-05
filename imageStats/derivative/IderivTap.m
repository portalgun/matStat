function Idot=IderivTap(im,tapNum,order,vORh)
% tapNum corresponds to - nyquist frequency
% https://www.cns.nyu.edu/pub/lcv/farid03-reprint.pdf
    switch tapNum
    case 3
        k1   = [0.552490  0.223755];
        d1   = [0.000000  0.453014];

        k2   = [0.540242  0.229879];
        d1_2 = [0.000000 -0.425287];
    case 5
        k1   = [0.439911  0.249724  0.030320];
        d1   = [0.000000 -0.292315 -0.104550];

        k2   = [ 0.426375  0.249153  0.037659];
        d1_2 = [ 0.000000 -0.276691 -0.109604];
    case 7
        k1   = [ 0.361117  0.245410  0.069321  0.004711];
        d1   = [ 0.000000 -0.193091 -0.125376 -0.018708];

        k2   = [ 0.361117  0.245410  0.069321  0.004711];
        d1_2 = [ 0.000000 -0.193091 -0.125376 -0.018708];
        d2   = [-0.273118 -0.056554  0.137778  0.055336];
    case 9
        k1   = [];
        d1   = [];

        k2   = [ .317916  .234494  .090341  .015486  .000721];
        d1_2 = [ .000000 -.143928 -.118739 -.035187 -.003059];
        d2   = [-.191974 -.061661  .085598  .061793  .010257];
        d3   = [ .000000  .203718  .053614 -.065929 -.027205];
    end

    if isvar('k1')
        k1=fun(k1,0);
    end
    if isvar('k2')
        k2=fun(k2,0);
    end
    if isvar('d1')
        d1=fun(d1,1);
    end
    if isvar('d2')
        d2=fun(d2,0);
    end
    if isvar('d3')
        d3=fun(d3,1);
    end


    switch order
    case 1
        K=k1;
        D=d1;
    case 2
        D=d2;
        K=k2;
    case 3
        D=d3;
        K=k2;
    end

    switch vORh
    case 'v'
        Idot = conv2(D,K,im,'same');
    case 'h'
        Idot = conv2(K,D,im,'same');
    end
end
function k=fun(k,bOdd)
    if ~isvar('bOdd')
        bOdd=0;
    end
    l=length(k);
    rng=ceil(l/2):l;
    if ~bOdd
        k=[fliplr(k(rng)) k];
    elseif bOdd
        k=[-1*fliplr(k(rng)) k];
    end
end
