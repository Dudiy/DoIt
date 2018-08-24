import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/users/user_selector.dart';
import 'package:flutter/material.dart';

class TaskDetailsPage extends StatefulWidget {
  final TaskInfo taskInfo;
//  final Function onGroupInfoChanged;
  TaskDetailsPage(this.taskInfo /*, this.onGroupInfoChanged*/);

  @override
  TaskDetailsPageState createState() => new TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  final App app = App.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskIDController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController = new TextEditingController();
  final TextEditingController _valueController = new TextEditingController();
  final TextEditingController _startTimeController = new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();

  bool editEnabled;
  Map<String, ShortUserInfo> _parentGroupMembers;
  Map<String, ShortUserInfo> _assignedUsers;

  @override
  void initState() {
    editEnabled = app.loggedInUser.userID == widget.taskInfo.parentGroupManagerID;
    _taskIDController.text = widget.taskInfo.taskID;
    _titleController.text = widget.taskInfo.title;
    _descriptionController.text = widget.taskInfo.description;
    _valueController.text = widget.taskInfo.value.toString();
    _startTimeController.text = widget.taskInfo.startTime.toString();
    _endTimeController.text = widget.taskInfo.endTime.toString();
    app.groupsManager.getGroupInfoByID(widget.taskInfo.parentGroupID).then((parentGroupInfo) {
      setState(() {
        _parentGroupMembers = parentGroupInfo.members;
        _assignedUsers = widget.taskInfo.assignedUsers == null || widget.taskInfo.assignedUsers.length == 0
            ? Map.from(_parentGroupMembers)
            : widget.taskInfo.assignedUsers;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task \"${widget.taskInfo.title}\" details'),
        actions: drawActions(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  DoItTextField(label: 'Task ID', enabled: false),
                  DoItTextField(
                    controller: _titleController,
                    label: 'Title',
                    enabled: editEnabled,
                  ),
                  DoItTextField(controller: _descriptionController, label: 'Description', enabled: editEnabled),
                  DoItTextField(
                    controller: _valueController,
                    label: 'Value',
                    enabled: false,
                    textInputType: TextInputType.numberWithOptions(),
                  ),
                  //TODO add date pickers
                  DoItTextField(
                    controller: _startTimeController,
                    label: 'Start time',
                    enabled: editEnabled,
                  ),
                  DoItTextField(controller: _endTimeController, label: 'End time', enabled: editEnabled),
                ])),
          ),
          Column(
            children: getAssignedUsers(),
          ),
        ],
      ),
    );
  }

  List<Widget> drawActions() {
    List<Widget> actions = new List();
    if (editEnabled)
      actions.add(FlatButton(
        child: Icon(Icons.save, color: Colors.white),
        onPressed: () async {
          await app.tasksManager
              .updateTask(
            taskIdToChange: widget.taskInfo.taskID,
            title: _titleController.text.isNotEmpty ? _titleController.text : null,
            description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
            value: _valueController.text.isNotEmpty ? int.parse(_valueController.text) : null,
            startTime: _startTimeController.text.isNotEmpty ? DateTime.parse(_startTimeController.text) : null,
            endTime: _endTimeController.text.isNotEmpty && _endTimeController.text != "null"
                ? DateTime.parse(_endTimeController.text)
                : null,
            // TODO add recurring policy
          )
              .then((newGroupInfo) {
            // TODO check if we need this
//            widget.onTaskInfoChanged(newGroupInfo);
          });
          Navigator.pop(context);
        },
      ));
    return actions;
  }

  List<Widget> getAssignedUsers() {
    List<Widget> list = new List();
    list.add(Container(
      child: Stack(
        children: <Widget>[
          _drawEditAssignedUsersButton(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              'Assigned users',
              style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
            )),
          ),
        ],
      ),
    ));
    if (widget.taskInfo.assignedUsers == null || widget.taskInfo.assignedUsers.length == 0) {
      _parentGroupMembers == null
          ? list.add(Center(child: Text(('Fetching assigned users from DB...'))))
          : _parentGroupMembers.forEach((userID, shortUserInfo) {
              list.add(ListTile(
                // TODO display with a nicer widget
                title: Text(shortUserInfo.displayName),
              ));
            });
    } else {
      _assignedUsers.forEach((userID, shortUserInfo) {
        list.add(ListTile(
          // TODO display with a nicer widget
          title: Text(shortUserInfo.displayName),
        ));
      });
    }
    return list;
  }

  _showEditAssignedUsersDialog() {
    Map<String, dynamic> _updatedAssignedUsers = new Map();
    _parentGroupMembers.forEach((userID, userInfo) {
      _updatedAssignedUsers.putIfAbsent(
          userID,
          () => {
                'userInfo': userInfo,
                'isSelected': false,
              });
    });
    _assignedUsers.keys.forEach((userID) {
      _updatedAssignedUsers[userID]['isSelected'] = true;
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            child: UserSelector(_updatedAssignedUsers, updateAssignedUsers),
          );
        });
  }

  void updateAssignedUsers(Map<String, dynamic> _updatedAssignedUsers) {
    _parentGroupMembers.keys.forEach((userID) async {
      if (!_assignedUsers.containsKey(userID) && _updatedAssignedUsers[userID]['isSelected']) {
        // user was assigned
        await app.tasksManager.assignTaskToUser(userID: userID, taskID: widget.taskInfo.taskID);
      } else if (_assignedUsers.containsKey(userID) && !_updatedAssignedUsers[userID]['isSelected']) {
        // user was removed
        await app.tasksManager.removeUserFromAssignedTask(userID: userID, taskID: widget.taskInfo.taskID);
      }
    });
    _getAssignedUsersFromDB();
    Navigator.pop(context);
  }

  void _getAssignedUsersFromDB() {
    app.tasksManager.getTaskById(widget.taskInfo.taskID).then((taskInfo) {
      setState(() {
        _assignedUsers = Map.from(taskInfo.assignedUsers);
      });
    });
  }

  _drawEditAssignedUsersButton() {
    return app.loggedInUser.userID == widget.taskInfo.parentGroupManagerID ?
      Positioned(
        right: 10.0,
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {

              // TODO implement assigned users selector
              _showEditAssignedUsersDialog();

          },
        ),
      )
        : Container(height: 0.0, width: 0.0);
  }
}
