function [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = MedianModel_LabeledPairsAnalyse(X1, X2, M, S, rho)
  % Binary codes of the samples
  h1 = MedianModel_Predict(X1, M);
  h2 = MedianModel_Predict(X2, M);
  
  [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = LabeledPairsAnalyse(h1, h2, S, rho);
end
