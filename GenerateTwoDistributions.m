function [P1, P2, X1, X2, S] = GenerateTwoDistributions(mean, var, n, d)
  % Points from the first distribution
  P1 = normrnd(mean, var, n, d);
  % Points from the second distribution
  P2 = normrnd(-mean, var, n, d);
  
  % X coordinates of the points for the visualisation
  PX = [P1(:, 1);P2(:, 1)];
  % Y coordinates of the points for the visualisation
  PY = [P1(:, 2);P2(:, 2)];
  % Labels of the points for the visualisation
  C = [zeros(n, 1); ones(n, 1)];
  
  X1 = [];
  X2 = [];
  S = [];
  
  for i=1:n
    for j=i+1:n
      X1 = [X1; P1(i, :)];
      X2 = [X2; P1(j, :)];
      S = [S; 1];
      
      X1 = [X1; P2(i, :)];
      X2 = [X2; P2(j, :)];
      S = [S; 1];
    endfor
  endfor
  
  for i=1:n
    for j=1:n
      X1 = [X1; P1(i, :)];
      X2 = [X2; P2(j, :)];
      S = [S; 0];
    endfor
  endfor
  
  scatter(PX, PY, [], C);
  title("Points");
  
end