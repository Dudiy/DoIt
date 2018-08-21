import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class GroupInfo {
  String _groupID;
  String _managerID;
  String _title;
  String _description;
  Object _photoUrl;
  Map<String, ShortUserInfo> _members; // Map<userID, UserInfo>
  Map<String, ShortTaskInfo> _tasks; // Map<taskID, TaskInfo>
  Map<String, Object> _taskCompletionHistory;

  GroupInfo(
      {@required groupID,
      @required managerID,
      @required title,
      description,
      photoUrl,
      members,
      tasks,
      taskCompletionHistory}) {
    this._groupID = groupID;
    this._managerID = managerID;
    this._title = title;
    this._description = description;
    this._photoUrl = photoUrl;
    this._members = UserUtils.generateUsersMapFromObject(members);
    this._tasks = TaskUtils.generateTasksMapFromObject(tasks);
    taskCompletionHistory = new Map(); // TODO implement map generation
//        Map.from(taskCompletionHistory); //Map<TaskID, CompletedTaskInfo>
  }

  ShortGroupInfo getShortGroupInfo() {
    return new ShortGroupInfo(
      title: title,
      managerID: managerID,
      groupID: groupID,
      members: members,
      tasks: tasks,
    );
  }

  String get groupID => _groupID;

  String get managerID => _managerID;

  String get title => _title;

  String get description => _description;

  Object get photoUrl => _photoUrl;

  Map<String, ShortUserInfo> get members => _members;

  Map<String, ShortTaskInfo> get tasks => _tasks;

  Map<String, Object> get taskCompletionHistory => _taskCompletionHistory;

  set title(String value) => _title = value;

  set photoUrl(Object value) => _photoUrl = value;

  set description(String value) => _description = value;
}
