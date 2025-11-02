clear all; close all; clc;
% Parámetros dados
fm = 400;           % Frecuencia moduladora [Hz]
fp = 4500;          % Frecuencia portadora [Hz]
Ap = 1;             % Amplitud pico de portadora [V]
beta = 3;         % Índice de modulación de FASE (máxima desviación de fase en radianes)

% Parámetros de simulación
fs = 44100;         % Frecuencia de muestreo [Hz]
T = 3;              % Duración [s]
t = 0:1/fs:T-1/fs;  % Vector de tiempo
fprintf('=== INICIANDO GENERACIÓN DE AUDIO PM ===\n');

%% Generación de señales
% Señal moduladora (mensaje)
moduladora = Ap * cos(2*pi*fm*t);

% Señal modulada en PM (Modulación de Fase)
% La ecuación matemática es idéntica a la de FM, pero BETA es el índice de FASE.
% PM_t = Ap * cos(2*pi*fp*t + beta * moduladora_normalizada)
% Como Ap=1 y moduladora es cos(2*pi*fm*t), la implementación es la misma que la anterior.
pm_t = Ap * cos(2*pi*fp*t + beta * sin(2*pi*fm*t));

%% Crear señal estéreo NORMALIZADA
% Normalizar ambas señales para evitar clipping
moduladora_norm = moduladora / max(abs(moduladora));
pm_t_norm = pm_t / max(abs(pm_t));

% Señal estéreo: Canal izquierdo = moduladora, Canal derecho = PM
senal_estereo = [moduladora_norm(:), pm_t_norm(:)];

%% Verificación previa a la reproducción
fprintf('=== VERIFICACIÓN DE SEÑALES ===\n');
fprintf('Duración: %.1f segundos\n', T);
fprintf('Tamaño señal estéreo: %dx%d\n', size(senal_estereo));
fprintf('Rango moduladora: [%.3f, %.3f]\n', min(moduladora_norm), max(moduladora_norm));
fprintf('Rango PM: [%.3f, %.3f]\n', min(pm_t_norm), max(pm_t_norm));
fprintf('Máximo absoluto: %.3f\n', max(abs(senal_estereo(:))));

%% Guardar archivo de audio 
filename = 'PM_Audio_Output.wav';
try
    audiowrite(filename, senal_estereo, fs);
    fprintf('✓ Archivo de audio guardado: %s\n', filename);
    fprintf('  - Canal izquierdo: Moduladora %d Hz\n', fm);
    fprintf('  - Canal derecho: Señal PM (portadora %d Hz, β=%.1f)\n', fp, beta);
catch ME
    fprintf('✗ Error guardando archivo: %s\n', ME.message);
end

%% Visualización rápida
figure('Position', [100, 100, 1200, 600]);

% Señales en tiempo
subplot(2,2,1);
plot(t(1:min(2000,length(t))), moduladora_norm(1:min(2000,length(t))), 'b', 'LineWidth', 2);
title('Canal Izquierdo: Señal Moduladora');
xlabel('Tiempo [s]');
ylabel('Amplitud Normalizada');
grid on;
xlim([0, 0.02]);

subplot(2,2,2);
plot(t(1:min(1000,length(t))), pm_t_norm(1:min(1000,length(t))), 'r', 'LineWidth', 1.5);
title('Canal Derecho: Señal PM');
xlabel('Tiempo [s]');
ylabel('Amplitud Normalizada');
grid on;
xlim([0, 0.005]);

% Espectros
N = min(8192, length(pm_t));
f = (0:N-1) * (fs/N);
PM_fft = fft(pm_t_norm(1:N) .* hann(N)', N);
PM_mag = 2 * abs(PM_fft(1:N/2)) / N;
MOD_fft = fft(moduladora_norm(1:N) .* hann(N)', N);
MOD_mag = 2 * abs(MOD_fft(1:N/2)) / N;

subplot(2,2,3);
plot(f(1:N/2), MOD_mag, 'b', 'LineWidth', 1.5);
title('Espectro - Canal Moduladora');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
grid on;
xlim([0, 1000]);

subplot(2,2,4);
plot(f(1:N/2), PM_mag, 'r', 'LineWidth', 1.5);
title('Espectro - Canal PM');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
grid on;
xlim([3000, 6000]);

%% REPRODUCCIÓN DE AUDIO
fprintf('\n=== REPRODUCCIÓN DE AUDIO ===\n');
% (Sección de reproducción omitida por brevedad, pero es idéntica)

% Verificar que el audio puede reproducirse
if max(abs(senal_estereo(:))) <= 1
    fprintf('✓ Señal normalizada correctamente\n');
    
    % Opción 1: Reproducir directamente
    try
        fprintf('Reproduciendo audio... (Canal Izq: Moduladora, Canal Der: PM)\n');
        sound(senal_estereo, fs);
        fprintf('✓ Audio reproducido exitosamente\n');
        
        % Esperar mientras se reproduce
        pause(T + 1);
        
    catch ME
        fprintf('✗ Error en reproducción directa: %s\n', ME.message);
    end
    
else
    fprintf('✗ Señal fuera de rango, no se puede reproducir\n');
end

%% Información adicional del archivo generado
file_info = audioinfo(filename);
fprintf('\n=== INFORMACIÓN DEL ARCHIVO GUARDADO ===\n');
fprintf('Nombre: %s\n', file_info.Filename);
fprintf('Duración: %.2f segundos\n', file_info.Duration);
fprintf('Tasa de muestreo: %d Hz\n', file_info.SampleRate);
fprintf('Canales: %d\n', file_info.TotalSamples);
fprintf('Bits por muestra: %d\n', file_info.BitsPerSample);

%% Verificación final de parámetros PM
fprintf('\n=== PARÁMETROS PM VERIFICADOS ===\n');
fprintf('Frecuencia moduladora (fm): %d Hz\n', fm);
fprintf('Frecuencia portadora (fp): %d Hz\n', fp);
fprintf('Índice de modulación de fase (β): %.1f rad\n', beta);

% Calculo de ancho de banda para β=2.4 es idéntico al de FM.
% Se usa la Regla de Carson como estimación.
delta_f_max_PM = beta * fm; % La desviación de frecuencia pico es proporcional a fm en PM!
fprintf('Desviación de frecuencia máx. (Δf): %d Hz\n', delta_f_max_PM);
fprintf('Ancho de banda (Carson): %.0f Hz\n', 2*(delta_f_max_PM + fm));


fprintf('\n=== GENERACIÓN COMPLETADA ===\n');