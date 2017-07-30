% Display a histogram of the activations
% All the values should be near to 0 or 1
function ActivationHistogram(X, W, k, nbins = 10)
  % Activations of the samples
  a = 1.0 ./ (1.0 + exp(-k*X*W));
  
  figure();
  hist(vec(a), nbins);
  title("Histogram of the values of activations");
end