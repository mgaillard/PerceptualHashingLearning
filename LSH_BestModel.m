function [best_params] = LSH_BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations)
  model = @()LSH(columns(X1), bits);
  
  best_params = BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations, model);
end