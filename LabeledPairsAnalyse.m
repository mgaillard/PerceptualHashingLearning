function [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = LabeledPairsAnalyse(h1, h2, S, rho)
  % Hamming distance between the two binary codes.
  Diff = h1 - h2;
  HammingDist = sum(abs(Diff), 2);
  
  nb_training_samples = rows(S);
  
  nb_condition_positive = nnz(S);
  nb_condition_negative = nb_training_samples - nb_condition_positive;
  
  nb_true_positive = 0;
  nb_false_positive = 0;
  nb_false_negative = 0;
  nb_true_negative = 0;
  
  HammingSimilar = [HammingDist <= rho];
  
  for i = 1:rows(S)
    if (HammingSimilar(i) && S(i))
      nb_true_positive += 1;
    elseif (HammingSimilar(i) && not(S(i)))
      nb_false_positive += 1;
    elseif (not(HammingSimilar(i)) && S(i))
      nb_false_negative += 1;
    elseif (not(HammingSimilar(i)) && not(S(i)))
      nb_true_negative += 1;
    endif
  endfor
  
  precision = nb_true_positive / (nb_true_positive + nb_false_positive);
  recall = nb_true_positive / (nb_true_positive + nb_false_negative);
  fmeasure = 2*precision*recall / (precision + recall);
  
  fprintf("Number of training samples: %d\n", nb_training_samples);  
  fprintf("Number of similar triplets: %d\n", nb_condition_positive);
  fprintf("Number of dissimilar triplets: %d\n", nb_condition_negative);
  fprintf("Ratio of similar triplets: %d\n", nb_condition_positive / rows(S));
  
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