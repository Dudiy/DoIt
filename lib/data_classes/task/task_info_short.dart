import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class ShortTaskInfo {
  String _taskID;
  String _title;
  String _description;
  int _value;
  String _parentGroupID;
  String _parentGroupManagerID;
  DateTime _startTime;
  DateTime _endTime;
  Map<String, ShortUserInfo> _assignedUsers;

  ShortTaskInfo(
      {@required taskID,
      @required title,
      @required description,
      @required value,
      @required parentGroupID,
      @required parentGroupManagerID,
      @required startTime,
      @required endTime,
      @required assignedUsers}) {
    this._taskID = taskID;
    this._title = title;
    this._description = description;
    this._value = value;
    this._parentGroupID = parentGroupID;
    this._parentGroupManagerID = parentGroupManagerID;
    this._startTime = startTime;
    this._endTime = endTime;
    this._assignedUsers = UserUtils.generateUsersMapFromObject(assignedUsers);
  }

  String get taskID => _taskID;

  String get title => _title;

  // ignore: unnecessary_getters_setters
  String get description => _description;

  int get value => _value;

  String get parentGroupID => _parentGroupID;

  String get parentGroupManagerID => _parentGroupManagerID;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================

  // ignore: unnecessary_getters_setters
  set description(String value) => _description = value;

  set value(int value) {
    if (value >= 0) _value = value;
  }

  set startTime(DateTime value) {
    if (value != null) {
      if (_startTime.isAfter(_endTime)) {
        _endTime = null;
      }
    }
  }

  set endTime(DateTime value) {
    DateTime newEndTime = value;
    if (newEndTime != null && _startTime.isAfter(newEndTime))
      throw ArgumentError('End time cannot be before start time');
    _endTime = value;
  }
}
