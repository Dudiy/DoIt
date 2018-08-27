import 'dart:async';

import 'package:flutter/material.dart';

class WidgetUtils {
  static Future<bool> showDeleteDialog(context) async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text(
              'Are you sure you would like to delete this group? \nThis cannot be undone',
            ),
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Delete Group',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              RaisedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          );
        });
  }
}
