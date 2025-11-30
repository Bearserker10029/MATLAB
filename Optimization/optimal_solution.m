function [lambda_a, lambda_b, lambda_c] = optimal_solution(R)
    if R == 0
        lambda_a = 0;
        lambda_b = 0;
        lambda_c = 0;
        return;
    end
    ub = [5e6, 4e6, 3e6];
    total_cap = sum(ub);
    
    if R > total_cap
        error('R = %g excede la capacidad total de %g. No hay solución factible.', R, total_cap);
    end
    
    fun = @(x) number_of_packets(x(1), x(2), x(3));
    
    Aeq = [1, 1, 1];
    beq = R;
    
    % Límites inferiores
    lb = [0, 0, 0];
    
    x0 = (R / total_cap) * ub;
    
    problem = createOptimProblem('fmincon', ...
        'objective', fun, ...
        'x0', x0, ...
        'Aeq', Aeq, ...
        'beq', beq, ...
        'lb', lb, ...
        'ub', ub, ...
        'options', optimoptions('fmincon', 'Display', 'off'));
    
    % Utilizar GlobalSearch para encontrar el óptimo global
    gs = GlobalSearch;
    x_opt = run(gs, problem);
    
    % Asignar las salidas individuales
    lambda_a = x_opt(1);
    lambda_b = x_opt(2);
    lambda_c = x_opt(3);
end