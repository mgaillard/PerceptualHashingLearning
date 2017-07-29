function DisplayHashFunctions(P, L, W)
  if columns(P) > 2
    warning("Only the first two dimensions of the space are displayed");
  endif

  % Length of the binary codes
  b = columns(W);
  
  % Length of the lines
  line_length = 10;

  % Plot the two first dimensions
  figure();
  hold on;
  scatter(P(:, 1), P(:, 2), [], L);
  title("Points and hash functions");
  for i = 1:b
    vec = [W(2, i) -W(1, i)];
    point = line_length * vec / sqrt(sum(vec .* vec));
    line([-point(1) point(1)], [-point(2) point(2)]);
  endfor
  hold off;
end