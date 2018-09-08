import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_managers/task_manager_exception.dart';
import 'package:do_it/data_managers/task_manager_result.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/custom/vertical_divider.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final ShortTaskInfo taskInfo;
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
    return new TaskCardState(isChecked: isChecked);
  }
}

class TaskCardState extends State<TaskCard> {
  App app = App.instance;
  bool isChecked;
  bool isOverdue;

  TaskCardState({this.isChecked});

  @override
  void initState() {
    super.initState();
    isOverdue = widget.taskInfo.endTime?.isBefore(DateTime.now()) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    String description = widget.taskInfo.description.isEmpty ? "No description :(" : widget.taskInfo.description;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: isOverdue ? Colors.red : Theme.of(context).primaryColorLight,
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          color: Colors.white,
          highlightColor: Theme.of(context).primaryColorLight,
          onPressed: () {
            App.instance.tasksManager.getTaskById(widget.taskInfo.taskID).then((taskInfo) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
            });
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
                    _generateDueDateText(),
                  ],
                ),
              ),
              _getCheckbox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateDueDateText() {
    Widget reccuring = (widget.taskInfo.recurringPolicy == eRecurringPolicy.none)
        ? Container(width: 0.0, height: 0.0)
        : Row(
            children: <Widget>[
              Icon(Icons.replay),
              Text(RecurringPolicyUtils.policyToString(widget.taskInfo.recurringPolicy))
            ],
          );

    String endTime = DoItTimeField.formatDateTime(widget.taskInfo.endTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(endTime),
        reccuring,
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
                  _completeTask();
                  setState(() {
                    isChecked = value;
                  });
                },
              ),
            ],
          )
        : Container(width: 0.0, height: 0.0);
  }

  void _completeTask() {
    ShortTaskInfo shortTaskInfo = widget.taskInfo;
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
}
