clc, clear all
x = [1,2,2,1];
N = length(x);
for k=0:N-1
    for n=0:N-1
        X(n+1)=x(n+1)*exp(-1j*2*pi*k*n/N);
    end
    Xk(k+1)=sum(X);
end
Xk

% magnitud
mag = abs(Xk);
figure(1)
stem(0:N-1,mag,'filled','linewidth',2)
legend('|X_k|')
xlim([-0.5, 3.5]), ylim([-0.5,6.5])

% fase
fase = angle(Xk);
figure(2)
stem(0:N-1,fase,'filled','linewidth',2)
legend('\angle X_k')
xlim([-0.5, 3.5]), ylim([-3,3])

