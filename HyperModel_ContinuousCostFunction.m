% Compute the cost and the gradient of a set of parameters W.
% X1, X2 are vectors of input vectors and S is a similarity vector
% S(i) == 1 means that X1(i) and X2(i) are similar
% k, rho, lambda, regularization are hyper parameters of the cost function
function [cost grad] = HyperModel_ContinuousCostFunction(X1, X2, W, S, k, rho, lambda, regularization)
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
    % Cosine regularization
    % cost += sum(sum((regularization/2)*(1 - cos(2*pi*a1))));
    % cost += sum(sum((regularization/2)*(1 - cos(2*pi*a2))));
		
    % Polynomial regularization
    cost += sum(sum(4*regularization*a1.*(1 - a1)));
    cost += sum(sum(4*regularization*a2.*(1 - a2)));
  endif
  
  % ---------- Gradient ----------
  DiffSign = sign(Diff);
  HingeSimilar = [HammingDist > rho];
  HingeDissimilar = [HammingDist < (rho+1)];
  
  grad = X1'*((S .* HingeSimilar - (1-S) .* lambda .* HingeDissimilar) .* DiffSign .* k .* a1 .* (1 - a1)) ...
       - X2'*((S .* HingeSimilar - (1-S) .* lambda .* HingeDissimilar) .* DiffSign .* k .* a2 .* (1 - a2));     
       
  % Gradient of the regularization term
  if (regularization > 0)
    % Cosine regularization
    % grad += X1'*(regularization*pi*sin(2*pi*a1) .* k .* a1 .* (1 - a1)) ...
    %       + X2'*(regularization*pi*sin(2*pi*a2) .* k .* a2 .* (1 - a2));
    
    % Polynomial regularization
    grad += X1'*(4*regularization*(1 - 2*a1) .* k .* a1 .* (1 - a1)) ...
          + X2'*(4*regularization*(1 - 2*a2) .* k .* a2 .* (1 - a2));
  endif
end
