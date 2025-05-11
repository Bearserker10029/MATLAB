% Parámetros
clear
close all
paso = 0.001; % Paso de tiempo
t1 = 0:paso:2; % Tiempo para x(t)
x = ones(size(t1)); % Señal x(t) = u(t) - u(t-2)
plot(t1, x);


t2 = 1:paso:4; % Tiempo para h(t)
h = exp(-2*(t2-1 )); % Respuesta al impulso h(t) = e^(-2(t-1))u(t-1)
plot(t2, h);


% Convolución numérica
y = conv(h,x) * paso;

% Gráfico de la respuesta
figure;
t_y=(t1(1) + t2(1)) : paso : (t1(end) + t2(end))
plot(t_y, y);
xlabel('Tiempo (t)');
ylabel('y(t)');
title('Respuesta de Estado Cero y(t) = x(t) * h(t)');
grid on;