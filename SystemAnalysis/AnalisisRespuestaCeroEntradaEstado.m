clear;
close all;

% Variable simbolica
syms t y(t)
x=cos(t)+t.^3;
ecua=diff(y,2)==4.*diff(y)+5.*diff(x)-2*x;

% Condiciones iniciales
Dy=diff(y);
cond=[y(0)==0,Dy(0)==1];
ySol(t) = dsolve(ecua,cond);
f(t)=simplify(ySol(t));

% Ploteo
figure;
subplot(4,1,1)
fplot(f,[0,10],Color="r",LineWidth=2);
title("Solucion exacta");
xlabel("t"); 
ylabel("y(t)");
grid minor;

% Respuesta de entrada cero
ecuazir=diff(y,2)==4.*diff(y);
condzir=[y(0)==0,Dy(0)==1];
yzir(t) = simplify(dsolve(ecuazir,condzir));
subplot(4,1,2)
fplot(yzir,[0,10],Color="r",LineWidth=2);
title("YZIR");
xlabel("t"); 
ylabel("y(t)");
grid minor;

% Respuesta de estado cero
condzsr=[y(0)==0,Dy(0)==0];
yzsr(t) = simplify(dsolve(ecua,condzsr));
subplot(4,1,3)
fplot(yzsr,[0,10],Color="b",LineWidth=2);
title("YZSR");
xlabel("t"); 
ylabel("y(t)");
grid minor;

% Suma
ysuma= yzsr + yzir;
subplot(4,1,4)
fplot(ysuma,[0,10],Color="g",LineWidth=2);
title("Suma ZIR con ZSR");
xlabel("t"); 
ylabel("y(t)");
grid minor;