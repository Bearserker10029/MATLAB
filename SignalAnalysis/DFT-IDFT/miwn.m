function WN = miwn(N)

WN = zeros(N, N);

for n=0:(N-1)
    for k=0:(N-1)
        WN(n+1,k+1)= exp(-j * 2 * pi * n * k / N);
    end
end
end