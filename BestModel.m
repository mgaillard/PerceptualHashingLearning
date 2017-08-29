function [best_params] = BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations, model)
  % Costs of all optimizations
  costs = zeros(iterations, 1);
  % Take the best solution of several optimization
  best_params = [];
  best_cost = Inf;
  for i=1:iterations
    fprintf("Iteration: %d/%d\n", i, iterations);
    fflush(stdout);

    % Optimization
    opti_params = model();

    % Cost function with true binary codes
    % If the continuous cost at the end of the optimization is less than the real cost,
    % some activations might be near to 0.5 which is not a good value
    costs(i) = HyperModel_RealCostFunction(X1, X2, opti_params, S, k, rho, lambda, regularization);
    
    if costs(i) < best_cost
      best_cost = costs(i);
      best_params = opti_params;
    endif
  endfor


  fprintf("\n------ Real cost statistics: ------\n");
  fprintf("Min: %d\n", min(costs));
  fprintf("Max: %d\n", max(costs));
  fprintf("Median: %d\n", median(costs));
  fprintf("Mean: %d\n", mean(costs));
  fprintf("Standard deviation: %d\n", std(costs));
  % If there is more than one iteration, we display the cost histogram
  if (iterations > 1)
    figure();
    hist(costs, 20);
    title("Histogram of the costs");
  endif
end