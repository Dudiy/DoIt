import 'package:do_it/widgets/custom/imageFetcher.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  static const String DEFAULT_GROUP_IMAGE_PATH = 'assets/images/default_group_icon.jpg';
  final String imagePath;
  final double size;
  final Color borderColor;
  final double borderRadius;

  ImageContainer({
    this.imagePath = DEFAULT_GROUP_IMAGE_PATH,
    this.borderColor,
    this.size = 65.0,
    this.borderRadius = 16.0
  });

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
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: ImageFetcher.fetch(imagePath: imagePath, defaultImagePath: DEFAULT_GROUP_IMAGE_PATH),
      ),
    );
  }

/*  _getImage() {
    return (imagePath == DEFAULT_IMAGE_PATH || imagePath == null)
        ? Image.asset(DEFAULT_IMAGE_PATH)
        : FadeInImage.assetNetwork(
            fit: BoxFit.fill,
            placeholder: LOADING_GIF,
            image: imagePath,
          );
  }*/
}
