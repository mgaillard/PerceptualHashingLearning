function [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = HyperModel_LabeledPairsAnalyse_Generated(P, L, W, k, rho)
  r = rows(P);
  
  nb_training_samples = r*(r-1)/2;
  
  nb_condition_positive = 0;
  nb_condition_negative = 0;
  
  nb_true_positive = 0;
  nb_false_positive = 0;
  nb_false_negative = 0;
  nb_true_negative = 0;
  
  % For each pair of points
  for i = 1:r
    for j = i+1:r
      X1 = P(i, :);
      X2 = P(j, :);
      
      % Binary codes of the samples
      h1 = HyperModel_Predict(X1, W, k);
      h2 = HyperModel_Predict(X2, W, k);
      %% Hamming distance
      Diff = h1 - h2;
      HammingDist = sum(abs(Diff), 2);
      
      if ((HammingDist <= rho) && (L(i) == L(j)))
        nb_true_positive += 1;
        nb_condition_positive += 1;
      elseif ((HammingDist <= rho) && (L(i) != L(j)))
        nb_false_positive += 1;
        nb_condition_negative += 1;
      elseif ((HammingDist > rho) && (L(i) == L(j)))
        nb_false_negative += 1;
        nb_condition_positive += 1;
      elseif ((HammingDist > rho) && (L(i) != L(j)))
        nb_true_negative += 1;
        nb_condition_negative += 1;
      endif
    endfor
  endfor

  precision = nb_true_positive / (nb_true_positive + nb_false_positive);
  recall = nb_true_positive / (nb_true_positive + nb_false_negative);
  fmeasure = 2*precision*recall / (precision + recall);
  
  fprintf("Number of training samples: %d\n", nb_training_samples);  
  fprintf("Number of similar triplets: %d\n", nb_condition_positive);
  fprintf("Number of dissimilar triplets: %d\n", nb_condition_negative);
  fprintf("Ratio of similar triplets: %d\n", nb_condition_positive / nb_training_samples);
  
  fprintf("Number of true positives: %d\n", nb_true_positive);
  fprintf("Number of false positives: %d\n", nb_false_positive);
  fprintf("Number of false negatives: %d\n", nb_false_negative);
  fprintf("Number of true negatives: %d\n", nb_true_negative);
  
  fprintf("Ratio of preserved similar triplets: %d\n", nb_true_positive / nb_condition_positive);
  fprintf("Ratio of preserved dissimilar triplets: %d\n", nb_true_negative / nb_condition_negative);
  
  fprintf("Precision: %d\n", precision);
  fprintf("Recall: %d\n", recall);
  fprintf("F1-measure: %d\n", fmeasure);
end
