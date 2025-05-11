clear
close all
paso = 0.01;

% ----- Señal x(t) -----
t1 = 0:paso:1-paso;
x1 = zeros(size(t1)); % x = 0 antes de t = 1

t2 = 1:paso:3;
x2 = t2;              % x = t entre 1 y 3

t3 = 3+paso:paso:5;
x3 = ones(size(t3));  % x = 1 entre 3 y 5


x = [x1, x2, x3];

% ----- Respuesta al impulso h(t) = e^(-t)(u(t-1) - u(t-3)) -----
th1 = 0:paso:1-paso;
h1 = zeros(size(th1)); % h = 0 antes de t = 1

th2 = 1:paso:3;
h2 = exp(-th2);        % h = e^(-t) entre 1 y 3

th3 = 3+paso:paso:5;
h3 = zeros(size(th3)); % h = 0 después de t = 3

h = [h1, h2, h3];

% ----- Convolución -----
y = conv(x, h) * paso;

% ----- Tiempo para y(t) -----
tiempo_y = 0:paso:10;

% ----- Gráficos -----
figure;
plot(tiempo_y, y,'LineWidth', 1.5);
xlabel('t'); ylabel('y(t)');
title('Salida del sistema y(t) = x(t) * h(t)');
grid on;