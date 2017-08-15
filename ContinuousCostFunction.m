function [cost grad] = ContinuousCostFunction(X1, X2, W, S, k, rho, lambda, regularization)
  % Binary codes of the samples
  a1 = 1.0 ./ (1.0 + exp(-k*X1*W));
  a2 = 1.0 ./ (1.0 + exp(-k*X2*W));

  % Hamming distance between the two binary codes.
  Diff = a1 - a2;
  HammingDist = sum(abs(Diff), 2);
  
  % ---------- Cost ----------
  
  cost = sum(S.*max(0, HammingDist - rho) + (1-S).*lambda.*max(0, (rho+1) - HammingDist));
  
  % Regularization of activations
  if (regularization > 0)
    cost += sum(sum((regularization/2)*(1 - cos(2*pi*a1))));
    cost += sum(sum((regularization/2)*(1 - cos(2*pi*a2))));
  endif
  
  % ---------- Gradient ----------
  
  SimilaritySign = 2*S - 1;
  DiffSign = sign(Diff);
  HingeSimilar = [HammingDist > rho];
  HingeDissimilar = [HammingDist < (rho+1)];
  
  grad = X1'*(S .* HingeSimilar .* DiffSign .* k .* a1 .* (1 - a1))         ...
       - X2'*(S .* HingeSimilar .* DiffSign .* k .* a2 .* (1 - a2))         ...
       - X1'*((1-S) .* lambda .* HingeDissimilar .* DiffSign .* k .* a1 .* (1 - a1))  ...
       + X2'*((1-S) .* lambda .* HingeDissimilar .* DiffSign .* k .* a2 .* (1 - a2));
       
  % Gradient of the regularization term
  if (regularization > 0)
  grad += regularization*pi*X1'*(sin(2*pi*a1) .* k .* a1 .* (1 - a1)) ...
        + regularization*pi*X2'*(sin(2*pi*a2) .* k .* a2 .* (1 - a2));
  endif
end
