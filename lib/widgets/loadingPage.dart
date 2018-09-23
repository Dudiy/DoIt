import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(LOGO_WITH_SHADOW, height: 250.0, width: 250.0),
            Column(
              children: <Widget>[
                Image.asset(LOADING_ANIMATION, height: 100.0, width: 100.0),
                Text("Loading page..."),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
