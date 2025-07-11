clear all
close all

num=[2 5 0 -4];
den=[1 0 -5 0 4];
[r,p,k]=residue(num,den)

for i=1:length(r)
    rats(r(i))
end

for i=1:length(p)
    rats(p(i))
end
%% 
clear all
close all
syms x n 

f= exp(j*x*(n+1))+exp(j*x*(n-1));

int(f,x)
int(f,x,-pi/2,pi/2)*1/(4*pi)
%% 
clear all
close all
syms t n 
f= (dirac(t+1/2)-dirac(t-1/2))*exp(-j*pi*t*n);

int(f,t)
4*int(f,t,-1,1)
%% 
clear all
close all

syms t w
x=2*(exp(3*j*t)+exp(-j*3*t));
fourierTransform = fourier(x,t,w)

y=subs(x, t, (2-t)) + subs(x, t, (-2-t));

fourierTransform1 = fourier(y,t,w)

z=subs(x,t,3*t+5);

fourierTransform2 = fourier(z,t,w)

%%
clear all
close all

syms n z

x=(1/4)^n;

ztrans(x,n,z)
%%
clear all
close all

a=2;
k=-20:20;
x_k=-j*a./(2*pi*k);
x_k(k==0)=a/2;

subplot(2,1,1);
stem(k,abs(x_k));
subplot(2,1,2);
stem(k,angle(x_k));
%%
