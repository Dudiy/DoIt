import 'dart:async';
import 'dart:io';

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
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/recurring_policy_field.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/custom/timespan_selector.dart';
import 'package:do_it/widgets/groups/group_details_page.dart';
import 'package:do_it/widgets/tasks/task_card.dart';
import 'package:do_it/widgets/tasks/task_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SingleGroupPage extends StatefulWidget {
  final GroupInfo groupInfo;

  SingleGroupPage(this.groupInfo);

  @override
  SingleGroupPageState createState() {
    return new SingleGroupPageState(groupInfo);
  }
}

class SingleGroupPageState extends State<SingleGroupPage> {
  static const LOADING_GIF = 'assets/doit_logo/loading_animation.gif';
  static const DEFAULT_PICTURE = 'assets/images/default_group_icon.jpg';
  final App app = App.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String photoUrl = DEFAULT_PICTURE;
  List<ShortTaskInfo> _allGroupTasks;
  Map<String, bool> _checkboxState;
  List<CompletedTaskInfo> _completedTasks;
  GroupInfo groupInfo;
  bool _myTasksIsExpanded = true;
  bool _othersTasksIsExpanded = false;
  bool _completedTasksIsExpanded = false;
  bool _futureTasksIsExpanded = false;
  int daysBeforeTodayToShowCompletedTasks;
  OverlayEntry loadingOverlayEntry;
  LoadingOverlay loadingOverlay = new LoadingOverlay();
  File groupImageFile;

// for remove groups listener
  StreamSubscription<DocumentSnapshot> _streamSubscriptionTasks;

  SingleGroupPageState(this.groupInfo);

  @override
  void initState() {
    _checkboxState = new Map();
    String groupId = groupInfo.groupID;
    // listen for tasks list update
    _streamSubscriptionTasks = App.instance.firestore.document('$GROUPS/$groupId').snapshots().listen(_updateTasksList);
    getGroupTasksFromDB();
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
      body: Container(
        decoration: app.getBackgroundImage(),
        child: RefreshIndicator(
          onRefresh: getGroupTasksFromDB,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: app.themeData.primaryColor.withOpacity(0.65),
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
                  background: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _groupImageClicked(context),
                        child: ImageContainer(
                          imagePath: photoUrl,
                          imageFile: groupImageFile,
                          size: 130.0,
                          borderColor: Colors.white,
                        ),
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
                  _getExpansionPanelList(context),
                  Container(height: 80.0), //container added so the add task button doesn't hide an expansion panel
                ]),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: (app.getLoggedInUserID() == groupInfo.managerID) ? _renderSpeedDial() : null,
    );
  }

  void _updateTasksList(DocumentSnapshot documentSnapshotGroupTasks) {
    ShortUserInfo loggedInUser = App.instance.loggedInUser;
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot update tasks list user is not logged in');
    }
    if (documentSnapshotGroupTasks.data != null) {
      setState(() {
        _allGroupTasks = GroupUtils.conventDBGroupTaskToObjectList(documentSnapshotGroupTasks);
      });
    }
  }

  void _groupImageClicked(BuildContext context) {
    App.instance.groupsManager
        .uploadGroupPic(groupInfo, () => loadingOverlay.show(context: context, message: "Updating group photo..."))
        .then((newPhoto) {
      loadingOverlay.hide();
      _groupPhotoChanged(newPhoto);
      setState(() {
        photoUrl = groupInfo.photoUrl;
      });
    });
  }

  void _groupInfoChanged(GroupInfo newGroupInfo, File newGroupImageFile) {
    setState(() {
      groupInfo = newGroupInfo;
      if (newGroupImageFile != null) {
        groupImageFile = newGroupImageFile;
      }
    });
  }

  void _groupPhotoChanged(File newImage) {
    setState(() {
      groupImageFile = newImage;
    });
  }

  Future getGroupTasksFromDB() async {
    app.groupsManager.getGroupTasksFromDB(groupInfo.groupID).then((tasks) {
      setState(() {
        _allGroupTasks = tasks;
      });
    });
  }

  Future<List<String>> _getGroupMembersTokens() async {
    List<Future> _tokenGetters = new List();
    List<String> _assignedUsersTokens = new List();
    groupInfo.members.values.forEach((shortUserInfo) {
      if (shortUserInfo.userID != app.loggedInUser.userID) {
        _tokenGetters.add((app.usersManager.getFcmToken(shortUserInfo.userID).then((token) {
          _assignedUsersTokens.add(token);
        })));
      }
    });
    await Future.wait(_tokenGetters);
    return _assignedUsersTokens;
  }

  Future<void> _showAddTaskDialog() async {
    TextEditingController _titleController = new TextEditingController();
    TextEditingController _descriptionController = new TextEditingController();
    TextEditingController _valueController = new TextEditingController();
    eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;
    DateTime _selectedStartTime, _selectedEndTime;
    const EdgeInsetsGeometry padding = EdgeInsets.all(4.0);

    DoItDialogs.showUserInputDialog(
        context: context,
        inputWidgets: [
          DoItTextField(
            controller: _titleController,
            label: 'Title',
            isRequired: true,
            textStyle: Theme.of(context).textTheme.body1,
            padding: padding,
          ),
          DoItTextField(
            controller: _valueController,
            isRequired: true,
            label: 'Task value',
            keyboardType: TextInputType.numberWithOptions(),
            fieldValidator: (value) => int.tryParse(value) != null && int.parse(value) > 0,
            validationErrorMsg: 'Task value must be a posiyive integer',
            textStyle: Theme.of(context).textTheme.body1,
            padding: padding,
          ),
          DoItTextField(
            controller: _descriptionController,
            label: 'Description',
            isRequired: false,
            textStyle: Theme.of(context).textTheme.body1,
            padding: padding,
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

  //region Expansion panels
  Padding _getExpansionPanelList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ExpansionPanelList(
        animationDuration: Duration(milliseconds: 600),
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

  _getExpansionPanels(BuildContext context) {
    List<ExpansionPanel> _expansionPanels = new List();
    //Tasks assigned to me
    _expansionPanels.add(_tasksAssignedToMePanel());
    //Other's tasks
    _expansionPanels.add(_tasksAssignedToOthersPanel());

    //Future tasks
    if (app.getLoggedInUserID() == groupInfo.managerID) {
      _expansionPanels.add(_futureTasksExpansionPanel(context));
    }

    //Completed tasks
    _expansionPanels.add(ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Row(
//          alignment: Alignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Completed tasks',
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => fetchCompletedTasksFromServer(),
            ),
          ],
        );
      },
      body: getCompletedTasks(),
      isExpanded: _completedTasksIsExpanded,
    ));
    return _expansionPanels;
  }

  ExpansionPanel _tasksAssignedToMePanel() {
    String numTasksAssignedToMeStr =
        _getNumTasksAssignedToMe() != null ? '(${_getNumTasksAssignedToMe().toString()})' : '(?)';

    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tasks assigned to me $numTasksAssignedToMeStr',
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.start,
          ),
        );
      },
      body: getTasksAssignedToMe(),
      isExpanded: _myTasksIsExpanded,
    );
  }

  ExpansionPanel _tasksAssignedToOthersPanel() {
    String numTasksAssignedToOthersStr =
        _getNumTasksAssignedToOthers() != null ? '(${_getNumTasksAssignedToOthers().toString()})' : '(?)';
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tasks assigned to others $numTasksAssignedToOthersStr',
            style: Theme.of(context).textTheme.title,
            textAlign: TextAlign.start,
          ),
        );
      },
      body: getTasksAssignedToOthers(),
      isExpanded: _othersTasksIsExpanded,
    );
  }

  ExpansionPanel _futureTasksExpansionPanel(BuildContext context) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Future tasks', style: Theme.of(context).textTheme.title),
        );
      },
      body: getFutureTasks(),
      isExpanded: _futureTasksIsExpanded,
    );
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
  //endregion

  //region Expansion panel bodies
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
          onCheckChanged: () => setState(() {}),
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
        _checkboxState.putIfAbsent(taskInfo.taskID, () => false);
        tasksList.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new TaskCard(
              taskInfo: taskInfo,
              parentScaffoldKey: scaffoldKey,
              isChecked: _checkboxState[taskInfo.taskID],
              showCheckbox: true,
              onCheckChanged: (bool value) {
                setState(() {
                  _checkboxState[taskInfo.taskID] = value;
                });
              },
              onTapped: () {
                app.tasksManager.getTaskById(taskInfo.taskID).then((taskInfo) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsPage(taskInfo)));
                });
              },
              onCompleted: () {
                if (taskInfo.recurringPolicy != eRecurringPolicy.none){
                  _checkboxState[taskInfo.taskID] = false;
                }
                fetchCompletedTasksFromServer();
              }),
        ));
      }
    });
    tasksList.add(SizedBox(height: 15.0));
    return Container(
      color: Colors.transparent,
      child: Column(
        children: tasksList.length > 0 ? tasksList : [noTasksAssignedToMe],
      ),
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
              onCheckChanged: () => setState(() {}),
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
    Widget timeSpanSelectors = TimeSpanSelector(
      onTimeSelectionChanged: (valueSelected) {
        daysBeforeTodayToShowCompletedTasks = valueSelected;
        fetchCompletedTasksFromServer();
      },
      timeSpans: {
        7: 'week',
        31: 'month',
        0: 'all time',
      },
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
      _checkboxState.putIfAbsent(completedTask.taskID, () => true);
      tasksList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TaskCard(
              taskInfo: completedTask,
              parentScaffoldKey: scaffoldKey,
              onCheckChanged: (bool value) {
                setState(() {
                  _checkboxState[completedTask.taskID] = value;
                });
              },
              showCheckbox: app.loggedInUser.userID == completedTask.userWhoCompleted.userID ||
                  app.loggedInUser.userID == completedTask.parentGroupManagerID,
              isChecked: _checkboxState[completedTask.taskID],
              onTapped: () {},
              onCompleted: () => fetchCompletedTasksFromServer()),
        ),
      );
    });
    return Column(children: tasksList);
  }

  void fetchCompletedTasksFromServer() {
    if (daysBeforeTodayToShowCompletedTasks == null || !_completedTasksIsExpanded) return;
    DateTime toDate = DateTime.now();
    DateTime fromDate = daysBeforeTodayToShowCompletedTasks != 0
        ? DateTime.now().add(Duration(days: -daysBeforeTodayToShowCompletedTasks))
        : null;
    app.groupsManager
        .getCompletedTasks(groupID: groupInfo.groupID, fromDate: fromDate, toDate: toDate)
        .then((completedTasks) {
      setState(() {
        _completedTasks = completedTasks;
      });
    });
  }
  //endregion

  //region Popup menu
  List<PopupMenuEntry<String>> _getPopupMenuItems(BuildContext context) {
    List<PopupMenuEntry<String>> _menuItems = new List();
    _menuItems.add(_getGroupInfoMenuItem(context));
//    _menuItems.add(PopupMenuDivider());
    if (app.loggedInUser.userID == groupInfo.managerID) {
      _menuItems.add(_getDeleteGroupMenuItem(context));
    } else {
      _menuItems.add(_getLeaveGroupMenuItem(context));
    }
    return _menuItems;
  }

  PopupMenuEntry<String> _getGroupInfoMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'deleteGroup',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.info_outline, color: app.themeData.primaryColor),
            title: Text(
              'Group info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              ShortUserInfo managerInfo = await app.usersManager.getShortUserInfo(groupInfo.managerID);
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GroupDetailsPage(groupInfo, managerInfo, _groupInfoChanged)));
            }),
      ),
    );
  }

  PopupMenuEntry<String> _getDeleteGroupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'deleteGroup',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete group', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () async {
              Navigator.pop(context); // close popup dialog
              deleteGroup();
            }),
      ),
    );
  }

  PopupMenuEntry<String> _getLeaveGroupMenuItem(BuildContext context) {
    return PopupMenuItem(
      value: 'leaveGroup',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Leave group'),
            onTap: () {
              Navigator.pop(context); // close popup dialog
              leaveGroup();
            }),
      ),
    );
  }
  //endregion

  //region Popup menu actions
  void deleteGroup() {
    DoItDialogs.showConfirmDialog(
      context: context,
      message: 'Are you sure you would like to delete this group? \nThis cannot be undone',
      isWarning: true,
      actionButtonText: 'Delete',
    ).then((deleteConfirmed) {
      if (deleteConfirmed) {
        loadingOverlay.show(context: context, message: "Deleting group...");
        app.groupsManager.deleteGroup(groupID: groupInfo.groupID).whenComplete(() {
          loadingOverlay.hide();
          Navigator.pop(context);
        });
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
        loadingOverlay.show(context: context, message: "Leaving group...");
        app.groupsManager.deleteUserFromGroup(groupInfo.groupID, app.loggedInUser.userID).whenComplete(() {
          loadingOverlay.hide();
          Navigator.pop(context);
        }).catchError((error){
          loadingOverlay.hide();
          Navigator.pop(context);
          DoItDialogs.showErrorDialog(context: context, message: "Error while trying to leave group, please try again.\nInner exception: ${error.message}");
        });
      }
    });
  }
  //endregion

  //region Speed Dial buttons
  Widget _renderSpeedDial() {
    return SpeedDial(
      backgroundColor: App.instance.themeData.primaryColor,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      children: [
        _newTaskSpeedDialChild(),
        _addMemberSpeedDialChild(),
        _sendNotificationSpeedDialChild(),
      ],
    );
  }

  SpeedDialChild _newTaskSpeedDialChild() {
    return SpeedDialChild(
      child: Icon(Icons.check_box, color: Colors.white),
      backgroundColor: Colors.blue,
      onTap: _showAddTaskDialog,
      label: 'new task',
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  SpeedDialChild _addMemberSpeedDialChild() {
    return SpeedDialChild(
      child: Icon(Icons.person_add, color: Colors.white),
      backgroundColor: Colors.green,
      onTap: () {
        DoItDialogs.showAddMemberDialog(
            context: context,
            groupInfo: groupInfo,
            onDialogSubmitted: (ShortUserInfo newMember) {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                "${newMember.displayName} has been added to this group",
                textAlign: TextAlign.center,
              )));
              setState(() {
                groupInfo.members.putIfAbsent(newMember.userID, () => newMember);
              });
            });
      },
      label: 'add member',
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  SpeedDialChild _sendNotificationSpeedDialChild() {
    return SpeedDialChild(
      child: Icon(Icons.message, color: Colors.white),
      backgroundColor: Colors.deepOrange,
      onTap: () {
        TextEditingController _notificationController = new TextEditingController();
        DoItTextField notificationMessage = DoItTextField(
          label: 'notification message',
          controller: _notificationController,
          maxLines: 3,
          maxLength: 30,
          isRequired: true,
        );
        DoItDialogs.showUserInputDialog(
          context: context,
          inputWidgets: [notificationMessage],
          title: 'Send notification',
          onSubmit: () async {
            List<String> _tokens = await _getGroupMembersTokens();
            Navigator.pop(context); // hide menu items popup
            app.notifier.sendNotifications(
              title: 'Notification from group \"${groupInfo.title}\"',
              body: _notificationController.text,
              destUsersFcmTokens: _tokens,
            );
          },
        );
      },
      label: 'notify members',
      labelStyle: TextStyle(fontWeight: FontWeight.w500),
    );
  }
  //endregion
}
