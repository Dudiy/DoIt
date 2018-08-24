import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/groups/group_details_page.dart';
import 'package:flutter/material.dart';

class SingleGroupPage extends StatefulWidget {
  final GroupInfo groupInfo;

  SingleGroupPage(this.groupInfo);

  @override
  SingleGroupPageState createState() {
    return new SingleGroupPageState(groupInfo);
  }
}

class SingleGroupPageState extends State<SingleGroupPage> {
  final App app = App.instance;
  List<ShortTaskInfo> _groupTasks;
  List<CompletedTaskInfo> _completedTasks;
  Map<String, bool> _groupTasksCompleted = new Map();
  GroupInfo groupInfo;
  bool myTasksIsExpanded = true;
  bool othersTasksIsExpanded = false;
  bool completedTasksIsExpanded = false;

// for remove groups listener
  StreamSubscription<DocumentSnapshot> _streamSubscriptionTasks;

  SingleGroupPageState(this.groupInfo);

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
        _groupTasksCompleted
            .addAll(Map.fromIterable(tasks, key: (task) => (task as ShortTaskInfo).taskID, value: (task) => false));
      });
    });
  }

  void getCompletedTasksFromDB() {
    app.groupsManager.getCompletedTasks(groupID: groupInfo.groupID).then((completedTasks) {
      setState(() {
        _completedTasks = completedTasks;
        _groupTasksCompleted.addAll(Map.fromIterable(completedTasks,
            key: (completedTask) => (completedTask as CompletedTaskInfo).taskID, value: (completedTask) => true));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(groupInfo.title, maxLines: 2), actions: _drawEditAndDelete()),
        body: GestureDetector(
            onVerticalDragDown: (details) => getMyGroupTasksFromDB(),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        switch (index) {
                          case 0:
                            myTasksIsExpanded = !myTasksIsExpanded;
                            break;
                          case 1:
                            othersTasksIsExpanded = !othersTasksIsExpanded;
                            break;
                          case 2:
                            completedTasksIsExpanded = !completedTasksIsExpanded;
                            break;
                        }
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Center(child: Text('Tasks assigned to me', style: Theme.of(context).textTheme.title));
                        },
                        body: getTasksAssignedToMe(),
                        isExpanded: myTasksIsExpanded,
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Center(
                              child: Text('Tasks assigned to others', style: Theme.of(context).textTheme.title));
                        },
                        body: getTasksAssignedToOthers(),
                        isExpanded: othersTasksIsExpanded,
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Center(child: Text('Completed tasks', style: Theme.of(context).textTheme.title));
                        },
                        body: getCompletedTasks(),
                        isExpanded: completedTasksIsExpanded,
                      ),
                    ],
                  ),
                )
              ],
            )),
        floatingActionButton: _drawAddTaskButton());
  }

  Widget getTasksAssignedToMe() {
    Padding noTasksAssignedToMe = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Center(child: Text("There are no tasks assigned to you in this group")),
    );
    if (_groupTasks == null) return Text('Fetching tasks from server...');
    if (_groupTasks.length == 0) return noTasksAssignedToMe;
    List<Widget> tasksList = new List();
    _groupTasks.forEach((taskInfo) {
      if (taskInfo.assignedUsers == null ||
          taskInfo.assignedUsers.length == 0 ||
          taskInfo.assignedUsers.containsKey(app.loggedInUser.userID)) {
        tasksList.add(ListTile(
          title: Text('${taskInfo.title} (${taskInfo.value.toString()})'),
          subtitle: Text(taskInfo.description ?? "no description", maxLines: 3),
          trailing: Checkbox(
              value: _groupTasksCompleted[taskInfo.taskID] ?? false,
              onChanged: (value) {
                setState(() {
                  _groupTasksCompleted[taskInfo.taskID] = true;
                });
                app.tasksManager.completeTask(taskID: taskInfo.taskID, userWhoCompletedID: app.loggedInUser.userID);
              }),
        ));
      }
    });
    return Column(
      children: tasksList.length > 0 ? tasksList : [noTasksAssignedToMe],
    );
  }

  Widget getTasksAssignedToOthers() {
    Padding noTasksAssignedToOthers = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Center(child: Text("There are no tasks assigned to others in this group")),
    );
    if (_groupTasks == null) return Text('Fetching tasks from server...');
    if (_groupTasks.length == 0) return noTasksAssignedToOthers;
    List<Widget> tasksList = new List();
    _groupTasks.forEach((taskInfo) {
      if (taskInfo.assignedUsers != null &&
          taskInfo.assignedUsers.length != 0 &&
          !taskInfo.assignedUsers.containsKey(app.loggedInUser.userID)) {
        tasksList.add(ListTile(
          title: Text('${taskInfo.title} (${taskInfo.value.toString()})'),
          subtitle: Text(taskInfo.description ?? "no description", maxLines: 3),
        ));
      }
    });
    return Column(
      children: tasksList.length > 0 ? tasksList : [noTasksAssignedToOthers],
    );
  }

  Widget getCompletedTasks() {
    Row timeSpanSelectors = Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
            child: RaisedButton(
              child: Text('past week'),
              onPressed: () =>
                  fetchCompletedTasksFromServer(fromDate: DateTime.now().add(Duration(days: -7)), toDate: DateTime.now()),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
            child: RaisedButton(
              child: Text('past month'),
              onPressed: () => fetchCompletedTasksFromServer(
                    fromDate: DateTime.now().add(Duration(days: -30)),
                    toDate: DateTime.now(),
                  ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
            child: RaisedButton(
              child: Text('all time'),
              onPressed: () => fetchCompletedTasksFromServer(),
            ),
          ),
        ),
      ],
    );
    if (_completedTasks == null) return timeSpanSelectors;
    if (_completedTasks.length == 0)
      return Column(
        children: <Widget>[
          timeSpanSelectors,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text("No completed tasks")),
          ),
        ],
      );
    List<Widget> tasksList = new List();
    tasksList.add(timeSpanSelectors);
    _completedTasks.forEach((completedTask) {
      tasksList.add(ListTile(
        title: Text('${completedTask.title} (${completedTask.value.toString()})'),
        subtitle: Text(
          completedTask.description ?? "no description",
          maxLines: 3,
        ),
      ));
    });
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: tasksList
        ));
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
                    parentGroupID: groupInfo.groupID,
                    parentGroupManagerID: groupInfo.managerID,
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
    buttons.add(FlatButton(
      child: Icon(Icons.info_outline, color: Colors.white),
      onPressed: () async {
        ShortUserInfo managerInfo = await app.usersManager.getShortUserInfo(groupInfo.managerID);
        Navigator
            .of(context)
            .push(MaterialPageRoute(builder: (context) => GroupDetailsPage(groupInfo, managerInfo, _groupInfoChanged)));
      },
    ));
    if (app.getLoggedInUserID() == groupInfo.managerID) {
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

  void fetchCompletedTasksFromServer({DateTime fromDate, DateTime toDate}) {
    app.groupsManager
        .getCompletedTasks(groupID: widget.groupInfo.groupID, fromDate: fromDate, toDate: toDate)
        .then((completedTasks) {
      setState(() {
        _completedTasks = completedTasks;
      });
    });
  }
}
