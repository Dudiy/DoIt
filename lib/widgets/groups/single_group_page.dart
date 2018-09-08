import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/task_manager_exception.dart';
import 'package:do_it/data_managers/task_manager_result.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/recurring_policy_field.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/groups/group_details_page.dart';
import 'package:do_it/widgets/tasks/task_card.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
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
  static const LOADING_GIF = 'assets/loading_anim_high.gif';
  static const DEFAULT_PICTURE = 'assets/images/default_group_icon.jpg';
  final App app = App.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String photoUrl = DEFAULT_PICTURE;
  List<ShortTaskInfo> _allGroupTasks;
  List<CompletedTaskInfo> _completedTasks;
  GroupInfo groupInfo;
  bool _myTasksIsExpanded = true;
  bool _othersTasksIsExpanded = false;
  bool _completedTasksIsExpanded = false;
  bool _futureTasksIsExpanded = false;
  int daysBeforeTodayToShowCompletedTasks;
  OverlayEntry loadingOverlayEntry;
  LoadingOverlay loadingOverlay = new LoadingOverlay();

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
        key: scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  groupInfo.title,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                background: Center(
                  child: GestureDetector(
                    onTap: () {
                      App.instance.groupsManager
//                          .uploadGroupPic(groupInfo, () => showLoadingOverlay(context))
                          .uploadGroupPic(groupInfo,
                              () => loadingOverlay.show(context: context, message: "Updating group photo..."))
                          .then((val) {
                        setState(() {
                          photoUrl = groupInfo.photoUrl;
                          loadingOverlay.hide();
//                          loadingOverlayEntry.remove();
                        });
                      });
                    },
                    child: ImageContainer(
                      imagePath: photoUrl,
                      size: 130.0,
                      borderColor: Colors.white,
                    ),
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: _getPopupMenuItems,
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _groupTaskTabs(context),
                Container(height: 80.0), //container added so the add task button doesn't hide an expansion panel
              ]),
            )
          ],
        ),
        floatingActionButton: _drawAddTaskButton());
  }

  // callback method
  setGroupInfo(GroupInfo groupInfoTest) {
    setState(() {
      this.groupInfo.photoUrl = groupInfoTest.photoUrl;
    });
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
//        _myTasksCheckboxes
//            .addAll(Map.fromIterable(tasks, key: (task) => (task as ShortTaskInfo).taskID, value: (task) => false));
      });
    });
  }

  int _getNumTasksAssignedToMe() {
    return (_allGroupTasks == null)
        ? null
        : _allGroupTasks.where((taskInfo) {
            return (taskInfo.startTime.isBefore(DateTime.now())) &&
                (taskInfo.assignedUsers == null ||
                    taskInfo.assignedUsers.length == 0 ||
                    taskInfo.assignedUsers.containsKey(app.loggedInUser.userID));
          }).length;
  }

  int _getNumTasksAssignedToOthers() {
    return (_allGroupTasks == null)
        ? null
        : _allGroupTasks.where((taskInfo) {
            return taskInfo.startTime.isBefore(DateTime.now()) &&
                taskInfo.assignedUsers != null &&
                taskInfo.assignedUsers.length != 0 &&
                !taskInfo.assignedUsers.containsKey(app.loggedInUser.userID);
          }).length;
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
    _myTasks.sort((task1, task2) => TaskUtils.compare(task1, task2));
    _myTasks.forEach((taskInfo) {
      if (taskInfo.assignedUsers == null ||
          taskInfo.assignedUsers.length == 0 ||
          taskInfo.assignedUsers.containsKey(app.loggedInUser.userID)) {
        tasksList.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TaskCard(
              taskInfo: taskInfo,
              parentScaffoldKey: scaffoldKey,
              onTapped: () {
                app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
                });
              },
              onCompleted: fetchCompletedTasksFromServer),
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
        tasksList.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TaskCard(
              taskInfo: taskInfo,
              parentScaffoldKey: scaffoldKey,
              showCheckbox: false,
              onTapped: () {
                if (app.loggedInUser.userID == taskInfo.parentGroupManagerID) {
                  app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
                  });
                }
              },
              onCompleted: fetchCompletedTasksFromServer),
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
      tasksList.add(
        TaskCard(
            taskInfo: completedTask,
            parentScaffoldKey: scaffoldKey,
            showCheckbox: app.loggedInUser.userID == completedTask.userWhoCompleted.userID ||
                app.loggedInUser.userID == completedTask.parentGroupManagerID,
            isChecked: true,
            onTapped: () {},
            onCompleted: () => fetchCompletedTasksFromServer()),
      );
    });
    return Padding(padding: EdgeInsets.all(20.0), child: Column(children: tasksList));
  }

  Future<void> _showAddTaskDialog() async {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    TextEditingController _valueController = new TextEditingController();
    eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;
    DateTime _selectedStartTime, _selectedEndTime;

    DoItDialogs.showUserInputDialog(
        context: context,
        inputWidgets: [
          DoItTextField(
            controller: _titleController,
            label: 'Title',
            isRequired: true,
          ),
          DoItTextField(
            controller: _valueController,
            isRequired: true,
            label: 'Task value',
            keyboardType: TextInputType.numberWithOptions(),
            fieldValidator: (value) => int.tryParse(value) != null && int.parse(value) > 0,
            validationErrorMsg: 'Task value must be a posiyive integer',
          ),
          DoItTextField(
            controller: _descriptionController,
            label: 'Description',
            isRequired: false,
          ),
          DoItTimeField(
            label: 'Start time',
            onDateTimeUpdated: (selectedDateTime) {
              _selectedStartTime = selectedDateTime;
            },
          ),
          DoItTimeField(
            label: 'End time',
            onDateTimeUpdated: (selectedDateTime) {
              _selectedEndTime = selectedDateTime;
            },
          ),
          DoItRecurringPolicyField(onPolicyUpdated: (selectedPolicy) {
            _selectedPolicy = selectedPolicy;
          }),
        ],
        title: 'Add task',
        onSubmit: () async {
          bool closeDialog = true;
          await app.tasksManager
              .addTask(
            title: _titleController.text,
            description: _descriptionController.text,
            value: int.parse(_valueController.text),
            startTime: _selectedStartTime,
            endTime: _selectedEndTime,
            assignedUsers: null,
            recurringPolicy: _selectedPolicy,
            parentGroupID: groupInfo.groupID,
            parentGroupManagerID: groupInfo.managerID,
          )
              .catchError((error) {
            print(error.toString());
            if (error is TaskException) {
              DoItDialogs.showErrorDialog(
                context: context,
                message: TaskMethodResultUtils.message(error.result),
              );
            }
            closeDialog = false;
          });
          if (closeDialog) {
            Navigator.pop(context);
          }
        });
  }

  void _updateTasksList(DocumentSnapshot documentSnapshotGroupTasks) {
    ShortUserInfo loggedInUser = App.instance.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    if (documentSnapshotGroupTasks.data != null) {
      setState(() {
        _allGroupTasks = GroupUtils.conventDBGroupTaskToObjectList(documentSnapshotGroupTasks);
      });
    }
  }

  /// different behavior on the other user permission
  void deleteGroup() {
    DoItDialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you would like to delete this group? \nThis cannot be undone',
      isWarning: true,
      actionButtonText: 'Delete',
    ).then((deleteConfirmed) {
      if (deleteConfirmed) {
        app.groupsManager.deleteGroup(groupID: groupInfo.groupID);
        Navigator.pop(context);
      }
    });
  }

  void leaveGroup() {
    DoItDialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you would like to leave this group? \nThis cannot be undone',
      isWarning: true,
      actionButtonText: 'Leave',
    ).then((deleteConfirmed) {
      if (deleteConfirmed) {
        app.groupsManager.deleteUserFromGroup(groupInfo.groupID, app.loggedInUser.userID);
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

  _getExpansionPanels(BuildContext context) {
    List<ExpansionPanel> _expansionPanels = new List();
    String numTasksAssignedToMeStr =
        _getNumTasksAssignedToMe() != null ? '(${_getNumTasksAssignedToMe().toString()})' : '(?)';
    String numTasksAssignedToOthersStr =
        _getNumTasksAssignedToOthers() != null ? '(${_getNumTasksAssignedToOthers().toString()})' : '(?)';
    //Tasks assigned to me
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Center(
            child: Text(
          'Tasks assigned to me $numTasksAssignedToMeStr',
          style: Theme.of(context).textTheme.title,
        ));
      },
      body: getTasksAssignedToMe(),
      isExpanded: _myTasksIsExpanded,
    ));

    //Other's tasks
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Center(
            child: Text('Tasks assigned to others $numTasksAssignedToOthersStr',
                style: Theme.of(context).textTheme.title));
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
          alignment: Alignment.center,
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
      tasksList.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: TaskCard(
          taskInfo: taskInfo,
          parentScaffoldKey: scaffoldKey,
          showCheckbox: false,
          isChecked: false,
          onTapped: () {
            app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
            });
          },
          onCompleted: fetchCompletedTasksFromServer,
        ),
      ));
    });
    return Column(
      children: tasksList.length > 0 ? tasksList : [noFutureTasks],
    );
  }

  List<PopupMenuEntry<String>> _getPopupMenuItems(BuildContext context) {
    List<PopupMenuEntry<String>> _menuItems = new List();
    _menuItems.add(_getGroupInfoMenuItem(context));
    _menuItems.add(PopupMenuDivider());
    if (app.loggedInUser.userID == widget.groupInfo.managerID) {
      _menuItems.add(_getDeleteGroupMenuItem(context));
    } else {
      _menuItems.add(_getLeaveGroupMenuItem(context));
    }
    return _menuItems;
  }

  PopupMenuEntry<String> _getGroupInfoMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'deleteGroup',
      child: ListTile(
          leading: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
          title: Text('Group info'),
          onTap: () async {
            ShortUserInfo managerInfo = await app.usersManager.getShortUserInfo(groupInfo.managerID);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupDetailsPage(groupInfo, managerInfo, _groupInfoChanged, setGroupInfo)));
          }),
    );
  }

  PopupMenuEntry<String> _getDeleteGroupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'deleteGroup',
      child: ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Delete group'),
          onTap: () async {
            Navigator.pop(context); // close popup dialog
            deleteGroup();
          }),
    );
  }

  PopupMenuEntry<String> _getLeaveGroupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'leaveGroup',
      child: ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text('Leave group'),
          onTap: () {
            Navigator.pop(context); // close popup dialog
            leaveGroup();
          }),
    );
  }

  void showLoadingOverlay(BuildContext context) {
//    Navigator.of(context).push((MaterialPageRoute(builder: (context) => LoadingPage())))
    OverlayState overlayState = Overlay.of(context);
    loadingOverlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Updating group photo...",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      );
    });
    overlayState.insert(loadingOverlayEntry);
  }
}
