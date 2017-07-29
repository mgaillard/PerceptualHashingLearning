function [cost grad] = ContinuousCostFunction(X1, X2, W, S, rho)
  % Binary codes of the samples
  a1 = 1.0 ./ (1.0 + exp(-X1*W));
  a2 = 1.0 ./ (1.0 + exp(-X2*W));

  % Hamming distance between the two binary codes.
  Diff = a1 - a2;
  HammingDist = sum(abs(Diff), 2);
  
  cost = sum(S.*max(0, HammingDist - rho) + (1-S).*max(0, (rho+1) - HammingDist));
  
  SimilaritySign = 2*S - 1;
  DiffSign = sign(Diff);
  HingeSimilar = [HammingDist > rho];
  HingeDissimilar = [HammingDist < (rho+1)];
  
  grad = X1'*(S .* HingeSimilar .* DiffSign .* a1 .* (1 - a1))         ...
       - X2'*(S .* HingeSimilar .* DiffSign .* a2 .* (1 - a2))         ...
       - X1'*((1-S) .* HingeDissimilar .* DiffSign .* a1 .* (1 - a1))  ...
       + X2'*((1-S) .* HingeDissimilar .* DiffSign .* a2 .* (1 - a2));
end