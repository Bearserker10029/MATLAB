clc;
clear;
close all;
Fs = 100; % Frecuencia de muestreo
Fc = 10; % Frecuencia de portadora
t = (0:2*Fs+1)'/Fs;

mens = sin(2*pi*t) + sin(4*pi*t);
subplot(3,1,1)
plot(t,mens)
grid
title('Señal Mensaje')

fasedesv = pi/2; % Desviación de fase

mod = pmmod(mens,Fc,Fs,fasedesv); % Modulada
subplot(3,1,2)
plot(t,mod)
grid
title('Señal Modulada en PM')

dem = pmdemod(mod,Fc,Fs,fasedesv); % Demodulada.
subplot(3,1,3)
plot(t,dem)
grid
title('Señal Demodulada')

figure;
plot(t,mens,'k-',t,dem,'g-');
legend('Señal Original','Señal Recuperada');
grid