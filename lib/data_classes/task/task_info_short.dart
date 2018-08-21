import 'dart:convert';

import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class ShortTaskInfo {
  String _taskID;
  String _title;
  int _value;
  ShortGroupInfo _parentGroup;
  bool _isCompleted = false;
  String _startTime;
  String _endTime;
  Map<String, ShortUserInfo> _assignedUsers;

  ShortTaskInfo(
      {@required taskID,
      @required title,
      @required value,
      @required parentGroup,
      @required isCompleted,
      @required startTime,
      @required endTime,
      @required assignedUsers}) {
    this._taskID = taskID;
    this._title = title;
    this._value = value;
    this._parentGroup = parentGroup;
    this._isCompleted = isCompleted;
    this._startTime = startTime;
    this._endTime = endTime;
    this._assignedUsers = UserUtils.generateUsersMapFromObject(assignedUsers);
  }

  String get taskID => _taskID;

  String get title => _title;

  int get value => _value;

  ShortGroupInfo get parentGroup => _parentGroup;

  bool get isCompleted => _isCompleted;

  String get startTime => _startTime;

  String get endTime => _endTime;

  Map<String, ShortUserInfo> get assignedUsers => _assignedUsers;

  //TODO delete if not used
//  static fromJson(String jsonString) {
//    var object = json.decode(jsonString);
//    var parentGroup = object['parentGroup'];
//    ShortTaskInfo shortTaskInfo = new ShortTaskInfo(
//      taskID: object['taskID'],
//      title: object['title'],
//      value: object['value'],
//      parentGroup: new ShortGroupInfo(
//        groupID: parentGroup['groupID'],
//        managerID: parentGroup['managerID'],
//        title: parentGroup['title'],
//      ),
//      isCompleted: object['isCompleted'],
//      startTime: object['startTime'],
//      endTime: object['endTime'],
//      assignedUsers: object['assignedUsers'],
//    );
//
//    return shortTaskInfo;
//  }

  //TODO delete if not used
//  toJson() {
//    return {
//      'taskID': taskID,
//      'title': title,
//      'value': value,
//      'parentGroup': json.encode(parentGroup),
//      'isCompleted': isCompleted,
//      'startTime': startTime.toString(),
//      'endTime': endTime.toString(),
//      'assignedUsers': json.encode(assignedUsers),
//    };
//  }
}
