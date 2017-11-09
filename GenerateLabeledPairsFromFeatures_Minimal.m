% Generate the triplets of similarity from CNN features
% Dissimilarity triplets are generated only from the base features
% param features All the features in a matrix.
%                The first n rows are the base features
%                The n following rows are features modified according to transformation A
%                The n following rows are features modified according to transformation B
%                etc...
% param n The number of features for each transformation
function [P, L, X1, X2, S] = GenerateLabeledPairsFromFeatures_Minimal(features, n)
  r = rows(features);
  % Number of modifications
  k = r / n;
  % All points
  P = features;
  % All labels
  L = GenerateLabels(features, n);
  
  % Create the list of triplets (point, point, similarity)
  % Total number of triplets
  nb_total_triplets = r*(r-1)/2;
  % Number of triplets in the dataset
  nb_triplets = n*k*(k-1)/2 + n*(n-1)/2;
  % Counter representing the number of the current pair.
  p = 1;
  % Counter representing the number of the current triplet. From 1 to nb_triplets.
  c = 1;
  X1 = zeros(nb_triplets, columns(features));
  X2 = zeros(nb_triplets, columns(features));
  S = zeros(nb_triplets, 1);
  
  % Generating similar triplets
  for image = 1:n
    for i = 1:k
      for j = i+1:k
        index1 = (i-1)*n + image;
        index2 = (j-1)*n + image;
        
        if (L(index1) == L(index2))
          X1(c, :) = P(index1, :);
          X2(c, :) = P(index2, :);
          S(c) = 1;
          c += 1;
        endif
      endfor
    endfor
  endfor
  
  % Generating dissimilar triplets
  for i = 1:n
    for j = i+1:n
      % If the two features are both from the base image set and not similar, we add them to the dataset.  
      if (L(i) != L(j))
        X1(c, :) = P(i, :);
        X2(c, :) = P(j, :);
        S(c) = 0;
        c += 1;
      endif
    endfor
  endfor
end