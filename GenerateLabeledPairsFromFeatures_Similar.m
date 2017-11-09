function [X1, X2, S] = GenerateLabeledPairsFromFeatures_Similar(features, labels, number_images, number_modifications, nb_similar_pairs)
  [nb_features, nb_columns] = size(features);
  
  X1 = zeros(nb_similar_pairs, nb_columns);
  X2 = zeros(nb_similar_pairs, nb_columns);
  S = zeros(nb_similar_pairs, 1);
  
  % Counter representing the number of the current triplet. From 1 to nb_triplets.
  c = 1;
  
  % Generating similar triplets
  for image = 1:number_images
    for i = 1:number_modifications
      for j = i+1:number_modifications
        index1 = (i-1)*number_images + image;
        index2 = (j-1)*number_images + image;
        
        if (labels(index1) == labels(index2))
          X1(c, :) = features(index1, :);
          X2(c, :) = features(index2, :);
          S(c) = 1;
          c += 1;
        end
      end
    end
  end
end