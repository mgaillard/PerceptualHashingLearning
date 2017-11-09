function SaveBinaryCodes(best_params, k, base, blur, compress10, crop10, gray, resize50, rotate5)
  codes = HyperModel_Predict(base, best_params, k);
  save("-hdf5", "codes/codes_base.h5", "codes");

  codes = HyperModel_Predict(blur, best_params, k);
  save("-hdf5", "codes/codes_blur.h5", "codes");

  codes = HyperModel_Predict(compress10, best_params, k);
  save("-hdf5", "codes/codes_compress10.h5", "codes");

  codes = HyperModel_Predict(crop10, best_params, k);
  save("-hdf5", "codes/codes_crop10.h5", "codes");

  codes = HyperModel_Predict(gray, best_params, k);
  save("-hdf5", "codes/codes_gray.h5", "codes");

  codes = HyperModel_Predict(resize50, best_params, k);
  save("-hdf5", "codes/codes_resize50.h5", "codes");

  codes = HyperModel_Predict(rotate5, best_params, k);
  save("-hdf5", "codes/codes_rotate5.h5", "codes");
end