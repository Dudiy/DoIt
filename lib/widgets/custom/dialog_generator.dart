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
  static final App app = App.instance;

  static Future<void> showErrorDialog({
    @required BuildContext context,
    @required String message,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: app.textDirection,
          child: new AlertDialog(
            title: Text(app.strings.oops),
            content: Text(message),
            actions: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(app.strings.ok),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showNotificationDialog({
    @required BuildContext context,
    @required String title,
    @required String body,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: app.textDirection,
          child: AlertDialog(
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
                      app.strings.gotIt,
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
          ),
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
    dialogBody.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text(app.strings.submit, style: TextStyle(color: Colors.white)),
          color: App.instance.themeData.primaryColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              onSubmit();
            }
          },
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: app.textDirection,
          child: new SimpleDialog(
            title: Center(child: Text(title)),
            children: dialogBody,
            contentPadding: EdgeInsets.all(16.0),
          ),
        );
      },
    );
  }

  static Future<bool> showConfirmDialog({
    @required BuildContext context,
    @required String message,
    bool isWarning = false,
    String actionButtonText,
  }) async {
    actionButtonText = actionButtonText ?? app.strings.confirm;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: app.textDirection,
          child: new SimpleDialog(
            title: Center(child: Text(message)),
            children: <Widget>[
              Wrap(alignment: WrapAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    child: Text(app.strings.cancel),
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
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ]),
            ],
          ),
        );
      },
    ).then((val){
      if (val == null)
        return false;
    });
  }

  static void showGroupScoreboardDialog({@required BuildContext context, @required ShortGroupInfo groupInfo}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: app.textDirection,
          child: Directionality(
            textDirection: app.textDirection,
            child: SimpleDialog(
              title: Center(
                child: Text(
                  '${groupInfo.title} - ${app.strings.scoreboard}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
                ),
              ),
              children: [ScoreBoard(groupInfo)],
            ),
          ),
        );
      },
    );
  }

  static void showAddMemberDialog({
    @required BuildContext context,
    @required GroupInfo groupInfo,
    Function onDialogSubmitted,
  }) {
    TextEditingController _emailController = new TextEditingController();

    DoItDialogs.showUserInputDialog(
      context: context,
      inputWidgets: [
        DoItTextField(
          controller: _emailController,
          label: app.strings.email,
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
        ),
      ],
      title: app.strings.addMemberTitle,
      onSubmit: () async {
        bool closeDialog = true;
        await app.groupsManager
            .addMember(groupID: groupInfo.groupID, newMemberEmail: _emailController.text)
            .then((ShortUserInfo newMember) async {
          app.notifier.sendNotifications(
            title: '${app.strings.notificationFromGroupTitle} \"${groupInfo.title}\"',
            body: app.strings.addedToGroupMsg,
            destUsersFcmTokens: {await app.usersManager.getFcmToken(newMember.userID): newMember.displayName},
          ).catchError((error) {
            DoItDialogs.showErrorDialog(
              context: context,
              message: '${newMember.displayName} ${app.strings.addMemberNotificationErrMsg}',
            );
          });
          if (onDialogSubmitted != null) {
            onDialogSubmitted(newMember);
          }
        }).catchError((error) {
          print(error);
          DoItDialogs.showErrorDialog(
              context: context, message: '${app.strings.addMemberErrMsgPrefix}${error.message}');
          closeDialog = false;
        });
        if (closeDialog) {
          Navigator.pop(context);
        }
      },
    );
  }

  static void showSingleGroupPageHelp(BuildContext context) {
    const double PADDING_1 = 8.0;
    const double PADDING_2 = 16.0;
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: app.textDirection,
          child: Dialog(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(app.strings.singleGroupDetailsHelpTitle,
                      style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline)),
                ),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Text(app.strings.singleGroupDetailsHelpIntro),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpTasksAssignedToMeSubtitle, PADDING_1,
                          TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpTasksAssignedToMeBody, PADDING_2),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpTasksAssignedToOthersSubtitle, PADDING_1,
                          TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpTasksAssignedToOthersBody, PADDING_2),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpFutureTasksSubtitle, PADDING_1,
                          TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpFutureTasksBody, PADDING_2),
                      _getHelpPageText(
                          '- ${app.strings.completedTasksTitle}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.singleGroupDetailsHelpCompletedTasksBody, PADDING_2),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: DoItRaisedButtonWithIcon(
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    text: Text(
                      App.instance.strings.gotIt,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: App.instance.themeData.primaryColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showTaskDetailsHelp(BuildContext context) {
    const double PADDING_1 = 8.0;
    const double PADDING_2 = 16.0;
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: app.textDirection,
          child: Dialog(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(app.strings.taskDetailsHelpTitle,
                      style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline)),
                ),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      Text(app.strings.taskDetailsHelpIntro),
                      _getHelpPageText(
                          '- ${app.strings.valueLabel}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.taskDetailsHelpValueBody, PADDING_2),
                      _getHelpPageText('- ${app.strings.repeat}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.taskDetailsHelpRepeatBody, PADDING_2),
                      _getHelpPageText(
                          '- ${app.strings.startTime}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.taskDetailsHelpStartTimeBody, PADDING_2),
                      _getHelpPageText('- ${app.strings.dueTime}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.taskDetailsHelpDueTimeBody, PADDING_2),
                      _getHelpPageText(
                          '- ${app.strings.assignedMembers}:', PADDING_1, TextStyle(fontWeight: FontWeight.bold)),
                      _getHelpPageText(app.strings.taskDetailsHelpAsssignedMembersBody, PADDING_2),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: DoItRaisedButtonWithIcon(
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    text: Text(
                      app.strings.gotIt,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: app.themeData.primaryColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _getHelpPageText(String text, double paddingFromStart, [TextStyle textStyle]) {
    return Padding(
      padding: _getPaddingFromStart(paddingFromStart),
      child: Text(text, style: textStyle),
    );
  }

  static EdgeInsets _getPaddingFromStart(double fromStart) {
    bool isRtl = app.textDirection == TextDirection.rtl;
    return EdgeInsets.only(
      left: !isRtl ? fromStart : 0.0,
      right: isRtl ? fromStart : 0.0,
    );
  }
}
