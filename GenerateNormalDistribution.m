% param std Standard deviation of the normal distribution
% param n Number of classes
% param k Number of points per classe
% param d Number of dimensions
function [P, L, X1, X2, S] = GenerateNormalDistribution(std, n, k, d)
  % All points
  P = [];
  % All labels
  L = [];
  
  for i = 1:n
    % Location of the distribution
    position = unifrnd(-10, 10, 1, d);
    % Points from the distribution
    points = normrnd(0, std, k, d);
    
    % Translate the points according to the center of the final distribution
    for j = 1:k
      points(j, :) += position;
    endfor
    
    P = [P; points];
    % Label the points with i
    L = [L; i*ones(k, 1)];
  endfor
  
  % Create the list of triplets (point, point, similarity)
  r = n*k;
  % Total number of triplets
  nb_triplets = r*(r-1)/2;
  % Counter representing the number of the current triplet. From 1 to nb_triplets.
  c = 1;
  X1 = zeros(nb_triplets, d);
  X2 = zeros(nb_triplets, d);
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