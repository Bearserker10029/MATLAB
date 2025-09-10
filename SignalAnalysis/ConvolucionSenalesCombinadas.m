clear all;
close all;
t1=0:0.01:5
h1=cos(pi*t1)
plot(t1,h1)
title("h1")

h2=2.*exp(-2*t1)
plot(t1,h2)
title("h2")

t=0:0.01:10
x=heaviside(t)-heaviside(t-5)
plot(t,x)
title("x")

z1=conv(x,h1,"same").*0.01

z2=conv(x,h2,"same").*0.01

z=z1+z2
plot(t,z, Color="red"), grid minor
title("z(t)")
