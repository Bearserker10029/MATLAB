
clear;
close all;
t1=0:0.01:5
h1=cos(pi*t1).*ones(size(t1))
plot(t1,h1)
title("h1")

t2=0:0.01:5
h2=2.*exp(-2*t2)
plot(t2,h2)
title("h2")

t=0:0.01:5
x=heaviside(t)-heaviside(t-5)
plot(t,x)
title("x")

z1=conv(h1,x).*0.01
plot(0:0.01:10,z1)
title("Convolución de h1 y x")
z2=conv(h2,x).*0.01
plot(0:0.01:10,z2)

title("Convolución de h2 y x")

z=z1+z2
plot(0:0.01:10,z, Color="red"), grid minor
title("z(t)")