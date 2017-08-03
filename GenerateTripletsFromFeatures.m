% Generate the triplets of similarity from CNN features
% param features All the features in a matrix.
%                The first n rows are the base features
%                The n following rows are features modified according to transformation A
%                The n following rows are features modified according to transformation B
%                etc...
% param n The number of features for each transformation
function [P, L, X1, X2, S] = GenerateTripletsFromFeatures(features, n)
  % All points
  P = features;
  % All labels
  L = zeros(rows(features), 1);
  
  for i = 1:rows(features)
    L(i) = mod(i - 1, n);
  end
  
  % Create the list of triplets (point, point, similarity)
  X1 = [];
  X2 = [];
  S = [];
  % For each pair of points
  for i = 1:rows(features)
    for j = i+1:rows(features)
      X1 = [X1; P(i, :)];
      X2 = [X2; P(j, :)];
      
      if L(i) == L(j)
        similarity = 1;
      else
        similarity = 0;
      endif
      
      S = [S; similarity];
    endfor
  endfor
end