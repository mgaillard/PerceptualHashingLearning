% Generate the triplets of similarity from CNN features
% param features All the features in a matrix.
%                The first n rows are the base features
%                The n following rows are features modified according to transformation A
%                The n following rows are features modified according to transformation B
%                etc...
% param n The number of features for each transformation
function [P, L, X1, X2, S] = GenerateLabeledPairsFromFeatures(features, n)
  r = rows(features);
  % All points
  P = features;
  % All labels
  L = GenerateLabels(features, n);
  
  % Create the list of triplets (point, point, similarity)
  % Total number of triplets
  nb_triplets = r*(r-1)/2;
  % Counter representing the number of the current triplet. From 1 to nb_triplets.
  c = 1;
  X1 = zeros(nb_triplets, columns(features));
  X2 = zeros(nb_triplets, columns(features));
  S = zeros(nb_triplets, 1);
  
  % For each pair of points
  for i = 1:r
    for j = i+1:r
      X1(c, :) = P(i, :);
      X2(c, :) = P(j, :);
      
      if L(i) == L(j)
        similarity = 1;
      else
        similarity = 0;
      endif
      S(c) = similarity;
      
      % Display the progress
      if mod(c, nb_triplets/100) == 0
        fprintf("%d / %d\t%d %%\n", c, nb_triplets, floor(100*c/nb_triplets));
        fflush(stdout);
      endif
      
      c += 1;
    endfor
  endfor
end