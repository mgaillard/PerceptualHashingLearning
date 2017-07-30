[P, L, X1, X2, S] = GenerateNormalDistribution(0.5, 4, 16, 2);
rho = 0;
k = 10;

% Optimization
opti_params = TrainModel(X1, X2, S, k, rho, 3);

% Cost function with true binary codes
% If the continuous cost at the end of the optimization is less than the real cost,
% some activations might be near to 0.5 which is not a good value
real_cost = RealCostFunction(X1, X2, opti_params, S, k, rho)

% Histogram of the activations. The activations should be near to 0 or 1
ActivationHistogram(P, opti_params, k, 20);
% A Scatter plot of the points and the hyperplanes of the hash functions
DisplayHashFunctions(P, L, opti_params);
