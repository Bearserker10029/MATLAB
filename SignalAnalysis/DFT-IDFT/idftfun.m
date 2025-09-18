function x = idftfun(Xk)
N = length(Xk);
for n=0:N-1
    for k=0:N-1
        xn(k+1)=Xk(k+1)*exp(1j*2*pi*n*k/N);
    end
    x(n+1) = sum(xn);
end
x = (1/N)*x;
end

