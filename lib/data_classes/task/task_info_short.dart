import 'dart:convert';

import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class ShortTaskInfo {
  String _taskID;
  String _title;
  int _value;
  String _parentGroupID;
  String _parentGroupManagerID;
  bool _isCompleted = false;
  String _startTime;
  String _endTime;
  Map<String, ShortUserInfo> _assignedUsers;

  ShortTaskInfo(
      {@required taskID,
      @required title,
      @required value,
      @required parentGroupID,
      @required parentGroupManagerID,
      @required isCompleted,
      @required startTime,
      @required endTime,
      @required assignedUsers}) {
    this._taskID = taskID;
    this._title = title;
    this._value = value;
    this._parentGroupID = parentGroupID;
    this._parentGroupManagerID = parentGroupManagerID;
    this._isCompleted = isCompleted;
    this._startTime = startTime;
    this._endTime = endTime;
    this._assignedUsers = UserUtils.generateUsersMapFromObject(assignedUsers);
  }

  String get taskID => _taskID;

  String get title => _title;

  int get value => _value;

  String get parentGroupID => _parentGroupID;

  String get parentGroupManagerID => _parentGroupManagerID;

  bool get isCompleted => _isCompleted;

  String get startTime => _startTime;

  String get endTime => _endTime;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================
  set value(int value) {
    if (value >= 0) _value = value;
  }

  set isCompleted(bool value) {
    if (value != null) _isCompleted = value;
  }

  set startTime(String value) {
    if (value != null) {
      _startTime = value;
      DateTime startTime = DateTime.parse(_startTime);
      DateTime endTime = DateTime.parse(_endTime);
      if (startTime.isAfter(endTime)) {
        _endTime = null;
      }
    }
  }

  set endTime(String value) {
    DateTime startTime = DateTime.parse(_startTime);
    DateTime newEndTime = DateTime.parse(value);
    if (startTime.isAfter(newEndTime)) throw ArgumentError('End time cannot be before start time');
    _endTime = value;
  }
}
