clc; clear; close all; 
% 1. Configuración Inicial 
rate = 3150005.786 ; 
delta = 1000; % El paso de la guía (1 Kpps) 
% Capacidades (para validar que no nos pasemos) 
Cap_A = 5e6; Cap_B = 4e6; Cap_C = 3e6;
% 2. Condiciones Iniciales "malas" (Para ver la evolución en la gráfica) 
lambda_a = 200000; 
lambda_b = 200000; 
lambda_c = rate - lambda_a - lambda_b; %100000.245;
% Guardamos historial del costo para graficar 
historial_costos = [number_of_packets(lambda_a, lambda_b, lambda_c)]; 
fprintf('Iniciando Flow Deviation \n'); 
% 3. Bucle Principal 
while true 
   % Se calcula el costo actual 
   costo_actual = number_of_packets(lambda_a, lambda_b, lambda_c); 
   
   % --- Se evaluan los 6 posibles movimientos --- 
   % Movimientos: AC (A->C), CA (C->A), AB (A->B), BA (B->A), BC (B->C), CB (C->B) 
   % Inicializamos todos con el costo actual (por si no son válidos) 
   costos_vecinos = ones(1,6) * inf; 
   
   % 1. Mover de A -> C 
   if lambda_a >= delta && (lambda_c + delta) < Cap_C 
       costos_vecinos(1) = number_of_packets(lambda_a - delta, lambda_b, lambda_c + delta); 
   end 
   
   % 2. Mover de C -> A 
   if lambda_c >= delta && (lambda_a + delta) < Cap_A 
       costos_vecinos(2) = number_of_packets(lambda_a + delta, lambda_b, lambda_c - delta); 
   end 
   
   % 3. Mover de A -> B 
   if lambda_a >= delta && (lambda_b + delta) < Cap_B 
       costos_vecinos(3) = number_of_packets(lambda_a - delta, lambda_b + delta, lambda_c); 
   end 
   
   % 4. Mover de B -> A 
   if lambda_b >= delta && (lambda_a + delta) < Cap_A 
       costos_vecinos(4) = number_of_packets(lambda_a + delta, lambda_b - delta, lambda_c); 
   end 
   
   % 5. Mover de B -> C 
   if lambda_b >= delta && (lambda_c + delta) < Cap_C 
       costos_vecinos(5) = number_of_packets(lambda_a, lambda_b - delta, lambda_c + delta); 
   end 
   
   % 6. Mover de C -> B 
   if lambda_c >= delta && (lambda_b + delta) < Cap_B 
       costos_vecinos(6) = number_of_packets(lambda_a, lambda_b + delta, lambda_c - delta); 
   end 
   
   % Se Decide el mejor movimiento 
   [min_costo, mejor_movimiento] = min(costos_vecinos);
    % Si se entra un costo menor al actual, se aplica el cambio 
   if min_costo < costo_actual 
       switch mejor_movimiento 
           case 1 % A -> C 
               lambda_a = lambda_a - delta; lambda_c = lambda_c + delta; 
           case 2 % C -> A 
               lambda_a = lambda_a + delta; lambda_c = lambda_c - delta; 
           case 3 % A -> B 
               lambda_a = lambda_a - delta; lambda_b = lambda_b + delta; 
           case 4 % B -> A 
               lambda_a = lambda_a + delta; lambda_b = lambda_b - delta; 
           case 5 % B -> C 
               lambda_b = lambda_b - delta; lambda_c = lambda_c + delta; 
           case 6 % C -> B 
               lambda_b = lambda_b + delta; lambda_c = lambda_c - delta; 
       end 
       
       % Guardamos el nuevo costo en el historial 
       historial_costos(end+1) = min_costo; 
   else 
       % Si ningun vecino es mejor, terminamos (Óptimo local alcanzado) 
       break; 
   end 
end 
% 4. Resultados y Graficar 
fprintf('Optimización terminada en %d pasos.\n', length(historial_costos)); 
fprintf('Distribución Final: A=%.4f, B=%.4f, C=%.4f\n', lambda_a, lambda_b, lambda_c); 
fprintf('Costo Final: %.4f\n', historial_costos(end)); 
figure; 
%plot(historial_costos,'o'); % Para mostrar un solo punto 
plot(historial_costos, 'LineWidth', 2); 
xlabel('Pasos'); 
ylabel('Paquetes en el sistema'); 
title('Evolución del Costo (Flow Deviation)'); 
grid on; 