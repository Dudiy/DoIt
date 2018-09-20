import 'package:do_it/app.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DoItSpeedDial extends StatefulWidget {
  final List<FloatingActionButton> buttons;

  DoItSpeedDial({@required this.buttons});

  @override
  State createState() => new DoItSpeedDialState();
}

class DoItSpeedDialState extends State<DoItSpeedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(widget.buttons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                    0.0,
                    1.0 - index / widget.buttons.length / 2.0,
                    curve: Curves.easeOut
                ),
              ),
              child: widget.buttons[index],
            ),
          );
          return child;
        }).toList()..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
      );
  }
}
