% Calculo de la FFT de una onda senoidal
clear;
close all;
Fs = 15000; 
t = (0:1/Fs:1); 
f = 1000; % frecuencia de la onda senoidal en Hz
x=sin(2*pi*f*t); %onda senoidal
 
figure(1);
plot(t/100,x);
title('Señal');
xlabel('Tiempo (s)');
ylabel('Amplitud ');
sound(x,Fs);

nfft = 2^nextpow2(length(x)); % el numero de puntos para fft
my = abs(fft(x,nfft))/length(x); %FFT de la señal
f = (0:Fs/nfft:Fs-Fs/nfft);  %construccion del vector de frecuencias
 
figure(2);
plot(f,my);
title('Espectro de la señal');
xlabel('Frecuencia (Hz)');
ylabel('Amplitud');
axis([0,1500,0,1]);