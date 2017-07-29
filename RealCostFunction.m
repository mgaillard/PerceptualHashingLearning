% Cost function with thresholded binary codes
function [cost] = RealCostFunction(X1, X2, W, S, rho)
  % Binary codes of the samples
  h1 = Predict(X1, W);
  h2 = Predict(X2, W);

  % Hamming distance between the two binary codes
  HammingDist = sum(abs(h1 - h2), 2);
  
  cost = sum(S.*max(0, HammingDist - rho) + (1-S).*max(0, (rho+1) - HammingDist));
end 