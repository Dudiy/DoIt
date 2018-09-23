import 'dart:io';

import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/widgets/custom/imageFetcher.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  static const String DEFAULT_GROUP_IMAGE_PATH = DEFAULT_GROUP_IMAGE;
  final String imagePath;
  final double size;
  final Color borderColor;
  final double borderRadius;
  final File imageFile;
  final String assetPath;
  final String defaultImagePath;

  ImageContainer(
      {this.imagePath = DEFAULT_GROUP_IMAGE_PATH,
      this.defaultImagePath = DEFAULT_GROUP_IMAGE_PATH,
      this.imageFile,
      this.assetPath,
      this.borderColor,
      this.size = 65.0,
      this.borderRadius = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(1.0, 0.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            )
          ],
          border: Border.all(color: borderColor ?? Colors.transparent, width: 1.0),
          color: Colors.white,
          gradient: LinearGradient(
            colors: [
              Colors.white,
              App.instance.themeData.primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: _getImage(),
      ),
    );
  }

  _getImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile,
        fit: BoxFit.cover,
      );
    } else if (assetPath != null) {
      return Image.asset(assetPath, fit: BoxFit.cover);
    } else {
      return ImageFetcher.fetch(imagePath: imagePath, defaultImagePath: defaultImagePath);
    }
  }
}
