function [features, base, blur, compress10, crop10, gray, resize50, rotate5] = LoadFeatures(number_images, pca, centering, normalization)
  % Load features of images
  load features/features_base.h5
  base = features'(1:number_images, :);

  load features/features_blur.h5
  blur = features'(1:number_images, :);

  load features/features_compress10.h5
  compress10 = features'(1:number_images, :);

  load features/features_crop10.h5
  crop10 = features'(1:number_images, :);

  load features/features_gray.h5
  gray = features'(1:number_images, :);

  load features/features_resize50.h5
  resize50 = features'(1:number_images, :);

  load features/features_rotate5.h5
  rotate5 = features'(1:number_images, :);

  features = [base; blur; compress10; crop10; gray; resize50; rotate5];

  % PCA
  if pca == true
    [pca_coeffs, features] = princomp(features,'econ');
    fprintf("\n------ PCA (size: %d, %d)------\n", size(features));
  endif

  % Center data
  if centering == true
    fprintf("\n------ Centering ------\n");
    features = center(features);
  endif

  % Normalization
  if normalization == true
    fprintf("\n------ Normalization ------\n");
    norms = sqrt(sumsq(features, 2));
    features = features./norms;
  endif

  % Features are updated
  base       = features(1:number_images, :);
  blur       = features(  number_images+1:2*number_images, :);
  compress10 = features(2*number_images+1:3*number_images, :);
  crop10     = features(3*number_images+1:4*number_images, :);
  gray       = features(4*number_images+1:5*number_images, :);
  resize50   = features(5*number_images+1:6*number_images, :);
  rotate5    = features(6*number_images+1:7*number_images, :);
end