% Thresholds the points with the median of each dimension to get a binary code
function [predictions] = MedianModel_Predict(X, M)
  predictions = [X >= M];
end