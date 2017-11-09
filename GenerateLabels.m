function [labels] = GenerateLabels(features, n)
  nb_features = size(features, 1);
  % All labels
  labels = zeros(nb_features, 1);
  
  for i = 1:nb_features
    labels(i) = mod(i - 1, n);
  end
end