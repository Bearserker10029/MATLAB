clc; clear; close all;

%% 1. PARÁMETROS Y DATOS DEL LABORATORIO
Mu = 2500; % Tasa de servicio (pps) 

% Tasa de llegadas real (lambda)
lambda_MM1_exp = [1107.3858, 1497.0978, 1869.2043, 1939.5990, 1996.4561, 2028.2904];
% Tiempo de espera en cola experimental (W)
W_MM1_exp = [0.0000983, 0.0002170, 0.0005671, 0.0007037, 0.0008330, 0.0009440];

% Tasa de llegadas real (lambda)
lambda_MD1_exp = [1106.8384, 1493.1351, 1854.1419, 1942.1683, 1981.3346, 2004.8279];
% Tiempo de espera en cola experimental (W)
W_MD1_exp = [0.0000024, 0.0000141, 0.0000777, 0.0001218, 0.0001498, 0.0001702];

%% 2. CÁLCULO DE CURVAS TEÓRICAS
lambda_teorica = linspace(1000, 2490, 200);

% Fórmula Teórica M/M/1: W = lambda / (mu * (mu - lambda))
W_MM1_teorica = lambda_teorica ./ (Mu .* (Mu - lambda_teorica));

% Fórmula Teórica M/D/1: W = lambda / (2 * mu * (mu - lambda))
W_MD1_teorica = lambda_teorica ./ (2 * Mu .* (Mu - lambda_teorica));

%% 3. GRAFICAR 

% Comparación Experimental M/M/1 vs M/D/1
figure(1);
plot(lambda_MM1_exp, W_MM1_exp, '-bo', 'LineWidth', 1.5, 'MarkerFaceColor', 'b'); hold on;
plot(lambda_MD1_exp, W_MD1_exp, '-rs', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
title('M/M/1 vs M/D/1');
xlabel('Tasa de Llegadas \lambda (pps)');
ylabel('Tiempo de Espera W (s)');
legend('M/M/1 Experimental', 'M/D/1 Experimental', 'Location', 'NorthWest');
grid on;

% M/D/1 Experimental vs Teórica
figure(2);
% Curva teórica: Línea continua
plot(lambda_teorica, W_MD1_teorica, 'k-', 'LineWidth', 2); hold on;
% Valores medidos: Símbolo '+' SIN LÍNEA 
plot(lambda_MD1_exp, W_MD1_exp, 'r+', 'MarkerSize', 10, 'LineWidth', 2);
title('M/D/1 Experimental vs Teórico');
xlabel('Tasa de Llegadas \lambda (pps)');
ylabel('Tiempo de Espera W (s)');
legend('M/D/1 Teórico (K-P)', 'M/D/1 Experimental (+)', 'Location', 'NorthWest');
grid on;

% M/M/1 Experimental vs Teórica
% Curva teórica: Línea continua
plot(lambda_teorica, W_MM1_teorica, 'k-', 'LineWidth', 2); hold on;
% Valores medidos: Símbolo '+' SIN LÍNEA
plot(lambda_MM1_exp, W_MM1_exp, 'b+', 'MarkerSize', 10, 'LineWidth', 2);
title('M/M/1 Experimental vs Teórico');
xlabel('Tasa de Llegadas \lambda (pps)');
ylabel('Tiempo de Espera W (s)');
legend('M/M/1 Teórico', 'M/M/1 Experimental (+)', 'Location', 'NorthWest');
grid on;

%% 4. ANÁLISIS DE RATIOS
fprintf('--- ANÁLISIS DE RESULTADOS ---\n');
fprintf('Comparación para el último punto (Lambda aprox 2000 pps):\n');
fprintf('W Experimental M/M/1: %.7f s\n', W_MM1_exp(end));
fprintf('W Experimental M/D/1: %.7f s\n', W_MD1_exp(end));
ratio = W_MD1_exp(end) / W_MM1_exp(end);
fprintf('Ratio Exp (M/D/1 sobre M/M/1): %.4f (Teoría predice 0.5)\n', ratio);