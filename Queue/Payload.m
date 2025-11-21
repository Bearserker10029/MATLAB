% Tarea 4 - PMF del tamaño de paquete MAC
rng(20202132) % Semilla

% Paso 1: Simulación de la VA Y (exponencial) mediante transformada inversa
media = 458;
lambda = 1/media;
N = 1e6;
auxUnif = rand(1,N);
Y = (-log(1-auxUnif))/lambda; % VA exponencial simulada

% payload UDP discreto
% Regla: si Y <= 20.5 => Z=20, si no => redondeo al bin más cercano
Z = zeros(1,N);
for k = 1:N
    if Y(k) <= 20.5
        Z(k) = 20;
    else
        Z(k) = floor(Y(k) + 0.5); % redondeo
    end
end

% tamaño MAC con fragmentación
overhead = 42;             % overhead primer fragmento
overheadFragmentos = 34;   % overhead fragmentos siguientes
X = zeros(1,N);

for k = 1:N
    if Z(k) <= 1472
        % Paquete sin fragmentación
        X(k) = Z(k) + overhead;
    else
        % Paquete fragmentado
        aux = Z(k); % tamaño restante del payload
        esPrimerFragmento = 1;
        while aux > 1472
            if esPrimerFragmento == 1
                X(k) = X(k) + 1472 + overhead;
                esPrimerFragmento = 0;
            else
                X(k) = X(k) + 1472 + overheadFragmentos;
            end
            aux = aux - 1472;
        end
        % Fragmento final
        if aux < 26
            X(k) = X(k) + 26 + overheadFragmentos;
        else
            X(k) = X(k) + aux + overheadFragmentos;
        end
    end
end

% Paso 3: Construcción de la PMF mediante histograma
binSize = 1; % bins de 1 byte
dominio = 1:binSize:max(X);
histogram_output = histogram(X, dominio);
binCounts = histogram_output.BinCounts;
binEdges = histogram_output.BinEdges;
PMF = binCounts / (binSize * N);

% Gráfica de la PMF
figure
plot(binEdges(1:end-1), PMF);
xlabel('Tamaño MAC (bytes)');
ylabel('Probabilidad');
title('PMF del tamaño MAC');
grid on;

% Paso 4: Cálculo de E[X] y E[X^2]
Ex = 0;
Ex2 = 0;
for k = 1:length(PMF)
    Ex = Ex + PMF(k) * binEdges(k);
    Ex2 = Ex2 + PMF(k) * (binEdges(k)^2);
end

fprintf('E[X] (sumatoria) = %.2f bytes\n', Ex);

fprintf('E[X^2] (sumatoria) = %.2f bytes^2\n', Ex2);
