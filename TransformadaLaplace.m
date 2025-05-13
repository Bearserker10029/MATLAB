clear;
close all;

num = [8 21 19]; den = conv([1 2],[1 1 7]);
[r,p,k] = residue(num,den);
r
p
k

mag = abs(r); % magnitudes de los numeradores
mag

ang = angle(r); % argumentos de los numeradores
ang