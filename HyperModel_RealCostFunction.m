% Cost function with thresholded binary codes
function [cost] = HyperModel_RealCostFunction(X1, X2, W, S, k, rho, lambda)
  % Binary codes of the samples
  h1 = HyperModel_Predict(X1, W, k);
  h2 = HyperModel_Predict(X2, W, k);

  % Hamming distance between the two binary codes
  HammingDist = sum(abs(h1 - h2), 2);
  
  cost = sum(S.*max(0, HammingDist - rho) + (1-S).*lambda.*max(0, (rho+1) - HammingDist));
end
