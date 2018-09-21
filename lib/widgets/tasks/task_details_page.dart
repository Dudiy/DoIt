import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/recurring_policy_field.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/custom/time_field.dart';
import 'package:do_it/widgets/nfc/nfc_write_widget.dart';
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
  bool editEnabled;
  Map<String, ShortUserInfo> _parentGroupMembers;
  Map<String, ShortUserInfo> _assignedUsers;
  DateTime _selectedStartDateTime, _selectedEndDateTime;
  eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;

  @override
  void initState() {
    var taskInfo = widget.taskInfo;
    editEnabled = app.loggedInUser.userID == taskInfo.parentGroupManagerID;
    _taskIDController.text = taskInfo.taskID;
    _titleController.text = taskInfo.title;
    _descriptionController.text = taskInfo.description;
    _valueController.text = taskInfo.value.toString();
    _selectedStartDateTime = taskInfo.startTime;
    _selectedEndDateTime = taskInfo.endTime;
    _selectedPolicy = taskInfo.recurringPolicy;
    app.groupsManager.getGroupInfoByID(taskInfo.parentGroupID).then((parentGroupInfo) {
      setState(() {
        _parentGroupMembers = parentGroupInfo.members;
        _assignedUsers = taskInfo.assignedUsers == null || taskInfo.assignedUsers.length == 0
            ? Map.from(_parentGroupMembers)
            : taskInfo.assignedUsers;
      });
    });
    super.initState();
  }

  List<Widget> _drawActionsBar() {
    List<Widget> actions = new List();
    if (editEnabled) {
      actions.add(_getSaveButton());
      actions.add(new PopupMenuButton<String>(
        onSelected: (String result) {/*setState(() { _selection = result; });*/},
        itemBuilder: _getPopupMenuItems,
      ));
    }

    return actions;
  }

  List<PopupMenuEntry<String>> _getPopupMenuItems(BuildContext context) {
    List<PopupMenuEntry<String>> _menuItems = new List();
    if (editEnabled) {
      _menuItems.addAll([
        _getWriteToNfcMenuItem(context),
//        PopupMenuDivider(),
        _getNotifyUsersMenuItem(context),
//        PopupMenuDivider(),
        _getDeleteTaskMenuItem(context),
      ]);
    }
    return _menuItems;
  }

  Widget _getSaveButton() {
    return IconButton(
      icon: Icon(Icons.save, color: Colors.white),
      tooltip: 'Save changes',
      splashColor: app.themeData.primaryColorLight,
      onPressed: () async {
        try {
          if (_formKey.currentState.validate()) {
            await app.tasksManager
                .updateTask(
              taskIdToChange: widget.taskInfo.taskID,
              title: _titleController.text.isNotEmpty ? _titleController.text : null,
              description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
              value: _valueController.text.isNotEmpty ? int.parse(_valueController.text) : null,
              startTime: _selectedStartDateTime,
              endTime: _selectedEndDateTime,
              recurringPolicy: _selectedPolicy,
            )
                .then((newGroupInfo) {
              // TODO check if we need this
              //            widget.onTaskInfoChanged(newGroupInfo);
            });
            Navigator.pop(context);
          }
        } catch (e) {
          DoItDialogs.showErrorDialog(context: context, message: e.message);
        }
      },
    );
  }

  Widget _getSaveMenuItem(context) {
    return PopupMenuItem(
      value: 'save',
      child: Container(
        color: Colors.white70,
        child: ListTile(
          leading: Icon(Icons.save, color: app.themeData.primaryColor),
          title: Text('Save'),
          onTap: () async {
            await app.tasksManager
                .updateTask(
              taskIdToChange: widget.taskInfo.taskID,
              title: _titleController.text.isNotEmpty ? _titleController.text : null,
              description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
              value: _valueController.text.isNotEmpty ? int.parse(_valueController.text) : null,
              startTime: _selectedStartDateTime,
              endTime: _selectedEndDateTime,
              recurringPolicy: _selectedPolicy,
            )
                .then((newGroupInfo) {
              // TODO check if we need this
//            widget.onTaskInfoChanged(newGroupInfo);
            });
            Navigator.popUntil(context, ModalRoute.withName('/singleGroupPage'));
          },
        ),
      ),
    );
  }

  Widget _getDeleteTaskMenuItem(context) {
    return PopupMenuItem(
      value: 'deleteTask',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete task'),
            onTap: () async {
              DoItDialogs.showConfirmDialog(
                context: context,
                message: 'Are you sure you would like to delete this task? \nThis cannot be undone',
                isWarning: true,
                actionButtonText: 'Delete',
              ).then((deleteConfirmed) {
                if (deleteConfirmed) {
                  app.tasksManager.deleteTask(widget.taskInfo.taskID);
                  Navigator.popUntil(context, ModalRoute.withName('/singleGroupPage'));
                }
              });
            }),
      ),
    );
  }

  Widget _getWriteToNfcMenuItem(context) {
    return PopupMenuItem(
      value: 'writeToNfc',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.nfc, color: app.themeData.primaryColor),
            title: Text('Write to NFC'),
            onTap: () {
              NfcWriter nfcWriter = new NfcWriter(widget.taskInfo.taskID);
              nfcWriter.enableWrite();
              showDialog(context: context, builder: (context){
                return SimpleDialog(
                  title: Center(child: Text("Ready to write")),
                  children: <Widget>[
                    Image.asset("assets/images/scan_nfc.png"),
                    Center(child: Text("Hold phone over NFC tag")),
                  ],
                );
              }).whenComplete((){
                nfcWriter.disableWrite();
              });
            }),
      ),
    );
  }

  Widget _getNotifyUsersMenuItem(context) {
    TextEditingController _notificationController = new TextEditingController();
    DoItTextField notificationMessage = DoItTextField(
      label: 'Notification message',
      controller: _notificationController,
      maxLines: 3,
      maxLength: 30,
      isRequired: true,
    );
    return PopupMenuItem(
      value: 'notify',
      child: Container(
        color: Colors.white70,
        child: ListTile(
            leading: Icon(Icons.comment, color: app.themeData.primaryColor),
            title: Text('Notify users'),
            onTap: () {
              DoItDialogs.showUserInputDialog(
                context: context,
                inputWidgets: [notificationMessage],
                title: 'Send notification',
                onSubmit: () async {
                  List<String> _tokens = await _getAssignedUsersTokens();
                  Navigator.pop(context); // hide menu items popup
                  app.notifier.sendNotifications(
                    title: 'Notification from task \"${widget.taskInfo.title}\"',
                    body: _notificationController.text,
                    destUsersFcmTokens: _tokens,
                  );
                  Navigator.pop(context);
                },
              );
            }),
      ),
    );
  }

  // returns null if users have'nt been fetched from the DB
  List<ShortUserInfo> _getAssignedUsers() {
    List<ShortUserInfo> list = new List();
    if (_assignedUsers == null || _assignedUsers.length == 0) {
      if (_parentGroupMembers != null) {
        list.addAll(_parentGroupMembers.values);
      }
    } else {
      list.addAll(_assignedUsers.values);
    }
    return list.length == 0 ? null : list;
  }

  List<Widget> _getAssignedUsersWidgets() {
    List<Widget> widgetsList = new List();
    List<ShortUserInfo> assignedUsers = _getAssignedUsers();
    widgetsList.add(Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
          ),
          color: app.themeData.primaryColorLight),
      child: Stack(
        children: <Widget>[
          _drawEditAssignedUsersButton(),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Center(
                    child: Text(
                  'Assigned users',
                  style: Theme.of(context).textTheme.subhead.copyWith(decoration: TextDecoration.underline),
                )),
              ),
            ),
          ),
        ],
      ),
    ));
    if (assignedUsers == null) {
      widgetsList.add(Center(child: Text(('Fetching assigned users from DB...'))));
    } else {
      assignedUsers.forEach((shortUserInfo) {
        widgetsList.add(ListTile(
          // TODO display with a nicer widget
          title: Text(
            shortUserInfo.displayName,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.body1,
          ),
        ));
      });
    }
    return widgetsList;
  }

  void _getAssignedUsersFromDB() {
    app.tasksManager.getTaskById(widget.taskInfo.taskID).then((taskInfo) {
      setState(() {
        _assignedUsers = Map.from(taskInfo.assignedUsers);
      });
    });
  }

  _drawEditAssignedUsersButton() {
    return app.loggedInUser.userID == widget.taskInfo.parentGroupManagerID
        ? Positioned(
            right: 10.0,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _showEditAssignedUsersDialog();
              },
            ),
          )
        : Container(height: 0.0, width: 0.0);
  }

  _showEditAssignedUsersDialog() {
    Map<String, dynamic> _updatedAssignedUsers = new Map();
    _parentGroupMembers.forEach((userID, userInfo) {
      _updatedAssignedUsers.putIfAbsent(
          userID,
          () => {
                'userInfo': userInfo,
                'isSelected': _assignedUsers.length == 0 ? true : false,
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

  void updateAssignedUsers(Map<String, dynamic> _selectedUsers) {
    Map<String, ShortUserInfo> _newAssignedUsers = new Map();
    bool allUsersChecked = true;
    for (var selectedUser in _selectedUsers.values) {
      if (!selectedUser['isSelected']) {
        allUsersChecked = false;
        break;
      }
    }
    // if all users are checked set assigned users to be an empty map
    if (!allUsersChecked) {
      _parentGroupMembers.forEach((userID, userInfo) {
        // add all checked users to the new assigned users map
        if (_selectedUsers[userID]['isSelected']) {
          _newAssignedUsers.putIfAbsent(userID, () => userInfo);
        }
      });
    }
    app.tasksManager
        .updateTask(taskIdToChange: widget.taskInfo.taskID, assignedUsers: _newAssignedUsers)
        .whenComplete(() {
      _getAssignedUsersFromDB();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.instance.themeData.primaryColor,
        title: Text(
          'Task \"${widget.taskInfo.title}\" details',
          maxLines: 2,
        ),
        titleSpacing: 0.0,
        actions: _drawActionsBar(),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        decoration: app.getBackgroundImage(),
        child: ListView(
          children: <Widget>[
            Container(
              child: Form(
                  key: _formKey,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    DoItTextField(label: 'Task ID', controller: _taskIDController, enabled: false),
                    DoItTextField(
                      controller: _titleController,
                      label: 'Title',
                      enabled: editEnabled,
                    ),
                    DoItTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      enabled: editEnabled,
                      maxLines: 3,
                    ),
                    DoItTextField(
                      keyboardType: TextInputType.number,
                      controller: _valueController,
                      label: 'Value',
                      enabled: editEnabled,
                    ),
                    DoItRecurringPolicyField(
                      enabled: editEnabled,
                      initPolicy: widget.taskInfo.recurringPolicy,
                      onPolicyUpdated: (selected) => _selectedPolicy = selected,
                    ),
                    DoItTimeField(
                      label: 'Start time',
                      initDateTime: widget.taskInfo.startTime,
                      enabled: editEnabled,
                      onDateTimeUpdated: (selectedDateTime) {
                        _selectedStartDateTime = selectedDateTime;
                      },
                    ),
                    DoItTimeField(
                      label: 'End time',
                      initDateTime: widget.taskInfo.endTime,
                      enabled: editEnabled,
                      onDateTimeUpdated: (selectedDateTime) {
                        setState(() {
                          _selectedEndDateTime = selectedDateTime;
                        });
                      },
                    ),
                  ])),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: Column(
                  children: _getAssignedUsersWidgets(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _getAssignedUsersTokens() async {
    List<Future> _tokenGetters = new List();
    List<String> _assignedUsersTokens = new List();
    List<ShortUserInfo> assignedUsers = _getAssignedUsers();
    assignedUsers.forEach((shortUserInfo) {
      if (shortUserInfo.userID != app.loggedInUser.userID) {
        _tokenGetters.add((app.usersManager.getFcmToken(shortUserInfo.userID).then((token) {
          _assignedUsersTokens.add(token);
        })));
      }
    });
    await Future.wait(_tokenGetters);
    return _assignedUsersTokens;
  }
}
