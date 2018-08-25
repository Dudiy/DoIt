import 'dart:async';

import 'package:flutter/material.dart';

class DoItAlertDialog {
  static Future<void> showErrorDialog(BuildContext context, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(title: Text('Oops...'), content: Text(message), actions: <Widget>[
            new SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ]);
        });
  }
}
