import 'package:flutter/material.dart';

class ImageFetcher {
  static const String DEFAULT_IMAGE_PATH = 'assets/images/default_group_icon.jpg';
  static const String LOADING_GIF = 'assets/doit_logo/loading_animation.gif';

  static fetch({@required String imagePath, String defaultImagePath = DEFAULT_IMAGE_PATH}) {
    if (imagePath == null || imagePath == defaultImagePath) {
      return Image.asset(defaultImagePath);
    }

    return FadeInImage.assetNetwork(
      fit: BoxFit.fill,
      placeholder: LOADING_GIF,
      image: imagePath,
    );
  }
}
