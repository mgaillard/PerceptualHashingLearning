function [best_params] = HyperModel_BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations)
  model = @()HyperModel_Train(X1, X2, S, k, rho, lambda, regularization, bits, verbose);
  
  best_params = BestModel(X1, X2, S, k, rho, lambda, regularization, bits, verbose, iterations, model);
end