import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  final double height;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height ?? 30.0,
      width: 1.0,
      color: Theme.of(context).dividerColor,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

  VerticalDivider({this.height});
}
