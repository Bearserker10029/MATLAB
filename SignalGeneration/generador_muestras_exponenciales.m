clear all
close all
clc
rng(20202132);
% ====================================================== DEFINE PARAMETERS =========================================================
num_samples = 1e6;
binSize = 0.01;
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
histogram(exponential_samples,bins,'Normalization','pdf');
hold on;
x_values = bins;
theoretical_pdf = lambda * exp(-lambda * x_values);
plot(x_values, theoretical_pdf, 'r-', 'LineWidth', 2);
set(gca, 'YScale', 'log');
xlabel('Value');
ylabel('Probability Density');
title(['Histogram of Exponential Samples and Theoretical PDF (', num2str(num_samples), ' samples, log scale)']);
legend('Experimental Histogram', 'Theoretical PDF');

hold off;
% ================================================================ END =============================================================
pk= exp(-lambda*(20-binSize))-exp(-lambda*20)
N_samples=1/pk
ratio=num_samples/N_samples;