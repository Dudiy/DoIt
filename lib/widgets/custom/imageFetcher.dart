import 'package:flutter/material.dart';

class ImageFetcher {
  static const String DEFAULT_IMAGE_PATH = 'assets/images/default_group_icon.jpg';
  static const String LOADING_GIF = 'assets/images/loading_profile_pic.png';

  static fetch({@required String imagePath, String defaultImagePath = DEFAULT_IMAGE_PATH}) {
    return (imagePath == null || imagePath == defaultImagePath)
        ? Image.asset(defaultImagePath)
        : FadeInImage.assetNetwork(
            fit: BoxFit.fill,
            placeholder: LOADING_GIF,
            image: imagePath,
          );
  }
}
