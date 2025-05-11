t = -2:0.01:10;

% Definir cada segmento
idx1 = (t < -1);
y(idx1) = 0;

idx2 = (-1 <= t) & (t <= 0.5);
y(idx2) = 0.6 - 0.6*exp(-t(idx2) - 1);

idx3 = (0.5 <= t) & (t <= 3);
y(idx3) = 0.3*exp (-t(idx3) + 0.5) - 0.6*exp(-t(idx3) - 1) + 0.3;

idx4 = (t > 3);
y(idx4) = 0.3*exp(-t(idx4) + 0.5) - 0.6*exp(-t(idx4) - 1) + 0.3*exp(-t(idx4) + 3);

plot(t, y);
xlabel('t');
ylabel('y(t)');
title('Señal y(t)');