import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_interface.dart';
import 'package:do_it/data_managers/task_manager_exception.dart';
import 'package:do_it/data_managers/task_manager_result.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/custom/vertical_divider.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final Task taskInfo;
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final Function onTapped;
  final Function onCompleted;
  final bool isChecked;
  final bool showCheckbox;

  TaskCard({
    @required this.taskInfo,
    @required this.parentScaffoldKey,
    @required this.onCompleted,
    @required this.onTapped,
    this.showCheckbox = true,
    this.isChecked = false,
  }) {
    assert(taskInfo != null);
    assert(parentScaffoldKey != null);
  }

  @override
  TaskCardState createState() {
    return new TaskCardState(isChecked: isChecked, taskInfo: taskInfo);
  }
}

class TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  App app = App.instance;
  bool isChecked;
  bool isOverdue;
  ShortTaskInfo shortTaskInfo;
  CompletedTaskInfo completedTaskInfo;

  TaskCardState({@required taskInfo, this.isChecked}) {
    assert(taskInfo.runtimeType == ShortTaskInfo || taskInfo.runtimeType == CompletedTaskInfo);
    if (taskInfo.runtimeType == ShortTaskInfo) {
      shortTaskInfo = taskInfo;
    } else {
      completedTaskInfo = taskInfo;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.5708).animate(animationController)
      ..addListener(() {
      setState(() {});
    });
    isOverdue = shortTaskInfo?.endTime?.isBefore(DateTime.now()) ?? false;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String description = widget.taskInfo.description.isEmpty ? "No description :(" : widget.taskInfo.description;
    return Transform(
      transform: Matrix4.rotationY(animation.value),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: (widget.taskInfo.runtimeType == CompletedTaskInfo)
            ? Colors.greenAccent
            : isOverdue ? Colors.red : Theme.of(context).primaryColorLight,
        child: Container(
          margin: EdgeInsets.all(4.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            color: Colors.white,
            highlightColor: Theme.of(context).primaryColorLight,
            onPressed: () {
              if (widget.taskInfo.runtimeType == ShortTaskInfo) {
                App.instance.tasksManager.getTaskById(widget.taskInfo.taskID).then((taskInfo) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
                });
              }

            },
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                // Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // title and points
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('${widget.taskInfo.title}',
                              style: Theme.of(context).textTheme.title.copyWith(fontWeight: FontWeight.bold)),
                          Text('  (${widget.taskInfo.value.toString()} point${widget.taskInfo.value > 1 ? 's' : ''})')
                        ],
                      ),
                      Divider(height: 5.0),
                      // description
                      Text(description, maxLines: 3, overflow: TextOverflow.ellipsis),
                      // due date and recurring policy
                      Divider(height: 10.0),
                      widget.taskInfo.runtimeType == ShortTaskInfo
                          ? _generateDueDateText()
                          : _generateUserCompletedText(),
                    ],
                  ),
                ),
                _getCheckbox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateDueDateText() {
    if (shortTaskInfo == null) throw Exception('due date text is not valid for completedTask');
    Widget recurring = (shortTaskInfo.recurringPolicy == eRecurringPolicy.none)
        ? Container(width: 0.0, height: 0.0)
        : Row(
            children: <Widget>[
              Icon(Icons.replay),
              Text(RecurringPolicyUtils.policyToString(shortTaskInfo.recurringPolicy))
            ],
          );

    String endTime = DoItTimeField.formatDateTime(shortTaskInfo.endTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(endTime),
        recurring,
      ],
    );
  }

  Widget _getCheckbox() {
    return widget.showCheckbox
        ? Row(
            children: <Widget>[
              VerticalDivider(height: 80.0),
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  value
                      ? _completeTask()
                      : app.tasksManager
                          .unCompleteTask(
                              parentGroupID: completedTaskInfo.parentGroupID, taskID: completedTaskInfo.taskID)
                          .whenComplete(widget.onCompleted);
                  setState(() {
                    isChecked = value;
                  });
                  animationController.forward();
                },
              ),
            ],
          )
        : Container(width: 0.0, height: 0.0);
  }

  void _completeTask() {
    app.tasksManager
        .completeTask(taskID: shortTaskInfo.taskID, userWhoCompletedID: app.loggedInUser.userID)
        .then((dummyVal) {
      final String successMessage =
          TaskMethodResultUtils.message(TaskMethodResult.COMPLETE_SUCCESS, shortTaskInfo.title);
      final snackBar = SnackBar(
        content: Text(successMessage),
      );
      widget.parentScaffoldKey.currentState.showSnackBar(snackBar);
      print(successMessage);
      widget.onCompleted();
    }).catchError((error) {
      print(error.toString());
      if (error is TaskException) {
        DoItDialogs.showErrorDialog(
          context: context,
          message: TaskMethodResultUtils.message(error.result),
        );
      }
    });
  }

  Text _generateUserCompletedText() {
    if (completedTaskInfo == null) throw Exception('User completed text is not valid for shortTaskInfo');
    String completedDateString = DoItTimeField.formatDateTime(completedTaskInfo.completedTime);
    return Text('Completed by: ${completedTaskInfo.userWhoCompleted.displayName}, on $completedDateString');
  }
}
