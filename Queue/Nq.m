%% TEL223 - Laboratorio 6 - Informe Final
% Procesamiento de ocupación de cola y cálculo de NQ teórico y experimental

clear; clc; close all;

%% Parámetros
samples_per_interval = 1000; % 10s / 0.01s = 1000 muestras
num_intervals = 19;          % Total de intervalos de 10 segundos
mu = 2500;                   % Tasa de servicio (pps)

%% Cargar datos de las 4 iteraciones

% Lista de archivos
files = {'mm1_2475_1.txt', 'mm1_2475_2.txt', 'mm1_2475_3.txt', 'mm1_2475_4.txt'};
all_data = cell(1, 4);

for k = 1:length(files)
    filename = files{k};
    
    fid = fopen(filename, 'r');
    if fid == -1
        error('No se pudo abrir el archivo %s. Asegúrese de que esté en la ruta correcta.', filename);
    end
    
    % Leer el contenido línea por línea como texto
    data_text = textscan(fid, '%s %s %s', 'Delimiter', ',');
    fclose(fid);
    
    % Concatenar las columnas de texto
    num_rows = length(data_text{1});
    numeric_data = zeros(num_rows, 3);
    
    for i = 1:num_rows
        % Columna 1, 2 y 3 (tiempo, paquetes, bytes)
        for j = 1:3
            str = data_text{j}{i};
            
            str = strtrim(str); 
            
            % Verificar si tiene K o M y convertir
            if ~isempty(str)
                switch lower(str(end))
                    case 'k'
                        value = str2double(str(1:end-1)) * 1000;
                    case 'm'
                        value = str2double(str(1:end-1)) * 1000000;
                    otherwise
                        value = str2double(str);
                end
                
                if isnan(value)
                    value = 0; 
                end
                
                numeric_data(i, j) = value;
            end
        end
    end
    
    rows_to_keep = any(numeric_data, 2); 
    all_data{k} = numeric_data(rows_to_keep, :); 
end

data1 = all_data{1};
data2 = all_data{2};
data3 = all_data{3};
data4 = all_data{4};


%% Función para agrupar y promediar por intervalo
calc_intervals = @(queue_packets) arrayfun(@(i) ...
    mean(queue_packets((i-1)*samples_per_interval+1 : i*samples_per_interval)), ...
    1:num_intervals);

%% Calcular NQ por intervalo en cada iteración
NQ_iter1 = calc_intervals(data1(:,2));
NQ_iter2 = calc_intervals(data2(:,2));
NQ_iter3 = calc_intervals(data3(:,2));
NQ_iter4 = calc_intervals(data4(:,2));

%% Promedio final por intervalo
NQ_matrix = [NQ_iter1(:) NQ_iter2(:) NQ_iter3(:) NQ_iter4(:)]; 
NQ_final = mean(NQ_matrix, 2); % promedio por fila

%% Detección automática de convergencia (sobre promedio global)
threshold = 0.05; % 5% de variación relativa
convergence_interval = 1;

for i = 2:num_intervals-2
    rel_var1 = abs(NQ_final(i) - NQ_final(i-1)) / max(NQ_final(i-1),1);
    rel_var2 = abs(NQ_final(i+1) - NQ_final(i)) / max(NQ_final(i),1);
    rel_var3 = abs(NQ_final(i+2) - NQ_final(i+1)) / max(NQ_final(i+1),1);
    if rel_var1 < threshold && rel_var2 < threshold && rel_var3 < threshold
        convergence_interval = i;
        break;
    end
end

fprintf('\nConvergencia detectada a partir del intervalo %d\n', convergence_interval);

%% Calcular NQ promedio en estado estable para cada run
NQ_run1_stable = mean(NQ_iter1(convergence_interval:end));
NQ_run2_stable = mean(NQ_iter2(convergence_interval:end));
NQ_run3_stable = mean(NQ_iter3(convergence_interval:end));
NQ_run4_stable = mean(NQ_iter4(convergence_interval:end));

fprintf('NQ promedio Run 1 (intervalos %d–%d) = %.4f paquetes\n', ...
    convergence_interval, num_intervals, NQ_run1_stable);
fprintf('NQ promedio Run 2 (intervalos %d–%d) = %.4f paquetes\n', ...
    convergence_interval, num_intervals, NQ_run2_stable);
fprintf('NQ promedio Run 3 (intervalos %d–%d) = %.4f paquetes\n', ...
    convergence_interval, num_intervals, NQ_run3_stable);
fprintf('NQ promedio Run 4 (intervalos %d–%d) = %.4f paquetes\n', ...
    convergence_interval, num_intervals, NQ_run4_stable);

%% NQ promedio global en estado estable
NQ_final_stable = mean(NQ_final(convergence_interval:end));
fprintf('\nNQ promedio global en estado estable (intervalos %d–%d) = %.4f paquetes\n', ...
    convergence_interval, num_intervals, NQ_final_stable);