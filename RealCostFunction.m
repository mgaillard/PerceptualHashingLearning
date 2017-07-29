function [cost] = RealCostFunction(X1, X2, W, S, rho)
  % Binary codes of the samples
  a1 = 1.0 ./ (1.0 + exp(-X1*W));
  a2 = 1.0 ./ (1.0 + exp(-X2*W));
  
  h1 = [a1 >= 0.5];
  h2 = [a2 >= 0.5];

  % Hamming distance between the two binary codes.
  HammingDist = sum(abs(h1 - h2), 2);
  
  cost = sum(S.*max(0, HammingDist - rho) + (1-S).*max(0, (rho+1) - HammingDist));
end 