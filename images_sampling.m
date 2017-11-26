% Parameter for the training
number_images = 25;
% Number of modifications
number_modifications = 7;
% Preprocessing parameters
pca = false;
centering = true;
normalization = true;
verbose = true;
% Algorithm parameters
rho = 3;
lambda = 1;
regularization = 0.0;
k = 0.1;
bits = 16;
iterations = 1;
% For reproducibility, fix the seed.
rand("state", 17);
randn("state", 17);

% Load and preprocess features
[features, base, blur, compress10, crop10, gray, resize50, rotate5] = LoadFeatures(number_images, pca, centering, normalization);

% Generate dataset
fprintf("\n------ Pairs generation ------\n");

% Number of pairs in the dataset
nb_similar_pairs = number_images*number_modifications*(number_modifications-1)/2;
nb_chosen_pairs = floor(nb_similar_pairs/2);
nb_random_pairs = ceil(nb_similar_pairs/2);
% Generate as many similar pairs as random pairs
labels = GenerateLabels(features, number_images);
[similar_X1, similar_X2, similar_S] = GenerateLabeledPairsFromFeatures_Similar(features, labels, number_images, number_modifications, nb_similar_pairs);
[rand_X1, rand_X2, rand_S] = HyperModel_ChooseRandomSamples(features, labels, nb_chosen_pairs + nb_random_pairs);
% Merge similar and random pairs
X1 = [similar_X1; rand_X1];
X2 = [similar_X2; rand_X2];
S = [similar_S; rand_S];

% Initialization
options = optimset('MaxIter', 10, 'GradObj', 'on');
options = optimset(options, 'OutputFcn', @DisplayOptimState);
weights = LSH(size(features, 2), bits);

for i = 1:10
  % Optimization
  fprintf("\nOptimization step %d\n", i);
  CustomCostFunction = @(w) HyperModel_ContinuousCostFunction(X1, X2, w, S, k, rho, lambda, regularization);
  [weights, optimal_cont_cost, info, output] = fminunc(CustomCostFunction, weights, options);
  % Control
  [precision, recall, fmeasure, nb_true_positive, nb_false_positive, nb_false_negative, nb_true_negative] = HyperModel_LabeledPairsAnalyse_Generated(features, labels, weights, k, rho);
  % Choose new hard pairs
  [hard_X1, hard_X2, hard_S] = HyperModel_ChooseHardSamples(features, labels, weights, k, rho, nb_chosen_pairs);
  % Replace part of the dataset with hard pairs
  start_hard = nb_similar_pairs + 1;
  end_hard = nb_similar_pairs + length(hard_S);
  X1(start_hard:end_hard, :) = hard_X1;
  X2(start_hard:end_hard, :) = hard_X2;
  S(start_hard:end_hard, :) = hard_S;
  % If not enough hard samples have been found, add ramdom pairs
  remaining_hard_samples = nb_chosen_pairs - length(hard_S);
  % Choose new random pairs
  [rand_X1, rand_X2, rand_S] = HyperModel_ChooseRandomSamples(features, labels, nb_random_pairs + remaining_hard_samples);
  % Replace part of the dataset with hard pairs
  start_random = end_hard + 1;
  X1(start_random:end, :) = rand_X1;
  X2(start_random:end, :) = rand_X2;
  S(start_random:end, :) = rand_S;
  
  fflush(stdout);
end

% Analysis of the binary codes
fprintf("\n------ Analysis ------\n");
% Histogram of the activations. The activations should be near to 0 or 1
HyperModel_ActivationHistogram(features, weights, k, 20);
mid_activ = HyperModel_NumberMiddleActivations(features, weights, k);
fprintf("Middle activation: %d\n", mid_activ);
HyperModel_LabeledPairsAnalyse_Generated(features, labels, weights, k, rho);

% Save binary codes
SaveBinaryCodes(weights, k, base, blur, compress10, crop10, gray, resize50, rotate5);