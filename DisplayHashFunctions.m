function DisplayHashFunctions(P, L, W)
  % Number of dimensions in the bit code
  d = size(W, 2);

  % Plot the two first dimensions
  figure();
  hold on;
  scatter(P(:, 1), P(:, 2), [], L);
  for i = 1:d
    vec = [W(2, i) -W(1, i)];
    point = 10 * vec / sqrt(sum(vec .* vec));
    line([-point(1) point(1)], [-point(2) point(2)]);
  endfor
  title("Points");
  hold off;
end