% For each sample in P take some random other sample to make random pairs of non similar points
% Warning: nb_samples > rows(P)
function [X1, X2, S] = HyperModel_ChooseRandomSamples(features, labels, nb_samples)
  [nb_features, nb_columns] = size(features);
  
  X1 = zeros(nb_samples, nb_columns);
  X2 = zeros(nb_samples, nb_columns);
  S = zeros(nb_samples, 1);
  
  % Counter representing the number of the current pair.
  c = 1;
  
  for i = 1:nb_features
    # For each sample, find nb_samples/rows non similar other sample
    nb_pairs_per_sample = floor(nb_samples/nb_features);
    for j = 1:nb_pairs_per_sample
      # Find a non similar point
      l = i;
      while (labels(i) == labels(l))
        l = randi(nb_features);
      end
      
      X1(c, :) = features(i, :);
      X2(c, :) = features(l, :);
      S(c) = 0;
      c += 1;
    end
  end
end