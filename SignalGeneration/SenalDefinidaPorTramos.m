clear;
close all;

% Puntos en el eje t
t=linspace(-2,10,1000);

% Funcion por partes
y1=(cos(2.*t)).*heaviside(-t-1);
y2=(t.^2 - exp(-t+1)).*heaviside(t+1).*heaviside(-t+1);
y3=(cos(3.*t).*sin(2.*t)).*heaviside(t-1).*heaviside(-t+5);
y4=((2.*t)./(2+t.^2)).*heaviside(t-5);
y=y1+y2+y3+y4;

% Ploteo de la funcion
figure;
plot(t,y,LineWidth=2,Color="r");
xlabel("t");
ylabel("y(t)")
title("Señal por partes de la funcion y(t)")

% Rejilla
grid("minor");