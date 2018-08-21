import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/edit_group_widget.dart';
import 'package:flutter/material.dart';

class GroupDetailsPage extends StatefulWidget {
  final GroupInfo groupInfo;

  GroupDetailsPage(this.groupInfo);

  @override
  GroupDetailsPageState createState() {
    return new GroupDetailsPageState(groupInfo);
  }
}

class GroupDetailsPageState extends State<GroupDetailsPage> {
  final App app = App.instance;
  List<ShortTaskInfo> _groupTasks;
  GroupInfo groupInfo;

// for remove groups listener
  StreamSubscription<DocumentSnapshot> _streamSubscriptionTasks;

  GroupDetailsPageState(this.groupInfo);

  @override
  void initState() {
    String groupId = groupInfo.groupID;
    // listen for tasks list update
    _streamSubscriptionTasks =
        App.instance.firestore.collection('$GROUPS').document('$groupId').snapshots().listen(_updateTasksList);
    super.initState();
    getMyGroupTasksFromDB();
  }

  void _groupInfoChanged(GroupInfo newGroupInfo) {
    setState(() {
      groupInfo = newGroupInfo;
    });
  }

  @override
  void dispose() {
// stop listen for group list update
    _streamSubscriptionTasks.cancel();
    super.dispose();
  }

  void getMyGroupTasksFromDB() {
    app.groupsManager.getMyGroupTasksFromDB(groupInfo.groupID).then((tasks) {
      setState(() {
        _groupTasks = tasks;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(groupInfo.title, maxLines: 2), actions: _drawEditAndDelete()),
        body: GestureDetector(
          onVerticalDragDown: (details) => getMyGroupTasksFromDB(),
          child: Container(
            child: ListView(
              children: getAllTasks(),
            ),
          ),
        ),
        floatingActionButton: _drawAddTaskButton());
  }

  List<Widget> getAllTasks() {
    return _groupTasks == null
        ? [Text('Fetching tasks from server...')]
        : _groupTasks.length == 0
            ? [ListTile(title: Text("There are no tasks in this group yet"))]
            : _groupTasks.map((taskInfo) {
                return ListTile(
                  title: Text(taskInfo.title),
                  subtitle: Text(taskInfo.isCompleted ? 'completed' : 'incomplete'),
                );
              }).toList();
  }

  Future<void> _showDialog() async {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    TextEditingController _valueController = new TextEditingController();
    TextEditingController _startTimeController = new TextEditingController();
    TextEditingController _endTimeController = new TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: Text('Test'),
            children: <Widget>[
              DoItTextField(
                controller: _titleController,
                label: 'Title',
                isRequired: true,
              ),
              DoItTextField(
                controller: _descriptionController,
                label: 'Description',
                isRequired: true,
              ),
              DoItTextField(
                controller: _valueController,
                isRequired: true,
                label: 'Task value',
                textInputType: TextInputType.numberWithOptions(),
              ),
              DoItTextField(
                controller: _startTimeController,
                label: 'Starting time',
                isRequired: false,
              ),
              RaisedButton(
                onPressed: () async {
                  await app.tasksManager.addTask(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    value: int.parse(_valueController.text),
                    startTime: _startTimeController.text.isNotEmpty ? DateTime.parse(_startTimeController.text) : null,
                    endTime: _endTimeController.text.isNotEmpty ? DateTime.parse(_endTimeController.text) : null,
                    assignedUsers: null,
                    recurringPolicy: null,
                    parentGroup: groupInfo.getShortGroupInfo(),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
          );
        });
  }

  void _updateTasksList(DocumentSnapshot documentSnapshotGroupTasks) {
    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    if (documentSnapshotGroupTasks.data != null) {
      setState(() {
        _groupTasks = GroupsManager.conventDBGroupTaskToObjectList(documentSnapshotGroupTasks);
      });
    }
  }

  Future<bool> _showDeleteDialog() async {
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

  List<Widget> _drawEditAndDelete() {
    List<Widget> buttons = new List();
    if (app.getLoggedInUserID() == groupInfo.managerID) {
      buttons.add(FlatButton(
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          ShortUserInfo managerInfo = await app.usersManager.getShortUserInfo(groupInfo.managerID);
          Navigator
              .of(context)
              .push(MaterialPageRoute(builder: (context) => EditGroupPage(groupInfo, managerInfo, _groupInfoChanged)));
        },
      ));
      buttons.add(FlatButton(
        child: Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          _showDeleteDialog().then((deleteConfimed) {
            if (deleteConfimed) {
              app.groupsManager.deleteGroup(groupID: groupInfo.groupID);
              Navigator.pop(context);
            }
          });
        },
      ));
    }
    return buttons;
  }

  Widget _drawAddTaskButton() {
    return (app.getLoggedInUserID() == groupInfo.managerID)
        ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _showDialog();
            })
        : null;
  }
}
