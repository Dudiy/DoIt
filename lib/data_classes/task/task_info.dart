import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class TaskInfo {
  String _taskID;
  String _title;

  set title(String value) {
    _title = value;
  }

  String _description;
  int _value;
  String _parentGroupID;
  String _parentGroupManagerID;
  bool _isCompleted = false;
  String _startTime;
  String _endTime;
  Map<String, dynamic> _recurringPolicy;
  Map<String, ShortUserInfo> _assignedUsers;

  TaskInfo({
    @required taskID,
    @required title,
    @required description,
    @required value,
    @required parentGroupID,
    @required parentGroupManagerID,
    isCompleted,
    startTime,
    endTime,
    recurringPolicy,
    assignedUsers,
  }) {
    this._taskID = taskID;
    this._title = title;
    this._description = description;
    this._value = value;
    this._parentGroupID = parentGroupID;
    this._parentGroupManagerID = parentGroupManagerID;
    this._isCompleted = isCompleted;
    this._startTime = startTime;
    this._endTime = endTime;
    this._recurringPolicy = recurringPolicy;
    this._assignedUsers = UserUtils.generateUsersMapFromObject(assignedUsers);
  }

  ShortTaskInfo getShortTaskInfo() {
    return new ShortTaskInfo(
      taskID: taskID,
      title: title,
      value: value,
      parentGroupID: parentGroupID,
      parentGroupManagerID: parentGroupManagerID,
      isCompleted: isCompleted,
      startTime: startTime /*.toString()*/, // TODO delete commented
      endTime: endTime /*.toString()*/,
      assignedUsers: assignedUsers,
    );
  }

  // ===========================================================
  // ========================= Getters =========================
  // ===========================================================
  String get taskID => _taskID;

  String get title => _title;

  String get description => _description;

  int get value => _value;

  String get parentGroupID => _parentGroupID;

  String get parentGroupManagerID => _parentGroupManagerID;

  bool get isCompleted => _isCompleted;

  String get startTime => _startTime;

  String get endTime => _endTime;

  Map<String, dynamic> get recurringPolicy => _recurringPolicy;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================
  set description(String value) => _description = value;

  set value(int value) {
    if (value >= 0) _value = value;
  }

  set isCompleted(bool value) {
    if (value != null) _isCompleted = value;
  }

  set startTime(String value) {
    if (value != null) {
      _startTime = value;
      DateTime startTime, endTime;
      if (_startTime != null && _startTime.isNotEmpty) {
        startTime = DateTime.parse(_startTime);
      }
      if (_endTime != null && _endTime.isNotEmpty) {
        endTime = DateTime.parse(_endTime);
      }
      if (startTime != null && endTime != null && startTime.isAfter(endTime)) {
        _endTime = null;
      }
    }
  }

  set endTime(String value) {
    DateTime startTime, newEndTime;
    if (_startTime != null && _startTime.isNotEmpty) {
      startTime = DateTime.parse(_startTime);
    }
    if (value != null && value.isNotEmpty) {
      newEndTime = DateTime.parse(value);
    }
    if (startTime != null && newEndTime != null && startTime.isAfter(newEndTime))
      throw ArgumentError('End time cannot be before start time');
    _endTime = value;
  }

  set recurringPolicy(Map<String, dynamic> value) {
    _recurringPolicy = {
      'weekly': value['weekly'] ?? false,
      'daily': value['daily'] ?? false,
      'monthly': value['monthly'] ?? false,
      'yearly': value['yearly'] ?? false,
    };
  }

  set assignedUsers(Map<String, ShortUserInfo> value) {
    if (value != null) {
      _assignedUsers = value;
    }
  }
}

// TODO implement
class CompletedTaskInfo {}
