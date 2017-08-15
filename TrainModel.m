function [optimal_weights] = TrainModel(X1, X2, S, k, rho, lambda, regularization, b)
  CustomCostFunction = @(w) ContinuousCostFunction(X1, X2, w, S, k, rho, lambda, regularization);
  
  options = optimset('MaxIter', 500);
  optimal_weights = LSH(columns(X1), b);
  
  % Train with the gradient
  options = optimset(options, 'GradObj', 'on');
  [optimal_weights, cost, info, output] = fminunc(CustomCostFunction, optimal_weights, options);
end
