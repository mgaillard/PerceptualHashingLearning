function [X1, X2, S] = HyperModel_ChooseHardSamples(features, labels, W, k, rho, nb_samples)
  [nb_features, nb_columns] = size(features);
  
  samples = -1*ones(nb_samples, 3);
  
  % For each pair of points
  for i = 1:nb_features
    for j = i+1:nb_features
      % Continuous codes of the samples
      % a1 = 1.0 ./ (1.0 + exp(-k*features(i, :)*W));
      % a2 = 1.0 ./ (1.0 + exp(-k*features(j, :)*W));
      % Continuous Hamming distance
      % Diff = a1 - a2;
      % HammingDist = sum(abs(Diff), 2);
      
      % Binary codes of the samples
      h1 = HyperModel_Predict(features(i, :), W, k);
      h2 = HyperModel_Predict(features(j, :), W, k);
      % Hamming distance
      Diff = h1 - h2;
      HammingDist = sum(abs(Diff), 2);
      
      % If the pair is not similar but is considered as similar by the current weights
      if ((HammingDist <= rho) && (labels(i) != labels(j)))
        [minimum_dist, index_minimum] = min(samples(:, 3));
        if HammingDist >= minimum_dist
          samples(index_minimum, 1) = i;
          samples(index_minimum, 2) = j;
          samples(index_minimum, 3) = HammingDist;
        end
      end
    end
  end
  
  X1 = zeros(nb_samples, nb_columns);
  X2 = zeros(nb_samples, nb_columns);
  S = zeros(nb_samples, 1);
  
  % Sort by column 3 in decreasing order, then 1 and 2 in ascending order
  sortrows(samples, [-3, 1, 2]);
  while (i <= nb_samples && samples(i, 1) > 0 && samples(i, 2) > 0)
    X1(i, :) = features(samples(i, 1), :);
    X2(i, :) = features(samples(i, 2), :);
    i = i + 1;
  end
  
  % Resize to the last non zero row
  if (i < nb_samples)
    X1 = resize(X1, i, nb_columns);
    X2 = resize(X2, i, nb_columns);
    S = resize(S, i, 1);
  end
  
end