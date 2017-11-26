% Parameter for the training
number_images = 25;
pca = false;
centering = true;
normalization = true;
verbose = true;
rho = 3;
lambda = 1;
regularization = 0.0;
k = 0.1;
bits = 16;
method = "hyper";
iterations = 1;
% For reproducibility, fix the seed.
rand("state", 17);
randn("state", 17);

% Load and preprocess features
[features, base, blur, compress10, crop10, gray, resize50, rotate5] = LoadFeatures(number_images, pca, centering, normalization);

% Generate dataset
fprintf("\n------ Triplet generation ------\n");
fflush(stdout);

[P, L, X1, X2, S] = GenerateLabeledPairsFromFeatures(features, number_images);
% Compute the value of lambda so that negatives examples have less effect on the cost.
lambda = nnz(S) / (rows(S) - nnz(S));
fprintf("Lambda=%d\n", lambda);

fprintf("\n------ Training ------\n");
if strcmp(method, "hyper") == 1
  best_params = HyperModel_BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations);
elseif strcmp(method, "lsh") == 1
  best_params = LSH_BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations);
end

% Analysis of the binary codes
fprintf("\n------ Analysis ------\n");
% Histogram of the activations. The activations should be near to 0 or 1
HyperModel_ActivationHistogram(P, best_params, k, 20);
mid_activ = HyperModel_NumberMiddleActivations(P, best_params, k);
fprintf("Middle activation: %d\n", mid_activ);
HyperModel_LabeledPairsAnalyse(X1, X2, best_params, S, k, rho);

% Save binary codes
SaveBinaryCodes(best_params, k, base, blur, compress10, crop10, gray, resize50, rotate5);