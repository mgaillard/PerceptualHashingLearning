% Parameter for the training
number_images = 23;
pca = false;
centering = true;
normalization = true;
verbose = true;
rho = 3;
lambda = 1;
regularization = 0.5;
k = 10;
bits = 16;
method = "hyper";
iterations = 1;

% Load features of images
load features/features_base.h5
base = features'(1:number_images, :);

load features/features_blur.h5
blur = features'(1:number_images, :);

load features/features_compress10.h5
compress10 = features'(1:number_images, :);

load features/features_crop10.h5
crop10 = features'(1:number_images, :);

load features/features_gray.h5
gray = features'(1:number_images, :);

load features/features_resize50.h5
resize50 = features'(1:number_images, :);

load features/features_rotate5.h5
rotate5 = features'(1:number_images, :);

features = [base; blur; compress10; crop10; gray; resize50; rotate5];

% PCA
if pca == true
  [pca_coeffs, features] = princomp(features,'econ');
  fprintf("\n------ PCA (size: %d, %d)------\n", size(features));
endif

% Center data
if centering == true
  fprintf("\n------ Centering ------\n");
  features = center(features);
endif

% Normalization
if normalization == true
  fprintf("\n------ Normalization ------\n");
  norms = sqrt(sumsq(features, 2));
  features = features./norms;
endif

% Features are updated
base       = features(1:number_images, :);
blur       = features(  number_images+1:2*number_images, :);
compress10 = features(2*number_images+1:3*number_images, :);
crop10     = features(3*number_images+1:4*number_images, :);
gray       = features(4*number_images+1:5*number_images, :);
resize50   = features(5*number_images+1:6*number_images, :);
rotate5    = features(6*number_images+1:7*number_images, :);


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
codes = HyperModel_Predict(base, best_params, k);
save("-hdf5", "codes/codes_base.h5", "codes");

codes = HyperModel_Predict(blur, best_params, k);
save("-hdf5", "codes/codes_blur.h5", "codes");

codes = HyperModel_Predict(compress10, best_params, k);
save("-hdf5", "codes/codes_compress10.h5", "codes");

codes = HyperModel_Predict(crop10, best_params, k);
save("-hdf5", "codes/codes_crop10.h5", "codes");

codes = HyperModel_Predict(gray, best_params, k);
save("-hdf5", "codes/codes_gray.h5", "codes");

codes = HyperModel_Predict(resize50, best_params, k);
save("-hdf5", "codes/codes_resize50.h5", "codes");

codes = HyperModel_Predict(rotate5, best_params, k);
save("-hdf5", "codes/codes_rotate5.h5", "codes");