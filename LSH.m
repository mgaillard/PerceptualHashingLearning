function [lsh_weights] = LSH(d, b)
  lsh_weights = stdnormal_rnd(d, b);
  % Normalization of rows
  norms = sqrt(sumsq(lsh_weights, 2));
  for r = 1:d
      lsh_weights(r, :) = lsh_weights(r, :)./norms(r);
   endfor 
end