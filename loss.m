[P, L, X1, X2, S] = GenerateNormalDistribution(0.5, 4, 16, 2);
rho = 0;
k = 10;
bits = 3;
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

% Histogram of the activations. The activations should be near to 0 or 1
ActivationHistogram(P, best_params, k, 20);
% A Scatter plot of the points and the hyperplanes of the hash functions
DisplayHashFunctions(P, L, best_params);
