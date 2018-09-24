import 'package:do_it/widgets/root_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(new DoItApp());
}

class DoItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('he', 'IL'), // Hebrew
      ],
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
