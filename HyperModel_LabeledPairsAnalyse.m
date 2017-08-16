function [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = HyperModel_LabeledPairsAnalyse(X1, X2, W, S, k, rho)
  % Binary codes of the samples
  h1 = HyperModel_Predict(X1, W, k);
  h2 = HyperModel_Predict(X2, W, k);
  
  [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = LabeledPairsAnalyse(h1, h2, S, rho);
end
