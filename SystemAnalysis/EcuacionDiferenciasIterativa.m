clc
close all

n= -2:20;

x=3.^n.*(n>=0);

y(2) = 3;
y(1) = 2;

for k = 3:length(n)
    y(k) = x(k) + 3.*x(k-1) + 3.*x(k-2) - 3.*y(k-1) - 2.*y(k-2);
end

y_1=y(3:length(n))

stem(0:20,y_1,"filled");
xlabel("n");
ylabel("y[n]");
grid minor;