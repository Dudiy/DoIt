import 'dart:async';

import 'package:do_it/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingPage extends StatelessWidget {
  final App app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white12,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text("Loading..."),
          ],
        ),
      ),
    );
  }
}
