function Idot=IderivHast(im,splineType,vORh)
    switch splineType
    case 'CM'
        M = [1,-3,3,-1; -1,4,-5,2; 0,1,0,-1; 0,0,2,0]*0.5;
        u = [0.125;0.25;0.5;1];
        up = [0.75;1;1;0];
        d = up'*M;
        k = u'*M;
    end

    switch vORh
    case 'v'
        Idot = conv2(conv(d,k),conv(k,k),im,'same');
    case 'h'
        Idot = conv2(conv(k,k),conv(d,k),im,'same');
    end
end
