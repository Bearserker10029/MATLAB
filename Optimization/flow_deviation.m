function [best_sol, cost_evol] = flow_deviation(rate, delta)
    % Algoritmo de Flow Deviation para optimización de rutas
    % Inputs: rate (tráfico total en pps), delta (paso de tráfico a mover)
    % Outputs: mejor solución encontrada y evolución del costo
    
    C_A = 5e6;
    C_B = 4e6;
    C_C = 3e6;
    capacidades = [C_A, C_B, C_C];
    cap_total = sum(capacidades);
    
    % Verificación de factibilidad
    if rate >= cap_total
        error('El rate excede la capacidad total de la red');
    end
    
    % PASO 1: Evaluar cada ruta por separado
    fprintf('\n=== PASO 1: Evaluando rutas individuales ===\n');
    
    % Probar ruta A
    lambda_A = [rate, 0, 0];
    costo_A = number_of_packets(lambda_A(1), lambda_A(2), lambda_A(3));
    fprintf('Ruta A: costo = %f\n', costo_A);
    
    % Probar ruta B
    lambda_B = [0, rate, 0];
    costo_B = number_of_packets(lambda_B(1), lambda_B(2), lambda_B(3));
    fprintf('Ruta B: costo = %f\n', costo_B);
    
    % Probar ruta C
    lambda_C = [0, 0, rate];
    costo_C = number_of_packets(lambda_C(1), lambda_C(2), lambda_C(3));
    fprintf('Ruta C: costo = %f\n', costo_C);
    
    % Revisar si alguna ruta individual es factible
    if isinf(costo_A) && isinf(costo_B) && isinf(costo_C)
        % Ninguna ruta soporta todo el tráfico
        fprintf('\nAlta intensidad de tráfico detectada\n');
        fprintf('Se requiere distribuir entre múltiples rutas\n');
        
        % Distribución proporcional a las capacidades
        best_sol = rate * (capacidades / cap_total);
        best_cost = number_of_packets(best_sol(1), best_sol(2), best_sol(3));
        ruta_inicial = 0;
        
        fprintf('Distribución inicial:\n');
        fprintf('  Ruta A: %.2f pps (%.1f%%)\n', best_sol(1), 100*best_sol(1)/rate);
        fprintf('  Ruta B: %.2f pps (%.1f%%)\n', best_sol(2), 100*best_sol(2)/rate);
        fprintf('  Ruta C: %.2f pps (%.1f%%)\n', best_sol(3), 100*best_sol(3)/rate);
        fprintf('  Costo: %.4f\n', best_cost);
    else
        % Seleccionar mejor ruta individual
        [best_cost, ruta_inicial] = min([costo_A, costo_B, costo_C]);
        
        if ruta_inicial == 1
            best_sol = lambda_A;
            fprintf('Mejor opción: Ruta A\n');
        elseif ruta_inicial == 2
            best_sol = lambda_B;
            fprintf('Mejor opción: Ruta B\n');
        else
            best_sol = lambda_C;
            fprintf('Mejor opción: Ruta C\n');
        end
    end
    
    cost_evol = best_cost;
    fprintf('Costo inicial: %f\n', best_cost);
    
    % PASO 2: Intentar redistribuir tráfico
    if ruta_inicial > 0
        fprintf('\n=== PASO 2: Moviendo tráfico ===\n');
        
        [hay_mejora, sol_nueva, costo_nuevo] = probar_redistribucion_inicial(best_sol, delta, ruta_inicial);
        
        if ~hay_mejora
            fprintf('No hay mejora posible\n');
            fprintf('Solución óptima: λ_A=%f, λ_B=%f, λ_C=%f, Costo=%f\n', ...
                best_sol(1), best_sol(2), best_sol(3), best_cost);
            return;
        end
        
        ruta_aumentada = encontrar_ruta_aumentada(best_sol, sol_nueva);
        best_sol = sol_nueva;
        best_cost = costo_nuevo;
        cost_evol = [cost_evol, best_cost];
        iter_inicio = 3;

    else
        % Comenzamos con distribución multipath
        fprintf('\n=== Optimizando distribución ===\n');
        ruta_aumentada = -1;
        iter_inicio = 2;
    end
    
    % PASO 3 y 4: Iteraciones de optimización
    iter = iter_inicio;
    contador_sin_mejora = 0;
    limite_sin_mejora = 10;
    
    while true
        if mod(iter, 10) == 0 || iter < 10
            fprintf('Iteración %d\n', iter);
        end
        
        [hay_mejora, sol_nueva, costo_nuevo] = intentar_mejora(best_sol, delta, ruta_aumentada);
        
        if ~hay_mejora
            contador_sin_mejora = contador_sin_mejora + 1;
            
            if contador_sin_mejora >= limite_sin_mejora
                fprintf('\nConvergencia alcanzada (sin mejora por %d iteraciones)\n', limite_sin_mejora);
                fprintf('Iteraciones totales: %d\n', iter - limite_sin_mejora);
                fprintf('Solución final:\n');
                fprintf('  Ruta A: %.2f pps\n', best_sol(1));
                fprintf('  Ruta B: %.2f pps\n', best_sol(2));
                fprintf('  Ruta C: %.2f pps\n', best_sol(3));
                fprintf('  Costo: %.4f\n', best_cost);
                break;
            end
            
            ruta_aumentada = -1;
            cost_evol = [cost_evol, best_cost];
        else
            contador_sin_mejora = 0;
            
            ruta_aumentada = encontrar_ruta_aumentada(best_sol, sol_nueva);
            best_sol = sol_nueva;
            best_cost = costo_nuevo;
            cost_evol = [cost_evol, best_cost];
            
            if mod(iter, 10) == 0 || iter < 10
                fprintf('  Mejora encontrada: costo = %.4f\n', best_cost);
            end
        end
        
        iter = iter + 1;
        
        if iter > 10000
            fprintf('\nLímite máximo de iteraciones\n');
            break;
        end
    end
end

function [mejora, mejor_sol, mejor_costo] = probar_redistribucion_inicial(sol_actual, delta, ruta_origen)
    costo_actual = number_of_packets(sol_actual(1), sol_actual(2), sol_actual(3));
    mejor_sol = sol_actual;
    mejor_costo = costo_actual;
    mejora = false;
    
    caps = [5e6, 4e6, 3e6];
    
    % Probar mover tráfico desde la ruta inicial
    for destino = 1:3
        if ruta_origen == destino
            continue;
        end
        
        sol_prueba = sol_actual;
        sol_prueba(ruta_origen) = sol_prueba(ruta_origen) - delta;
        sol_prueba(destino) = sol_prueba(destino) + delta;
        
        if sol_prueba(ruta_origen) < 0 || sol_prueba(destino) >= caps(destino)
            continue;
        end
        
        costo_prueba = number_of_packets(sol_prueba(1), sol_prueba(2), sol_prueba(3));
        
        if ~isinf(costo_prueba) && costo_prueba < mejor_costo
            mejor_sol = sol_prueba;
            mejor_costo = costo_prueba;
            mejora = true;
        end
    end
end

function [mejora, mejor_sol, mejor_costo] = intentar_mejora(sol_actual, delta, ruta_excluida)
    costo_actual = number_of_packets(sol_actual(1), sol_actual(2), sol_actual(3));
    mejor_sol = sol_actual;
    mejor_costo = costo_actual;
    mejora = false;
    
    caps = [5e6, 4e6, 3e6];
    
    for origen = 1:3
        if origen == ruta_excluida
            continue;
        end
        
        if sol_actual(origen) < delta
            continue;
        end
        
        for destino = 1:3
            if origen == destino
                continue;
            end
            
            sol_prueba = sol_actual;
            sol_prueba(origen) = sol_prueba(origen) - delta;
            sol_prueba(destino) = sol_prueba(destino) + delta;
            
            if sol_prueba(destino) >= caps(destino)
                continue;
            end
            
            costo_prueba = number_of_packets(sol_prueba(1), sol_prueba(2), sol_prueba(3));
            
            if ~isinf(costo_prueba) && costo_prueba < mejor_costo
                mejor_sol = sol_prueba;
                mejor_costo = costo_prueba;
                mejora = true;
            end
        end
    end
end

function ruta = encontrar_ruta_aumentada(sol_anterior, sol_nueva)
    diferencia = sol_nueva - sol_anterior;
    [valor_max, ruta] = max(diferencia);
    
    if valor_max <= 0
        ruta = -1;
    end
end
