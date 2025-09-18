function Xk = dftfun(x)
N = length(x);
for k=0:N-1
    for n=0:N-1
        X(n+1)=x(n+1)*exp(-1j*2*pi*k*n/N);
    end
    Xk(k+1)=sum(X);
end
end

