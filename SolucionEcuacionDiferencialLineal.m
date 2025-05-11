clear;
close all;

% Variable simbolica
syms t y(t)
ecua=diff(y,2)+8*diff(y)-4.*y==exp(-t).*cos(t);

% Condiciones iniciales
Dy= diff(y);
cond=[y(0)==0,Dy(0)==1];

% Simplificar la solución
ySol(t) = dsolve(ecua,cond);
f(t)=simplify(ySol(t));

% Ploteo
fplot(f,[0,20],Color="r",LineWidth=2)
grid on;