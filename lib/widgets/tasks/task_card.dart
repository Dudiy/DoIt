import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_interface.dart';
import 'package:do_it/data_managers/task_manager_exception.dart';
import 'package:do_it/data_managers/task_manager_result.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/custom/vertical_divider.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task taskInfo;
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final Function onTapped;
  final Function onCompleted;
  final Function onCheckChanged;
  final bool showCheckbox;
  final bool isChecked;
  final App app = App.instance;

  TaskCard({
    @required this.taskInfo,
    @required this.parentScaffoldKey,
    @required this.onTapped,
    @required this.onCompleted,
    @required this.onCheckChanged,
    this.showCheckbox = true,
    this.isChecked = false,
  }) {
    assert(taskInfo != null);
    assert(parentScaffoldKey != null);
    assert(taskInfo.runtimeType == CompletedTaskInfo || taskInfo.runtimeType == ShortTaskInfo);
  }

  bool _isCompletedTask() {
    return (taskInfo.runtimeType == CompletedTaskInfo);
  }

  bool _isOverdue() {
    bool isOverdue = false;
    if (taskInfo.runtimeType == ShortTaskInfo) {
      isOverdue = (taskInfo as ShortTaskInfo)?.endTime?.isBefore(DateTime.now()) ?? false;
    }
    return isOverdue;
  }

  @override
  Widget build(BuildContext context) {
    String description = taskInfo.description.isEmpty ? app.strings.noDescription : taskInfo.description;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: (taskInfo.runtimeType == CompletedTaskInfo)
          ? Colors.greenAccent[100]
          : _isOverdue() ? Colors.red : Colors.blueAccent[100],
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          color: Colors.white,
          highlightColor: app.themeData.primaryColorLight,
          onPressed: () => _cardClicked(context),
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              // Task Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // title and points
                    _getTaskTitle(context),
                    Divider(height: 5.0),
                    // description
                    Text(description, maxLines: 3, overflow: TextOverflow.ellipsis),
                    // due date and recurring policy
                    Divider(height: 10.0),
                    taskInfo.runtimeType == ShortTaskInfo ? _generateDueDateText() : _generateUserCompletedText(),
                  ],
                ),
              ),
              _getCheckbox(context),
            ],
          ),
        ),
      ),
    );
  }

  void _cardClicked(BuildContext context) {
    if (taskInfo.runtimeType == ShortTaskInfo) {
      App.instance.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
      });
    }
  }

  Widget _generateDueDateText() {
    ShortTaskInfo shortTaskInfo = taskInfo as ShortTaskInfo;
    if (_isCompletedTask()) throw Exception('due date text is not valid for completedTask');
    Widget recurring = (shortTaskInfo.recurringPolicy == eRecurringPolicy.none)
        ? Container(width: 0.0, height: 0.0)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.replay),
              Text(RecurringPolicyUtils.policyToString(shortTaskInfo.recurringPolicy))
            ],
          );

    String endTime = DoItTimeField.formatDateTime(shortTaskInfo.endTime);
    return Row(
//      alignment: WrapAlignment.spaceBetween,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: Text(endTime)),
        recurring,
      ],
    );
  }

  Widget _getCheckbox(BuildContext context) {
    CompletedTaskInfo completedTaskInfo = taskInfo is CompletedTaskInfo ? taskInfo as CompletedTaskInfo : null;
    ShortTaskInfo shortTaskInfo = taskInfo is ShortTaskInfo ? taskInfo as ShortTaskInfo : null;
    return showCheckbox
        ? Row(
            children: <Widget>[
              VerticalDivider(height: 80.0),
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  value ? _completeTask(shortTaskInfo, context) : _unCompleteTask(completedTaskInfo);
                },
              ),
            ],
          )
        : Container(width: 0.0, height: 0.0);
  }

  void _completeTask(ShortTaskInfo shortTaskInfo, BuildContext context) {
    onCheckChanged(true);
    app.tasksManager
        .completeTask(taskID: shortTaskInfo.taskID, userWhoCompletedID: app.loggedInUser.userID)
        .then((v) {
      final String successMessage =
          TaskMethodResultUtils.message(TaskMethodResult.COMPLETE_SUCCESS, shortTaskInfo.title);
      final snackBar = SnackBar(
        content: Text(successMessage),
      );
      parentScaffoldKey.currentState.showSnackBar(snackBar);
      onCompleted();
      print(successMessage);
    }).catchError((error) {
      print(error.toString());
      if (error is TaskException) {
        DoItDialogs.showErrorDialog(
          context: context,
          message: TaskMethodResultUtils.message(error.result),
        );
      }
      onCheckChanged(false);
    });
  }

  Text _generateUserCompletedText() {
    if (!_isCompletedTask()) throw Exception('User completed text is not valid for shortTaskInfo');
    CompletedTaskInfo completedTaskInfo = taskInfo as CompletedTaskInfo;
    String completedDateString = DoItTimeField.formatDateTime(completedTaskInfo.completedTime);
    return Text('${app.strings.completedBy}: ${completedTaskInfo.userWhoCompleted.displayName}, \n${app.strings.completedOn} $completedDateString');
  }

  _getTaskTitle(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: <Widget>[
        Text(
          '${taskInfo.title}',
          style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '  (${taskInfo.value.toString()} ${app.strings.points})',
          style: Theme.of(context).textTheme.caption,
        )
      ],
    );
  }

  void _unCompleteTask(CompletedTaskInfo completedTaskInfo) {
    onCheckChanged(false);
    if (completedTaskInfo != null) {
      app.tasksManager
          .unCompleteTask(parentGroupID: completedTaskInfo.parentGroupID, taskID: completedTaskInfo.taskID)
          .whenComplete(onCompleted);
    }
  }
}
