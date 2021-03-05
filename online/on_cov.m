function C=on_cov(x,y,Co,MXo,MYo,n)

    MX=mean_fun(x,MXo,n);
    MY=mean_fun(x,MYo,n);
    N

    cov(x,y)*(n-1) + N/(N-1)*(x-Mx)*(y-My);
end

function M=mean_fun(x,Mo,n)
    M=Mo + (x-Mo)/n;
end
