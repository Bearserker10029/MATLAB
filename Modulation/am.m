%Modulación AM
clc
clear all
fp=2000;
fmu=16000;
fmens=20;
amp=3;%amplitud señal mensaje
t=0:1/fmu:0.5;
port=5*sin(fp*2*pi*t);

grid
mens=amp*sin(fmens*2*pi*t);
subplot(3,1,1)
plot(t,mens);
grid
title('Señal Mensaje')

mod=port+mens;
subplot(3,1,2)
plot(t,mod);
grid
title('Señal Modulada en DSB')


dem=mod;
%Detector de envolvente
[m,n]=size(mod);%Elimina la parte  negativa de la señal
s=m*n;
for i=1:s
    if dem(i)<=0
        dem(i)=0;
    end
end

[num,den] = butter(10,200*2/fmu)
dem=filter(num,den,dem);
%

dem=2*dem-2*2.9; %ajuste de nivel dc y sele da una ganancia de dos
subplot(3,1,3)
plot(t,dem);
grid
title('Señal Demodulada')

figure;
plot(t,mens,'b-',t,dem,'r-');
legend('Señal Original','Señal Recuperada');
grid