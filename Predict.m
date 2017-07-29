% Predict the binary codes of points according to the parameters in W.
function [prediction] = Predict(X, W)
  % Binary codes of the samples
  a = 1.0 ./ (1.0 + exp(-X*W));
  
  prediction = [a >= 0.5];
end