clear all;
close all;

N=8;
x = zeros(N, 1);

for n=0:(N-1)
    x(n+1) = (-1)^n;
end

x

WN = miwn(N);

Xk = WN * x

fft(x)