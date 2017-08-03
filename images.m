% Load features of images
number_images = 8;

load features/features_base.h5
base = features';

load features/features_blur.h5
blur = features';

load features/features_compress10.h5
compress10 = features';

load features/features_crop10.h5
crop10 = features';

load features/features_gray.h5
gray = features';

load features/features_resize50.h5
resize50 = features';

load features/features_rotate5.h5
rotate5 = features';

features = [base; blur; compress10; crop10; resize50; rotate5];

[P, L, X1, X2, S] = GenerateTripletsFromFeatures(features, number_images);

rho = 3;
k = 10;
bits = 16;
iterations = 10;

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
  real_cost = RealCostFunction(X1, X2, opti_params, S, k, rho)
  
  if real_cost < best_cost
    best_cost = real_cost;
    best_params = opti_params;
  endif
endfor

fprintf("\n------ Best real cost: %d ------\n", best_cost);

% Histogram of the activations. The activations should be near to 0 or 1
ActivationHistogram(P, best_params, k, 20);

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