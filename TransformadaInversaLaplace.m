clear;
close all;
syms s

num = [8 21 19]; % (8s^2 + 21s + 19)
den = conv([1 2],[1 1 7]); % (s+2)(s^2 + s + 7)

% Fracciones parciales
[r,p,k] = residue(num,den);
r
p
k

mag = abs(r); % magnitudes de los numeradores
mag

ang = angle(r); % argumentos de los numeradores
ang

X=(mag(1)*exp(ang(1)*1j))/(s-p(1)) + (mag(2)*exp(ang(2)*1j))/(s-p(2))+(mag(3)*exp(ang(3)*1j))/(s-p(3))
Z = r(1)/(s - p(1)) + r(2)/(s - p(2)) + r(3)/(s - p(3));
display(X)

% Transformada inversa de Laplace
ilaplace(X)
ilaplace(Z)