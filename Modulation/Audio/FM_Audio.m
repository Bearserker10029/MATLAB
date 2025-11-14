clear all; close all; clc;

% Parámetros dados
fm = 30000;           % Frecuencia moduladora [Hz]
fp = 1000000;          % Frecuencia portadora [Hz]
Ap = 3;             % Amplitud pico de portadora [V]
beta = 4;           % Índice de modulación
delta_f = beta * fm; % Desviación máxima de frecuencia [Hz]

% Parámetros de simulación CORREGIDOS para audio
fs = 44100;         % Frecuencia de muestreo [Hz]
T = 3;              % Duración [s] - aumentada para mejor audición
t = 0:1/fs:T-1/fs;  % Vector de tiempo

fprintf('=== INICIANDO GENERACIÓN DE AUDIO FM ===\n');

%% Generación de señales
% Señal moduladora (mensaje)
moduladora = Ap * cos(2*pi*fm*t);

% Señal modulada en FM (implementación más estable)
fm_t = Ap * cos(2*pi*fp*t + beta * sin(2*pi*fm*t));

%% Crear señal estéreo NORMALIZADA
% Normalizar ambas señales para evitar clipping
moduladora_norm = moduladora / max(abs(moduladora));
fm_t_norm = fm_t / max(abs(fm_t));

% Señal estéreo: Canal izquierdo = moduladora, Canal derecho = FM
senal_estereo = [moduladora_norm(:), fm_t_norm(:)];

%% Verificación previa a la reproducción
fprintf('=== VERIFICACIÓN DE SEÑALES ===\n');
fprintf('Duración: %.1f segundos\n', T);
fprintf('Tamaño señal estéreo: %dx%d\n', size(senal_estereo));
fprintf('Rango moduladora: [%.3f, %.3f]\n', min(moduladora_norm), max(moduladora_norm));
fprintf('Rango FM: [%.3f, %.3f]\n', min(fm_t_norm), max(fm_t_norm));
fprintf('Máximo absoluto: %.3f\n', max(abs(senal_estereo(:))));

%% Guardar archivo de audio 
filename = 'FM_Audio_Output.wav';
try
    audiowrite(filename, senal_estereo, fs);
    fprintf('✓ Archivo de audio guardado: %s\n', filename);
    fprintf('  - Canal izquierdo: Moduladora %d Hz\n', fm);
    fprintf('  - Canal derecho: Señal FM (portadora %d Hz, β=%.1f)\n', fp, beta);
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
plot(t(1:min(1000,length(t))), fm_t_norm(1:min(1000,length(t))), 'r', 'LineWidth', 1.5);
title('Canal Derecho: Señal FM');
xlabel('Tiempo [s]');
ylabel('Amplitud Normalizada');
grid on;
xlim([0, 0.005]);

% Espectros
N = min(8192, length(fm_t));
f = (0:N-1) * (fs/N);

FM_fft = fft(fm_t_norm(1:N) .* hann(N)', N);
FM_mag = 2 * abs(FM_fft(1:N/2)) / N;

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
plot(f(1:N/2), FM_mag, 'r', 'LineWidth', 1.5);
title('Espectro - Canal FM');
xlabel('Frecuencia [Hz]');
ylabel('Magnitud');
grid on;
xlim([3000, 6000]);

%% REPRODUCCIÓN DE AUDIO
fprintf('\n=== REPRODUCCIÓN DE AUDIO ===\n');

% Verificar que el audio puede reproducirse
if max(abs(senal_estereo(:))) <= 1
    fprintf('✓ Señal normalizada correctamente\n');
    
    % Opción 1: Reproducir directamente
    try
        fprintf('Reproduciendo audio... (Canal Izq: Moduladora, Canal Der: FM)\n');
        sound(senal_estereo, fs);
        fprintf('✓ Audio reproducido exitosamente\n');
        
        % Esperar mientras se reproduce
        pause(T + 1);
        
    catch ME
        fprintf('✗ Error en reproducción directa: %s\n', ME.message);
        fprintf('Intentando reproducción alternativa...\n');
        
        % Opción alternativa: reproducir canales por separado
        sound(moduladora_norm, fs);
        pause(T + 1);
        sound(fm_t_norm, fs);
    end
    
else
    fprintf('✗ Señal fuera de rango, no se puede reproducir\n');
    fprintf('Máximo detectado: %.3f (debe ser ≤ 1.0)\n', max(abs(senal_estereo(:))));
end

%% Información adicional del archivo generado
file_info = audioinfo(filename);
fprintf('\n=== INFORMACIÓN DEL ARCHIVO GUARDADO ===\n');
fprintf('Nombre: %s\n', file_info.Filename);
fprintf('Duración: %.2f segundos\n', file_info.Duration);
fprintf('Tasa de muestreo: %d Hz\n', file_info.SampleRate);
fprintf('Canales: %d\n', file_info.TotalSamples);
fprintf('Bits por muestra: %d\n', file_info.BitsPerSample);
fprintf('Tamaño: %.2f MB\n', file_info.TotalSamples * file_info.BitsPerSample / (8 * 1024 * 1024));

%% Verificación final de parámetros FM
fprintf('\n=== PARÁMETROS FM VERIFICADOS ===\n');
fprintf('Frecuencia moduladora (fm): %d Hz\n', fm);
fprintf('Frecuencia portadora (fp): %d Hz\n', fp);
fprintf('Índice de modulación (β): %.1f\n', beta);
fprintf('Desviación de frecuencia (Δf): %d Hz\n', delta_f);
fprintf('Ancho de banda (Carson): %.0f Hz\n', 2*(delta_f + fm));

%% Instrucciones para el usuario
fprintf('\n=== INSTRUCCIONES ===\n');
fprintf('1. El archivo "FM_Audio_Output.wav" ya está guardado en tu carpeta actual\n');
fprintf('2. Puedes abrirlo con cualquier reproductor de audio\n');
fprintf('3. Usa auriculares para escuchar:\n');
fprintf('   - Oído izquierdo: tono puro de 400 Hz (moduladora)\n');
fprintf('   - Oído derecho: señal FM con variaciones de frecuencia\n');
fprintf('4. Para análisis detallado, carga el archivo en tu osciloscopio virtual\n');

%% Generar comando para cargar en workspace (opcional)
fprintf('\nPara cargar el audio en el workspace de MATLAB, usa:\n');
fprintf('[audio, fs_audio] = audioread(''%s'');\n', filename);
fprintf('sound(audio, fs_audio);\n');

fprintf('\n=== GENERACIÓN COMPLETADA ===\n');