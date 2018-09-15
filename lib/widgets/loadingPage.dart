import 'package:do_it/app.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final App app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/logo_with_shadow.png', height: 250.0, width: 250.0),
            Column(
              children: <Widget>[
                Image.asset('assets/doit_logo/loading_animation.gif', height: 100.0, width: 100.0),
                Text("Loading page..."),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
