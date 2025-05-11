clc
clear
close all
paso=0.01;
t1 = -1:paso:0.5;
x1 = 0.6*ones(size(t1));
t2 = 0.5+paso:paso:3;
x2 = 0.3*ones(size(t2));
t3 = 3+paso:paso:10;
x3=zeros(size(t3));
x = [x1,x2,x3];

t1 = -1:paso :- paso;
t2 = 0:paso:10;
h1 = zeros(size(t1));
h2 = exp(-t2);
h = [h1,h2];
y = conv(x,h)*paso;
plot(-2:0.01:20,y), grid on