import 'dart:convert';

import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class ShortGroupInfo {
  String _groupID;
  String _managerID;
  String _title;
  Map<String, int> _tasksPerUser;
  Map<String, ShortUserInfo> _members = new Map();

  ShortGroupInfo({@required groupID, @required managerID, @required title, members, tasks}) {
    this._groupID = groupID;
    this._managerID = managerID;
    this._title = title;
    // TODO check if its possible to remove the not null verifier (checked inside "generateUsersMapFromObject")
    if (members != null) {
      this._members = UserUtils.generateUsersMapFromObject(members);
      // getTasksPerUser has to be after initializing members
      this._tasksPerUser = getTasksPerUser(tasks);
    }
  }

  String get groupID => _groupID;

  Map<String, int> getTasksPerUser(tasksObject) {
    Map<String, int> tasksPerUser = new Map();
    Map<String, ShortTaskInfo> tasks = new Map();
    (tasksObject as Map<dynamic, dynamic>).values.forEach((task) {
      if (task.runtimeType == ShortTaskInfo) {
        ShortTaskInfo asShortTaskInfo = task as ShortTaskInfo;
        tasks[asShortTaskInfo.taskID] = asShortTaskInfo;
      } else {
        ShortTaskInfo shortTaskInfo = TaskUtils.generateShortTaskInfoFromObject(task);
        tasks[shortTaskInfo.taskID] = shortTaskInfo;
      }
    });

    members.keys.forEach((userID) {
      tasksPerUser[userID] = 0;
    });
    tasks.values.forEach((task) {
      if (task.assignedUsers != null && task.assignedUsers.length == 0) {
        // if a tasks user list is empty, increment task counter for all group's users
        members.keys.forEach((userID) {
          (userID != null && tasksPerUser.containsKey(userID)) ? tasksPerUser[userID]++ : tasksPerUser[userID] = 0;
        });
      } else {
        // if a task has a users list, increment task counter only for the relevant users
        task.assignedUsers.keys.forEach((userID) {
          (userID != null && tasksPerUser.containsKey(userID)) ? tasksPerUser[userID]++ : tasksPerUser[userID] = 0;
        });
      }
    });
    return tasksPerUser;
  }

  String get managerID => _managerID;

  String get title => _title;

  Map<String, int> get tasksPerUser => _tasksPerUser;

  Map<String, ShortUserInfo> get members => _members;
}
