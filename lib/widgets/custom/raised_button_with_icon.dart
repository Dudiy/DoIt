import 'package:flutter/material.dart';

class DoItRaisedButtonWithIcon extends RaisedButton {
  final Icon icon;
  final VoidCallback onPressed;
  final Text text;
  final Color color;

  DoItRaisedButtonWithIcon({
    @required this.text,
    @required this.icon,
    @required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color ?? Theme.of(context).buttonColor,
      child: Container(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(left: 0.0, child: icon),
            text,
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
