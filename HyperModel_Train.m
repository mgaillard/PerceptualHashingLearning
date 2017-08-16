function [optimal_weights] = HyperModel_Train(X1, X2, S, k, rho, lambda, regularization, b, verbose = false)
  CustomCostFunction = @(w) HyperModel_ContinuousCostFunction(X1, X2, w, S, k, rho, lambda, regularization);
  
  % Train with the gradient, maximum 500 iterations
  options = optimset('MaxIter', 500, 'GradObj', 'on');
  initial_weights = LSH(columns(X1), b);
  
  % Display the cost at all iterations
  if (verbose == true)
    options = optimset(options, 'OutputFcn', @DisplayOptimState);
    fprintf("Iter\tCost\n");
  endif
  
  [optimal_weights, optimal_cont_cost, info, output] = fminunc(CustomCostFunction, initial_weights, options);
  
  if (verbose == true)
    initial_real_cost = HyperModel_RealCostFunction(X1, X2, initial_weights, S, k, rho, lambda);
    initial_cont_cost = CustomCostFunction(initial_weights);
    optimal_real_cost = HyperModel_RealCostFunction(X1, X2, optimal_weights, S, k, rho, lambda);
    
    display(initial_cont_cost);
    display(initial_real_cost);
    display(optimal_real_cost);
    display(optimal_cont_cost);
    display(output);
  endif
end
