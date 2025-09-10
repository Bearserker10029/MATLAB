clear;
close all;

% Puntos en el eje t
t=linspace(-4,4,1000);

% Funcion
x1=(2.*t).*heaviside(t+1).*heaviside(-t);
x2=(cos(5.*t)+sin(2.*t)).*heaviside(t).*heaviside(3-t);
x=x1+x2;

% Funcion invertida
x1op=(2.*-t).*heaviside(-t+1).*heaviside(t);
x2op=(cos(5.*-t)+sin(2.*-t)).*heaviside(-t).*heaviside(3+t);
xopuesto=x1op+x2op;

xpar= (x+xopuesto)/2;
ximpar= (x-xopuesto)/2;
xsuma=xpar+ximpar;

% Ploteo de la funcion
figure;
subplot(4,1,1);
plot(t,x,"LineWidth",2,"Color","g");
xlabel("t");
ylabel("x");
title("Señal x(t) ")
% Rejilla
grid("minor");

subplot(4,1,2);
plot(t,xpar,"LineWidth",2,"Color","r");
xlabel("t");
ylabel("x");
title("Señal parte par de x(t) ")
% Rejilla
grid("minor");

subplot(4,1,3);
plot(t,ximpar,"LineWidth",2,"Color","b");
xlabel("t");
ylabel("x");
title("Señal parte impar de x(t) ")
% Rejilla
grid("minor");

subplot(4,1,4);
plot(t,xsuma,"LineWidth",2,"Color","m");
xlabel("t");
ylabel("x");
title("Señal parte par + impar de x(t) ")
% Rejilla
grid("minor");