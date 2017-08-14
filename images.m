% Parameter for the training
number_images = 50;
centering = true;
pca = false;
rho = 3;
k = 10;
bits = 16;
iterations = 3;

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

[P, L, X1, X2, S] = GenerateTripletsFromFeatures(features, number_images);

fprintf("\n------ Training ------\n");
% Take the best solution of several optimization
best_params = [];
best_cost = Inf;
for i=1:iterations
  fprintf("Iteration: %d/%d\n", i, iterations);
  fflush(stdout);

  % Optimization
  opti_params = TrainModel(X1, X2, S, k, rho, bits);

  % Cost function with true binary codes
  % If the continuous cost at the end of the optimization is less than the real cost,
  % some activations might be near to 0.5 which is not a good value
  real_cost = RealCostFunction(X1, X2, opti_params, S, k, rho);
  
  if real_cost < best_cost
    best_cost = real_cost;
    best_params = opti_params;
  endif
endfor

fprintf("\n------ Best real cost: %d ------\n", best_cost);

% Histogram of the activations. The activations should be near to 0 or 1
ActivationHistogram(P, best_params, k, 20);

% Analysis of the binary codes
fprintf("\n------ Analysis ------\n");
Analyse(X1, X2, best_params, S, k, rho);

% Save binary codes
codes = Predict(base, best_params, k);
save("-hdf5", "codes/codes_base.h5", "codes");

codes = Predict(blur, best_params, k);
save("-hdf5", "codes/codes_blur.h5", "codes");

codes = Predict(compress10, best_params, k);
save("-hdf5", "codes/codes_compress10.h5", "codes");

codes = Predict(crop10, best_params, k);
save("-hdf5", "codes/codes_crop10.h5", "codes");

codes = Predict(gray, best_params, k);
save("-hdf5", "codes/codes_gray.h5", "codes");

codes = Predict(resize50, best_params, k);
save("-hdf5", "codes/codes_resize50.h5", "codes");

codes = Predict(rotate5, best_params, k);
save("-hdf5", "codes/codes_rotate5.h5", "codes");