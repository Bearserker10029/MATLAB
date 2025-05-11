clear;
close all;
% Señal original
t1 = -2:0.01:4;
x1 = 2*(t1 >= -1.5 & t1 < 0) + 2*exp(-t1/2).*(t1 >= 0 & t1 < 3);
subplot(3,1,1)
plot(t1, x1);
grid minor;
title('x(t)');

% Señal comprimida x(3t)
t2 = -2:0.01:4;
x2 = 2*(3*t2 >= -1.5 & 3*t2 < 0) + 2*exp(-(3*t2)/2).*(3*t2 >= 0 & 3*t2 < 3);
subplot(3,1,2)
plot(t2, x2);
grid minor;
title('x(3t)');

% Señal expandida x(t/2)
t3 = -4:0.01:7;
x3 = 2*(t3/2 >= -1.5 & t3/2 < 0) + 2*exp(-(t3/2)/2).*(t3/2 >= 0 & t3/2 < 3);
subplot(3,1,3);
plot(t3, x3);
grid minor;
title('x(t/2)');