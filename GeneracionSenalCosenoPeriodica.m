clear;
close all;
% Hallar el periodo
T=(2.*pi)/(3.*pi);

% Puntos en eje t
t= linspace(0,4.*T,1000);

% Funcion x(t)
x = 3.*cos((3.*pi.*t)+(pi./3));

% Ploteo
figure;
plot(t,x,LineWidth=2,Color="r");
xlabel("t");
ylabel("x(t)");
title("x(t)=3cos(3𝜋t+𝜋/3)")

% Rejilla
grid("minor");