import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/widgets/groups/group_details_page.dart';
import 'package:do_it/widgets/tasks/add_task.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
import 'package:do_it/widgets/utils/widget_utils.dart';
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
  static const LOADING_GIF = 'assets/images/loading_profile_pic.png';
  static const DEFAULT_PICTURE = 'assets/images/default_group_icon.png';
  String photoUrl = DEFAULT_PICTURE;
  final App app = App.instance;
  List<ShortTaskInfo> _allGroupTasks;
  List<CompletedTaskInfo> _completedTasks;
  Map<String, bool> _myTasksCheckboxes = new Map();
  GroupInfo groupInfo;
  bool _myTasksIsExpanded = true;
  bool _othersTasksIsExpanded = false;
  bool _completedTasksIsExpanded = false;
  bool _futureTasksIsExpanded = false;
  int daysBeforeTodayToShowCompletedTasks;

// for remove groups listener
  StreamSubscription<DocumentSnapshot> _streamSubscriptionTasks;

  SingleGroupPageState(this.groupInfo);

  @override
  void initState() {
    String groupId = groupInfo.groupID;
    // listen for tasks list update
    _streamSubscriptionTasks =
        App.instance.firestore.collection('$GROUPS').document('$groupId').snapshots().listen(_updateTasksList);
    getMyGroupTasksFromDB();
    super.initState();
  }

  @override
  void dispose() {
// stop listen for group list update
    _streamSubscriptionTasks.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (groupInfo?.photoUrl != null && groupInfo?.photoUrl != "") {
      photoUrl = groupInfo?.photoUrl;
    } else {
      photoUrl = DEFAULT_PICTURE;
    }
    return Scaffold(
        appBar: AppBar(title: Text(groupInfo.title, maxLines: 2), actions: _drawEditAndDelete()),
        body: GestureDetector(
            onVerticalDragDown: (details) => getMyGroupTasksFromDB(),
            child: ListView(
              children: <Widget>[_shortGroupInfo(), _groupTaskTabs(context)],
            )),
        floatingActionButton: _drawAddTaskButton());
  }

  Widget _shortGroupInfo() {
    return Container(
        child: new Row(
      children: <Widget>[
        new Expanded(
          child: GestureDetector(
            onTap: () => App.instance.groupsManager.uploadGroupPic(groupInfo).then((val) {
                  setState(() {
                    photoUrl = groupInfo.photoUrl;
                  });
                }),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: _addProfilePicture(),
            ),
          ),
        ),
        new Expanded(
          child: new Text(groupInfo.title +
              "\n" +
              "there are " +
              groupInfo.members.length.toString() +
              " members\n" +
              "total " +
              groupInfo.tasks.length.toString() +
              " tasks"),
        ),
      ],
    ));
  }

  _addProfilePicture() {
    return photoUrl == DEFAULT_PICTURE
        ? DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
            image: AssetImage(DEFAULT_PICTURE),
          )))
        : Center(
            child: FadeInImage.assetNetwork(
              placeholder: LOADING_GIF,
              image: photoUrl,
            ),
          );
  }

  Padding _groupTaskTabs(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            switch (index) {
              case 0:
                _myTasksIsExpanded = !_myTasksIsExpanded;
                break;
              case 1:
                _othersTasksIsExpanded = !_othersTasksIsExpanded;
                break;
              case 2:
                groupInfo.managerID == app.loggedInUser.userID
                    ? _futureTasksIsExpanded = !_futureTasksIsExpanded
                    : _completedTasksIsExpanded = !_completedTasksIsExpanded;
                break;
              case 3:
                _completedTasksIsExpanded = !_completedTasksIsExpanded;
                if (_completedTasksIsExpanded) {
                  fetchCompletedTasksFromServer();
                }
                break;
            }
          });
        },
        children: _getExpansionPanels(context),
      ),
    );
  }

  void _groupInfoChanged(GroupInfo newGroupInfo) {
    setState(() {
      groupInfo = newGroupInfo;
    });
  }

  void getMyGroupTasksFromDB() {
    app.groupsManager.getMyGroupTasksFromDB(groupInfo.groupID).then((tasks) {
      setState(() {
        _allGroupTasks = tasks;
        _myTasksCheckboxes
            .addAll(Map.fromIterable(tasks, key: (task) => (task as ShortTaskInfo).taskID, value: (task) => false));
      });
    });
  }

  Widget getTasksAssignedToMe() {
    List<ShortTaskInfo> _myTasks = new List();
    if (_allGroupTasks != null) {
      _myTasks.addAll(_allGroupTasks.where((taskInfo) => taskInfo.startTime.isBefore(DateTime.now())));
    }
    Padding noTasksAssignedToMe = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Center(child: Text("There are no tasks assigned to you in this group")),
    );
    if (_myTasks == null) return Text('Fetching tasks from server...');
    if (_myTasks.length == 0) return noTasksAssignedToMe;
    List<Widget> tasksList = new List();
    _myTasks.forEach((taskInfo) {
      if (taskInfo.assignedUsers == null ||
          taskInfo.assignedUsers.length == 0 ||
          taskInfo.assignedUsers.containsKey(app.loggedInUser.userID)) {
        tasksList.add(ListTile(
          title: Text('${taskInfo.title} (${taskInfo.value.toString()})'),
          subtitle: Text(taskInfo.description ?? "no description", maxLines: 3),
          trailing: Checkbox(
              value: _myTasksCheckboxes[taskInfo.taskID] ?? false,
              onChanged: (value) {
                setState(() {
                  _myTasksCheckboxes[taskInfo.taskID] = true;
                });
                app.tasksManager
                    .completeTask(taskID: taskInfo.taskID, userWhoCompletedID: app.loggedInUser.userID)
                    .then((val) {
                  fetchCompletedTasksFromServer();
                });
              }),
          onTap: () {
            app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
            });
          },
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
    if (_allGroupTasks == null) return Text('Fetching tasks from server...');
    if (_allGroupTasks.length == 0) return noTasksAssignedToOthers;
    List<Widget> tasksList = new List();
    _allGroupTasks.forEach((taskInfo) {
      if (taskInfo.assignedUsers != null &&
          taskInfo.assignedUsers.length != 0 &&
          !taskInfo.assignedUsers.containsKey(app.loggedInUser.userID)) {
        tasksList.add(ListTile(
          title: Text('${taskInfo.title} (${taskInfo.value.toString()})'),
          subtitle: Text(taskInfo.description ?? "no description", maxLines: 3),
          onTap: () {
            if (app.loggedInUser.userID == taskInfo.parentGroupManagerID) {
              app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
              });
            }
          },
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
        _timeSpanSelector('week', 7),
        _timeSpanSelector('month', 31),
        _timeSpanSelector('all time', 0),
      ],
    );
    if (_completedTasks == null) {
      return Column(
        children: <Widget>[
          timeSpanSelectors,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text("Please select a timespan")),
          ),
        ],
      );
    }
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
        trailing: _completedTaskCheckbox(completedTask),
      ));
    });
    return Padding(padding: EdgeInsets.all(20.0), child: Column(children: tasksList));
  }

  Future<void> _showAddTaskDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            child: AddTaskDialogBody(addTaskSubmitted),
          );
        });
  }

  void addTaskSubmitted(TaskInfo taskInfo) {
    try {
      app.tasksManager
          .addTask(
            title: taskInfo.title,
            description: taskInfo.description,
            value: taskInfo.value,
            startTime: taskInfo.startTime,
            endTime: taskInfo.endTime,
            assignedUsers: taskInfo.assignedUsers,
            recurringPolicy: taskInfo.recurringPolicy,
            parentGroupID: groupInfo.groupID,
            parentGroupManagerID: groupInfo.managerID,
          )
          .whenComplete(() => Navigator.pop(context));
    } catch (e) {
      print(e);
    }
  }

  void _updateTasksList(DocumentSnapshot documentSnapshotGroupTasks) {
    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    if (documentSnapshotGroupTasks.data != null) {
      setState(() {
        _allGroupTasks = GroupsManager.conventDBGroupTaskToObjectList(documentSnapshotGroupTasks);
      });
    }
  }

  List<Widget> _drawEditAndDelete() {
    List<Widget> buttons = new List();
    buttons.add(FlatButton(
      child: Icon(Icons.info_outline, color: Colors.white),
      onPressed: () async {
        ShortUserInfo managerInfo = await app.usersManager.getShortUserInfo(groupInfo.managerID);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => GroupDetailsPage(groupInfo, managerInfo, _groupInfoChanged)));
      },
    ));
    buttons.add(FlatButton(
      child: Icon(Icons.delete, color: Colors.white),
      onPressed: deleteGroup,
    ));
    return buttons;
  }

  /// different behavior on the other user permission
  void deleteGroup() async {
    WidgetUtils.showDeleteDialog(
            context: context, message: 'Are you sure you would like to delete this group? \nThis cannot be undone')
        .then((deleteConfirmed) {
      if (deleteConfirmed) {
        if (app.getLoggedInUserID() == groupInfo.managerID) {
          app.groupsManager.deleteGroup(groupID: groupInfo.groupID);
        } else {
          app.groupsManager.deleteUserFromGroup(
              groupInfo.groupID, app.loggedInUser.userID); //TODO seperate to another function (leave group)
        }
        Navigator.pop(context);
      }
    });
  }

  Widget _drawAddTaskButton() {
    return (app.getLoggedInUserID() == groupInfo.managerID)
        ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _showAddTaskDialog();
            })
        : null;
  }

  void fetchCompletedTasksFromServer() {
    if (daysBeforeTodayToShowCompletedTasks == null || !_completedTasksIsExpanded) return;
    DateTime toDate = DateTime.now();
    DateTime fromDate = daysBeforeTodayToShowCompletedTasks != 0
        ? DateTime.now().add(Duration(days: -daysBeforeTodayToShowCompletedTasks))
        : null;
    app.groupsManager
        .getCompletedTasks(groupID: widget.groupInfo.groupID, fromDate: fromDate, toDate: toDate)
        .then((completedTasks) {
      setState(() {
        _completedTasks = completedTasks;
        _myTasksCheckboxes.addAll(Map.fromIterable(completedTasks,
            key: (completedTask) => (completedTask as CompletedTaskInfo).taskID, value: (completedTask) => true));
      });
    });
  }

  Widget _timeSpanSelector(String label, int numDays) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
        child: RaisedButton(
          child: Text(label),
          onPressed: () {
            daysBeforeTodayToShowCompletedTasks = numDays;
            fetchCompletedTasksFromServer();
          },
        ),
      ),
    );
  }

  _completedTaskCheckbox(CompletedTaskInfo completedTask) {
    bool isEnabled = app.loggedInUser.userID == completedTask.userWhoCompleted.userID ||
        app.loggedInUser.userID == completedTask.parentGroupManagerID;
    return isEnabled
        ? Checkbox(
            value: _myTasksCheckboxes[completedTask.taskID] ?? true,
            onChanged: (value) {
              setState(() {
                _myTasksCheckboxes[completedTask.taskID] = false;
                app.tasksManager
                    .unCompleteTask(parentGroupID: completedTask.parentGroupID, taskID: completedTask.taskID)
                    .then((val) {
                  fetchCompletedTasksFromServer();
                });
              });
            })
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(Icons.check_box, color: Theme.of(context).disabledColor),
          );
  }

  _getExpansionPanels(BuildContext context) {
    List<ExpansionPanel> _expansionPanels = new List();

    //Tasks assigned to me
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Center(child: Text('Tasks assigned to me', style: Theme.of(context).textTheme.title));
      },
      body: getTasksAssignedToMe(),
      isExpanded: _myTasksIsExpanded,
    ));

    //Other's tasks
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Center(child: Text('Tasks assigned to others', style: Theme.of(context).textTheme.title));
      },
      body: getTasksAssignedToOthers(),
      isExpanded: _othersTasksIsExpanded,
    ));

    //Future tasks
    if (app.getLoggedInUserID() == groupInfo.managerID) {
      _expansionPanels.add(_futureTasksExpansionPanel(context));
    }

    //Completed tasks
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Stack(
          children: <Widget>[
            Center(child: Text('Completed tasks', style: Theme.of(context).textTheme.title)),
            Positioned(
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => fetchCompletedTasksFromServer(),
              ),
              right: 0.0,
            ),
          ],
        );
      },
      body: getCompletedTasks(),
      isExpanded: _completedTasksIsExpanded,
    ));

    return _expansionPanels;
  }

  ExpansionPanel _futureTasksExpansionPanel(BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Center(child: Text('Future tasks', style: Theme.of(context).textTheme.title));
      },
      body: getFutureTasks(),
      isExpanded: _futureTasksIsExpanded,
    );
  }

  getFutureTasks() {
    List<ShortTaskInfo> _futureTasks = new List();
    if (_allGroupTasks != null) {
      _futureTasks = List.from(_allGroupTasks.where((taskInfo) => taskInfo.startTime.isAfter(DateTime.now())));
    }
    Padding noFutureTasks = Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Center(child: Text("There are no future tasks in this group")),
    );
    if (_futureTasks == null) return Text('Fetching tasks from server...');
    if (_futureTasks.length == 0) return noFutureTasks;
    List<Widget> tasksList = new List();
    _futureTasks.forEach((taskInfo) {
      tasksList.add(ListTile(
        title: Text('${taskInfo.title} (${taskInfo.value.toString()})'),
        subtitle: Text(taskInfo.description ?? "no description", maxLines: 3),
        onTap: () {
          app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
          });
        },
      ));
    });
    return Column(
      children: tasksList.length > 0 ? tasksList : [noFutureTasks],
    );
  }
}
