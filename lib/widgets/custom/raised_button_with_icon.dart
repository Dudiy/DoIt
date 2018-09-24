import 'package:do_it/app.dart';
import 'package:flutter/material.dart';

class DoItRaisedButtonWithIcon extends RaisedButton {
  final Icon icon;
  final VoidCallback onPressed;
  final Text text;
  final Color color;
  final App app = App.instance;

  DoItRaisedButtonWithIcon({
    @required this.text,
    @required this.icon,
    @required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
  bool isRtl = app.textDirection == TextDirection.rtl;
    return RaisedButton(
      color: color ?? Theme.of(context).buttonColor,
      child: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              left: !isRtl ? 0.0 : null,
              right: isRtl ? 0.0 : null,
              child: icon,
            ),
            text,
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
