clear all
close all
clc
rng(20202132);
% ====================================================== DEFINE PARAMETERS =========================================================
num_samples = 1e6;
binSize = 1;
theoretical_exponential_samples_mean = 2;
% ==================================================================================================================================
lambda = 1/theoretical_exponential_samples_mean;
uniform_samples = rand(1,num_samples);
exponential_samples = -log(1-uniform_samples)/lambda;
experimental_exponential_samples_mean = mean(exponential_samples);
ans_1 = experimental_exponential_samples_mean
% ==================================================================================================================================

figure
bins = 0:binSize:20;
histogram(exponential_samples,bins,'Normalization','pdf');
hold on;
x_values = bins;
theoretical_pdf = lambda * exp(-lambda * x_values);
plot(x_values, theoretical_pdf, 'r-', 'LineWidth', 2);
xlabel('Value');
ylabel('Probability Density');
title(['Histogram of Exponential Samples and Theoretical PDF (', num2str(num_samples), ' samples, linear scale)']);
legend('Experimental Histogram', 'Theoretical PDF');

hold off;

% ==================================================================================================================================

figure
bins = 0:binSize:20;

% calcular pdf experimental
[counts, edges] = histcounts(exponential_samples, bins, 'Normalization','pdf');
binCenters = edges(1:end-1) + diff(edges)/2;

% graficar pdf experimental como curva
plot(binCenters, counts, 'b-', 'LineWidth', 1.5); 
hold on;

% graficar pdf teórica
x_values = linspace(0,20,500);
theoretical_pdf = lambda * exp(-lambda * x_values);
plot(x_values, theoretical_pdf, 'r--', 'LineWidth', 2);

% eje logarítmico
set(gca, 'YScale', 'log');

xlabel('Value');
ylabel('Probability Density (log scale)');
title(['Exponential PDF: Experimental vs Theoretical (', num2str(num_samples), ' samples)']);
legend('Experimental PDF','Theoretical PDF');
grid on
hold off;
%====================================================== END =============================================================
pk= exp(-lambda*(20-binSize))-exp(-lambda*20)
N_samples=10^4/pk;
ratio=num_samples/N_samples;
