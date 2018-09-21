import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/text_field.dart';
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
              color: App.instance.themeData.primaryColor,
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
        color: App.instance.themeData.primaryColor,
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
              Wrap(alignment: WrapAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    child: Text(
                      actionButtonText,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: isWarning ? Theme.of(context).errorColor : App.instance.themeData.primaryColor,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
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
          title: Center(
            child: Text(
              '${groupInfo.title} - scoreboard',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
            ),
          ),
          children: [ScoreBoard(groupInfo)],
        );
      },
    );
  }

  static void showAddMemberDialog({
    @required BuildContext context,
    @required GroupInfo groupInfo,
    Function onDialogSubmitted,
  }) {
    App app = App.instance;
    TextEditingController _emailController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _emailController,
          label: 'Email',
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
        ),
      ],
      title: 'Add Member',
      onSubmit: () async {
        bool closeDialog = true;
        await app.groupsManager
            .addMember(groupID: groupInfo.groupID, newMemberEmail: _emailController.text)
            .then((ShortUserInfo newMember) async {
          app.notifier.sendNotifications(
            title: 'Group \"${groupInfo.title}\"',
            body: 'You have been added to this group',
            destUsersFcmTokens: [await App.instance.usersManager.getFcmToken(newMember.userID)],
          );
          if (onDialogSubmitted != null) {
            onDialogSubmitted(newMember);
          }
        }).catchError((err) {
          print(err);
          DoItDialogs.showErrorDialog(
              context: context,
              message:
                  'No user is registered with the email: ${_emailController.text} \n\n** email addresses are case sensitive **');
          closeDialog = false;
        });
        if (closeDialog) {
          Navigator.pop(context);
        }
      },
    );
  }
}
