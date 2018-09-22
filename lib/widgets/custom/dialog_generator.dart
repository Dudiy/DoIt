import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/raised_button_with_icon.dart';
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
            title: Center(child: Text(message)),
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
                  'No user is registered to DoIt with the email: ${_emailController.text} \n\n** Email addresses are case sensitive **');
          closeDialog = false;
        });
        if (closeDialog) {
          Navigator.pop(context);
        }
      },
    );
  }

  static void showSingleGroupPageHelp(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Single group details page",
                    style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline)),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text("This page is where a user can see all the tasks of the selected group.\n\n"
                        "The group picture can be changed by any group member by clicking on the group image at the top of the page\n\n"
                        "Every task in the group is shown on a task card, clicking on the card will show the task details page\n"
                        "This is where the group manager can also update the task\n\n"
                        "The group tasks are seperated into the following sections:\n"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Tasks assigned to me (the active user):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "These tasks are the tasks that the user can complete.\n "
                            "When a task is completed it is moved to the completed tasks section.\n"
                            "If a task is a recurring task then after it is completed a new task with the updated start\\end date will be generated.\n"
                            "* If the new date of a recurring task is after the current time it will show up in the future tasks section *\n",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Tasks assigned to other users:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          "These tasks are assigned to other members of the group but not the active user.\n "
                              "These tasks cannot be completed by the active user\n"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Future tasks (visible to group manager only):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("These tasks have a starting date that is lated than the current time.\n "),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Completed tasks:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("To see completed tasks a time span must be selected.\n "
                          "Only the group manager or the member who completed a task can \"uncomplete\" a task\n"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: DoItRaisedButtonWithIcon(
                  icon: Icon(Icons.thumb_up, color: Colors.white, size: 15.0,),
                  text: const Text("Got it...", style: TextStyle(color: Colors.white),),
                  color: App.instance.themeData.primaryColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showTaskDetailsHelp(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Task details page",
                    style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline)),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    Text("This page is where all the details of a selected task are.\n\n"
                        "Only the group manager can update the details of a task.\n\n"
                        "Task fields:\n"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Value:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "The amount of points a member will get for completing this task.\n",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Repeat:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                          "When should the task re-appear after completion.\n"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Start Time:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("The task will be visible to the group members only after the current time is after this value.\n "),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- End time:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("The due date of the task, after this time the task background will be colored red.\n"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "- Assigned members:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text("The group members who are assigned to this task - only they are able to complete it.\n"
                          "By default tasks are assigned to all members of the group.\n"),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: DoItRaisedButtonWithIcon(
                  icon: Icon(Icons.thumb_up, color: Colors.white, size: 15.0,),
                  text: const Text("Got it...", style: TextStyle(color: Colors.white),),
                  color: App.instance.themeData.primaryColor,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
