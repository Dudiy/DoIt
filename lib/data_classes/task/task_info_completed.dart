import 'package:do_it/data_classes/task/task_interface.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class CompletedTaskInfo implements Task {
  String _taskID;
  String _title;
  String _description;
  int _value;
  String _parentGroupID;
  String _parentGroupManagerID;
  DateTime _completedTime;
  ShortUserInfo _userWhoCompleted;

  CompletedTaskInfo({
    @required taskID,
    @required title,
    @required description,
    @required value,
    @required parentGroupID,
    @required parentGroupManagerID,
    @required completedTime,
    @required userWhoCompleted,
  }) {
    this._taskID = taskID;
    this._title = title;
    this._description = description;
    this._value = value;
    this._parentGroupID = parentGroupID;
    this._parentGroupManagerID = parentGroupManagerID;
    this._completedTime = completedTime;
    this._userWhoCompleted = (userWhoCompleted.runtimeType == ShortUserInfo)
        ? userWhoCompleted
        : UserUtils.generateShortUserInfoFromObject(userWhoCompleted);
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

  DateTime get completedTime => _completedTime;

  ShortUserInfo get userWhoCompleted => _userWhoCompleted;
}
