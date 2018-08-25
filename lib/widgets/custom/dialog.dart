import 'dart:async';

import 'package:flutter/material.dart';

class DoItDialogs {
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

  static Future<void> showUserInputDialog({
    @required BuildContext context,
    @required List<Widget> inputWidgets,
    @required String title,
    @required VoidCallback onSubmit,
  }) async {
    final _formKey = GlobalKey<FormState>();
    List<Widget> dialogBody = new List();
    dialogBody.add(Form(key: _formKey, child: Column(children: inputWidgets)));
    dialogBody.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: const Text('Submit', style: TextStyle(color: Colors.white)),
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            onSubmit();
            Navigator.pop(context);
          }
        },
      ),
    ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Center(child: Text(title)),
            children: dialogBody,
          );
        });
  }
}
