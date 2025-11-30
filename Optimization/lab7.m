clear all
lambda=10^6;
[lambda_a,lambda_b,lambda_c]=optimal_solution(lambda)
%% Problema 1 IF
% 1. Definir el Rate (Cambiar este valor para las siguientes tablas)
R = 500200.245  ; 

% --- SINGLE-PATH A ---
lambda_A_spA = R;
lambda_B_spA = 0;
lambda_C_spA = 0;
cost_spA = number_of_packets(lambda_A_spA, lambda_B_spA, lambda_C_spA);

% --- SINGLE-PATH B ---
lambda_A_spB = 0;
lambda_B_spB = R;
lambda_C_spB = 0;
cost_spB = number_of_packets(lambda_A_spB, lambda_B_spB, lambda_C_spB);

% --- SINGLE-PATH C ---
lambda_A_spC = 0;
lambda_B_spC = 0;
lambda_C_spC = R;
cost_spC = number_of_packets(lambda_A_spC, lambda_B_spC, lambda_C_spC);

% --- OPTIMAL ---
[lambda_A_opt, lambda_B_opt, lambda_C_opt] = optimal_solution(R);
cost_opt = number_of_packets(lambda_A_opt, lambda_B_opt, lambda_C_opt);

% --- MOSTRAR RESULTADOS PARA LLENAR LA TABLA ---
fprintf('--- RESULTADOS PARA R = %f ---\n', R);
fprintf('Single-path A -> Costo: %f\n', cost_spA);
fprintf('Single-path B -> Costo: %f\n', cost_spB);
fprintf('Single-path C -> Costo: %f\n', cost_spC);
fprintf('Optimal -> L_A: %f, L_B: %f, L_C: %f, Costo: %f\n', ...
    lambda_A_opt, lambda_B_opt, lambda_C_opt, cost_opt);

%% 
clear all;
rate = 500200.245 ;
delta = 1000; % 1 Kpps

fprintf('\n========================================\n');
fprintf('Ejecutando Flow Deviation para Rate = %.3f pps\n', rate);
fprintf('========================================\n');

[solucion, costos] = flow_deviation(rate, delta);

% Mostrar solución final
fprintf('\n--- SOLUCIÓN FINAL FLOW DEVIATION ---\n');
fprintf('λ_A = %.3f pps\n', solucion(1));
fprintf('λ_B = %.3f pps\n', solucion(2));
fprintf('λ_C = %.3f pps\n', solucion(3));
fprintf('Costo final = %.6f\n', costos(end));
fprintf('Número de iteraciones = %d\n', length(costos)-1);

% Graficar evolución del costo
figure;
plot(0:length(costos)-1, costos, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iteración', 'FontSize', 12);
ylabel('Costo (número de paquetes)', 'FontSize', 12);
title(sprintf('Evolución del Costo - Flow Deviation (Rate = %.0f pps)', rate), 'FontSize', 14);
grid on;
legend('Costo por iteración', 'Location', 'best');


