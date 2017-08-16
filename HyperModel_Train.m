function [optimal_weights] = HyperModel_Train(X1, X2, S, k, rho, lambda, regularization, b, verbose = false)
  CustomCostFunction = @(w) HyperModel_ContinuousCostFunction(X1, X2, w, S, k, rho, lambda, regularization);
  
  options = optimset('MaxIter', 500);
  initial_weights = LSH(columns(X1), b);
  
  % Train with the gradient
  options = optimset(options, 'GradObj', 'on');
  [optimal_weights, cost, info, output] = fminunc(CustomCostFunction, initial_weights, options);
  
  if (verbose == true)
    initial_cost = HyperModel_RealCostFunction(X1, X2, initial_weights, S, k, rho, lambda);
    optimal_cost = HyperModel_RealCostFunction(X1, X2, optimal_weights, S, k, rho, lambda);
    
    display(initial_cost);
    display(optimal_cost);
    display(output);
  endif
end
