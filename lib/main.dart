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
        cardColor: Colors.white.withOpacity(0.75),
        dialogBackgroundColor: Colors.white.withOpacity(0.75),
      ),
      debugShowCheckedModeBanner: false,
      title: 'DoIt',
      home: RootPage(),
    );
  }
}
