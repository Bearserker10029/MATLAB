clear all;
close all;

N=4;

xk=[6; -2+2j; -2; -2-2j];

WN=miwn(N);
x = (1/N) * WN' * xk

ifft(xk)
