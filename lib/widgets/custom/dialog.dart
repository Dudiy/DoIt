import 'dart:async';

import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/groups/scoreboard_widget.dart';
import 'package:flutter/material.dart';

class DoItDialogs {
  static Future<void> showErrorDialog({
    @required BuildContext context,
    @required String message,
  }) async {
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

  static Future<void> showNotificationDialog({
    @required BuildContext context,
    @required String title,
    @required String body,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            new RaisedButton(
              onPressed: () => Navigator.pop(context),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                children: <Widget>[
                  Text(
                    'Got it... ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showUserInputDialog({
    @required BuildContext context,
    @required List<Widget> inputWidgets,
    @required String title,
    @required VoidCallback onSubmit,
  }) async {
    final _formKey = GlobalKey<FormState>();
    List<Widget> dialogBody = new List();
    dialogBody.add(Form(
      key: _formKey,
      child: Column(children: inputWidgets),
    ));
    dialogBody.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: const Text('Submit', style: TextStyle(color: Colors.white)),
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            onSubmit();
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
            contentPadding: EdgeInsets.all(16.0),
          );
        });
  }

  static Future<bool> showConfirmDialog({
    @required BuildContext context,
    @required String message,
    bool isWarning = false,
    String actionButtonText = 'Confirm',
  }) async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text(message),
            children: <Widget>[
              ButtonBar(children: [
                RaisedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                RaisedButton(
                  child: Text(
                    actionButtonText,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: isWarning ? Theme.of(context).errorColor : Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ]),
            ],
          );
        });
  }

  static void showGroupScoreboardDialog({@required BuildContext context, @required ShortGroupInfo groupInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('${groupInfo.title} - scoreboard'),
          children: [ScoreBoard(groupInfo)],
        );
      },
    );
  }
}
