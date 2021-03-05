logist=@(x,theta,gamma) log(gamma) + gamma.*(log(x)-log(theta))-log(x)-2*log(1 + (x./theta).^gamma);
