import 'package:do_it/app.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final App app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 80.0),
            Image.asset('assets/logo_with_shadow.png', height: 300.0, width: 300.0),
            SizedBox(height: 50.0),
            Image.asset('assets/loading_anim_high.gif', height: 100.0, width: 100.0),
            Text("Loading page...", style: TextStyle(color: Colors.white)),
            SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
