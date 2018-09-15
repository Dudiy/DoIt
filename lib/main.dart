import 'package:do_it/widgets/root_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(new DoItApp());
}

class DoItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        cardColor: Theme.of(context).primaryColorLight.withAlpha(180),
        dialogBackgroundColor: Theme.of(context).primaryColorLight.withAlpha(220),
      ),
      debugShowCheckedModeBanner: false,
      title: 'DoIt',
      home: RootPage(),
    );
  }
}
