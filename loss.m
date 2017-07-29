[P, L, X1, X2, S] = GenerateNormalDistribution(0.5, 4, 16, 2);
rho = 0;

% Optimization
opti_params = TrainModel(X1, X2, S, rho, 3);

DisplayHashFunctions(P, L, opti_params);

real_cost = RealCostFunction(X1, X2, opti_params, S, rho)