import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class TaskInfo {
  String _taskID;
  String _title;
  String _description;
  int _value;
  String _parentGroupID;
  String _parentGroupManagerID;
  DateTime _startTime;
  DateTime _endTime;
  eRecurringPolicy _recurringPolicy;
  Map<String, ShortUserInfo> _assignedUsers;

  TaskInfo({
    @required taskID,
    @required title,
    @required description,
    @required value,
    @required parentGroupID,
    @required parentGroupManagerID,
    startTime,
    endTime,
    recurringPolicy = eRecurringPolicy.none,
    assignedUsers,
  }) {
    this._taskID = taskID;
    this._title = title;
    this._description = description;
    this._value = value;
    this._parentGroupID = parentGroupID;
    this._parentGroupManagerID = parentGroupManagerID;
    this._startTime = startTime;
    this._endTime = endTime;
    this._recurringPolicy = recurringPolicy;
    this._assignedUsers = UserUtils.generateUsersMapFromObject(assignedUsers);
  }

  ShortTaskInfo getShortTaskInfo() {
    return new ShortTaskInfo(
      taskID: taskID,
      title: title,
      description: description,
      value: value,
      parentGroupID: parentGroupID,
      parentGroupManagerID: parentGroupManagerID,
      startTime: startTime,
      endTime: endTime,
      assignedUsers: assignedUsers,
    );
  }

  // ===========================================================
  // ========================= Getters =========================
  // ===========================================================
  String get taskID => _taskID;

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  String get description => _description;

  int get value => _value;

  String get parentGroupID => _parentGroupID;

  String get parentGroupManagerID => _parentGroupManagerID;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  // ignore: unnecessary_getters_setters
  eRecurringPolicy get recurringPolicy => _recurringPolicy;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================
  // ignore: unnecessary_getters_setters
  set description(String value) => _description = value;

  // ignore: unnecessary_getters_setters
  set title(String value) => _title = value;

  set value(int value) {
    if (value >= 0) _value = value;
  }

  set startTime(DateTime value) {
    if (value != null) {
      _startTime = value;
      if (startTime != null && endTime != null && startTime.isAfter(endTime)) {
        _endTime = null;
      }
    }
  }

  set endTime(DateTime value) {
    DateTime newEndTime = value;
    if (startTime != null &&
        newEndTime != null &&
        startTime.isAfter(newEndTime))
      throw ArgumentError('End time cannot be before start time');
    _endTime = value;
  }

  // ignore: unnecessary_getters_setters
  set recurringPolicy(eRecurringPolicy value) => _recurringPolicy = value;

  set assignedUsers(Map<String, ShortUserInfo> value) {
    if (value != null) {
      _assignedUsers = value;
    }
  }

  CompletedTaskInfo generateCompletedTaskInfo(
      {@required ShortUserInfo userWhoCompleted}) {
    return CompletedTaskInfo(
      taskID: App.instance.generateRandomID(),
      title: title,
      value: value,
      description: description,
      parentGroupID: parentGroupID,
      parentGroupManagerID: parentGroupManagerID,
      completedTime: DateTime.now(),
      userWhoCompleted: userWhoCompleted,
    );
  }
}
