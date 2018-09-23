import 'package:do_it/constants/asset_paths.dart';
import 'package:flutter/material.dart';

class ImageFetcher {
  static const String DEFAULT_IMAGE_PATH = DEFAULT_GROUP_IMAGE;
  static const String LOADING_GIF = LOADING_ANIMATION;

  static fetch({@required String imagePath, String defaultImagePath = DEFAULT_IMAGE_PATH}) {
    if (imagePath == null || imagePath == "" || imagePath == defaultImagePath) {
      return Image.asset(defaultImagePath);
    }

    return FadeInImage.assetNetwork(
      fit: BoxFit.fill,
      placeholder: LOADING_GIF,
      image: imagePath,
    );
  }
}
