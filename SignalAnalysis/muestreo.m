clear;
close all;
f=2000; %Modifique 
fso=1e6;
No=fso*1e-3;
to=(0:No-1)/fso;
xo=0.5*sin(2*pi*f*to);
for fs=[44100 22050 11025 8000 5000]
N=fs*1;
t=(0:N-1)/fs;
x=0.5*sin(2*pi*f*t);
%sound(x,fs)
plot(to*1e3,xo,'k',t*1e3,x,'b-o')
axis([0, 1, -1, 1])
legend ('Señal original', 'Señal muestreada')
xlabel('milisegundos')
pause
end