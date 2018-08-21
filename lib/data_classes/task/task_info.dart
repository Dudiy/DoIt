import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class TaskInfo {
  String _taskID;
  String _title;
  String _description;
  int _value;
  ShortGroupInfo _parentGroup;
  bool _isCompleted = false;
  String _startTime;
  String _endTime;
  Object _recurringPolicy;
  Map<String, ShortUserInfo> _assignedUsers;

  TaskInfo({
    @required taskID,
    @required title,
    @required description,
    @required value,
    @required parentGroup,
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
    this._parentGroup = parentGroup;
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
      parentGroup: parentGroup,
      isCompleted: isCompleted,
      startTime: startTime/*.toString()*/,  // TODO delete commented
      endTime: endTime/*.toString()*/,
      assignedUsers: assignedUsers,
    );
  }

  String get taskID => _taskID;

  String get title => _title;

  String get description => _description;

  int get value => _value;

  ShortGroupInfo get parentGroup => _parentGroup;

  bool get isCompleted => _isCompleted;

  String get startTime => _startTime;

  String get endTime => _endTime;

  Object get recurringPolicy => _recurringPolicy;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;
}

// TODO implement
class CompletedTaskInfo {}
