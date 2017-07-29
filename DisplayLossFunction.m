% Only works for one bit codes from a two dimensional space
function DisplayLossFunction(cost_function, start_val, end_val, step)
  x = [start_val:step:end_val];
  y = [start_val:step:end_val];

  ans = zeros(length(x));

  for i=1:length(x)
    for j=1:length(y)
      [cost grad] = cost_function([x(i); y(j)]);
      ans(i, j) = cost;
    endfor
  endfor
  
  figure();
  surf(x, y, ans);
end