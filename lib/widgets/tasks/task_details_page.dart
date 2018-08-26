import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/nfc_write_widget.dart';
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
  DateTime _selectedStartDate, _selectedEndDate;
  TimeOfDay _selectedStartTime, _selectedEndTime;
  eRecurringPolicy _selectedPolicy = eRecurringPolicy.none;

  @override
  void initState() {
    var taskInfo = widget.taskInfo;
    editEnabled = app.loggedInUser.userID == taskInfo.parentGroupManagerID;
    _taskIDController.text = taskInfo.taskID;
    _titleController.text = taskInfo.title;
    _descriptionController.text = taskInfo.description;
    _valueController.text = taskInfo.value.toString();
    _selectedStartDate = taskInfo.startTime;
    _selectedStartTime = taskInfo.startTime != null ? TimeOfDay.fromDateTime(taskInfo.startTime) : null;
    _selectedEndDate = taskInfo.endTime;
    _selectedEndTime = taskInfo.endTime != null ? TimeOfDay.fromDateTime(taskInfo.endTime) : null;
    _startTimeController.text = _formatDateTime(taskInfo.startTime);
    _endTimeController.text = _formatDateTime(taskInfo.endTime);
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

  Future<DateTime> _selectDate(BuildContext context, DateTime initDate) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initDate ?? DateTime.now(),
      firstDate: new DateTime(2017, 1),
      lastDate: new DateTime(2050),
    );
    return picked != null && picked != initDate ? picked : initDate;
  }

  Future<TimeOfDay> _selectTime(BuildContext context, DateTime initDate) async {
    TimeOfDay initTime = initDate != null ? TimeOfDay.fromDateTime(initDate) : TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(context: context, initialTime: initTime);
    return picked != null && picked != initTime ? picked : initTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return dateTime == null
        ? "Time not set"
        : '${dateTime.day}/${dateTime.month}/${dateTime.year} - '
        '${dateTime.hour > 9 ? dateTime.hour : '0${dateTime.hour}'}:'
        '${dateTime.minute > 9 ? dateTime.minute : '0${dateTime.minute}'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task \"${widget.taskInfo.title}\" details',
          maxLines: 2,
        ),
        titleSpacing: 0.0,
        actions: drawActions(),
      ),
      body: ListView(
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
                  _recurringPolicyField(),
                  _timeField(
                    label: 'Start time',
                    controller: _startTimeController,
                    onPressed: () => _setStartTime(context),
                  ),
                  _timeField(
                    label: 'End time',
                    controller: _endTimeController,
                    onPressed: () => _setEndTime(context),
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
              ),
              child: Column(
                children: getAssignedUsers(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setEndTime(BuildContext context) {
    _selectDate(context, widget.taskInfo.endTime).then((selectedDate) {
      _selectedEndDate = selectedDate;
      _selectTime(context, widget.taskInfo.endTime).then((selectedTime) {
        _selectedEndTime = selectedTime;
        setState(() {
          _selectedEndDate = _getSelectedDateTime(selectedDate, selectedTime);
          _endTimeController.text = _formatDateTime(_selectedEndDate);
        });
      });
    });
  }

  void _setStartTime(BuildContext context) {
    _selectDate(context, widget.taskInfo.startTime).then((selectedDate) {
      _selectedStartDate = selectedDate;
      _selectTime(context, widget.taskInfo.startTime).then((selectedTime) {
        _selectedStartTime = selectedTime;
        setState(() {
          _selectedStartDate = _getSelectedDateTime(selectedDate, selectedTime);
          _startTimeController.text = _formatDateTime(_selectedStartDate);
        });
      });
    });
  }

  List<Widget> drawActions() {
    List<Widget> actions = new List();
    if (editEnabled) {
      actions.add(FlatButton(
        child: Icon(Icons.save, color: Colors.white),
        onPressed: () async {
          await app.tasksManager
              .updateTask(
            taskIdToChange: widget.taskInfo.taskID,
            title: _titleController.text.isNotEmpty ? _titleController.text : null,
            description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
            value: _valueController.text.isNotEmpty ? int.parse(_valueController.text) : null,
            startTime: _getSelectedDateTime(_selectedStartDate, _selectedStartTime),
            endTime: _getSelectedDateTime(_selectedEndDate, _selectedEndTime),
            recurringPolicy: _selectedPolicy,
          )
              .then((newGroupInfo) {
            // TODO check if we need this
//            widget.onTaskInfoChanged(newGroupInfo);
          });
          Navigator.pop(context);
        },
      ));
      // TODO add that if we have NFC
      actions.add(_getNfcWidget());
    }

    return actions;
  }

  List<Widget> getAssignedUsers() {
    List<Widget> list = new List();
    list.add(Container(
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: <Widget>[
          _drawEditAssignedUsersButton(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Text(
              'Assigned users',
              style: Theme.of(context).textTheme.title.copyWith(decoration: TextDecoration.underline),
            )),
          ),
        ],
      ),
    ));
    if (_assignedUsers == null || _assignedUsers.length == 0) {
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

  Widget _getNfcWidget() {
    return FlatButton(
      child: Icon(Icons.nfc, color: Colors.white),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NfcWritePage(widget.taskInfo.taskID)));
      },
    );
  }

  DateTime _getSelectedDateTime(DateTime selectedDate, TimeOfDay selectedTime) {
    if (selectedDate == null || selectedTime == null) {
      return null;
    } else {
      return DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    }
  }

  Widget _timeField({String label, TextEditingController controller, VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: controller,
                        enabled: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: label,
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: ButtonTheme(
                          height: 60.0,
                          minWidth: 20.0,
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(16.0),
                              )),
                              color: Theme.of(context).primaryColorLight,
                              child: Icon(Icons.date_range),
                              onPressed: () => onPressed()),
                        ),
                      ),
                    ],
                  )
                  /*DoItTextField(
                                label: 'Start time',
                                controller: _startTimeController,
                                enabled: false,
                                textAlign: TextAlign.center,
                              ),*/
                  )),
        ],
      ),
    );
  }

  Widget _recurringPolicyField() {
    Widget selector = editEnabled
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.center,
            child: DropdownButton(
              value: _selectedPolicy,
              items: eRecurringPolicy.values.map((policy) {
                return DropdownMenuItem(
                  value: policy,
                  child: Text(
                    RecurringPolicyUtils.policyToString(policy),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
              onChanged: (selected) {
                if (editEnabled) {
                  setState(() {
                    _selectedPolicy = selected;
                  });
                }
              },
            ),
          )
        : DoItTextField(
            label: 'Repeat',
            textAlign: TextAlign.center,
            enabled: false,
            initValue: RecurringPolicyUtils.policyToString(_selectedPolicy),
          );
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Repeat: '),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: selector,
            ),
          ),
        ],
      ),
    );
  }
}
