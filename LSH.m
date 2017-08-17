function [lsh_weights] = LSH(d, b)
  lsh_weights = stdnormal_rnd(d, b);
  % Normalization of rows
  norms = sqrt(sumsq(lsh_weights, 2));
  lsh_weights = lsh_weights./norms;
end