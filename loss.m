% For reproducibility, fix the seed.
% rand("state", 17);
% randn("state", 17);
[P, L, X1, X2, S] = GenerateLabeledPairsFromNormalDistribution(0.5, 4, 16, 2);
verbose = true;
rho = 0;
% Compute the value of lambda so that negatives examples have less effect on the cost.
lambda = nnz(S) / (rows(S) - nnz(S))
regularization = 0.5;
k = 10;
bits = 3;
iterations = 5;

% Take the best solution of several optimization
best_params = HyperModel_BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations);

% Analysis of the binary codes
fprintf("\n------ Analysis ------\n");
HyperModel_LabeledPairsAnalyse(X1, X2, best_params, S, k, rho);
% Histogram of the activations. The activations should be near to 0 or 1
HyperModel_ActivationHistogram(P, best_params, k, 20);
% A Scatter plot of the points and the hyperplanes of the hash functions
HyperModel_DisplayHashFunctions(P, L, best_params);
