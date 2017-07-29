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
  X1 = [];
  X2 = [];
  S = [];
  % For each pair of points
  for i = 1:n*k
    for j = i+1:n*k
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