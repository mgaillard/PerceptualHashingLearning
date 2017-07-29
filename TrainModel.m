function [optimal_weights] = TrainModel(X1, X2, S, rho, b)
  CustomCostFunction = @(w) ContinuousCostFunction(X1, X2, w, S, rho);
  
  options = optimset('MaxIter', 500);
  initial_weights = unifrnd(-1, 1, 2, b)
  
  % Train with the gradient
  options = optimset(options, 'GradObj', 'on');
  [optimal_weights, cost, info, output] = fminunc(CustomCostFunction, initial_weights, options)
  
  % Train without the gradient
  % [optimal_weights, cost] = fminsearch(CustomCostFunction, initial_weights, options)
end