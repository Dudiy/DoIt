import 'package:do_it/app.dart';
import 'package:do_it/private.dart';
import 'package:do_it/widgets/root_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: const FirebaseOptions(
      googleAppID: Private.googleAppID,
      apiKey: Private.apiKey,
      projectID: 'doit-grouptaskmanager',
    ),
  );
  await App.instance.init(app);
  runApp(new DoItApp());
}

class DoItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DoIt',
      home: RootPage(),
    );
  }
}
