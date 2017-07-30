% Count the number of activations that are not near to 0 or 1.
function [n] = NumberMiddleActivations(X, W, k)
  % Activations of the samples
  a = 1.0 ./ (1.0 + exp(-k*X*W));
  
  low_threshold = 0.25;
  high_threshold = 0.75;
  
  n = 0;
  for i = 1:rows(a)
    for j = 1:columns(a)
      if low_threshold <= a(i, j) && a(i, j) <= high_threshold
        n = n + 1;
      endif
    endfor
  endfor
end