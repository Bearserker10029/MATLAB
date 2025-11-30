function nPackets=number_of_packets(lambda_a,lambda_b,lambda_c)
    C_A = 5e6; % Capacidad de A
    C_B = 4e6; % Capacidad de B
    C_C = 3e6; % Capacidad de C
    
    if lambda_a >= C_A || lambda_b >= C_B || lambda_c >= C_C
        nPackets = Inf;
        return;
    end
    
    nPackets = 2*(lambda_a/(C_A-lambda_a)+lambda_a*(12.5*10^-6)) + 2*(lambda_b/(C_B-lambda_b)+lambda_b*(10^-5)) + 2*(lambda_c/(C_C-lambda_c)+lambda_c*(7.5*10^-6));
end