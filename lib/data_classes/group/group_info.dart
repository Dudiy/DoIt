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
  String _photoUrl;
  Map<String, ShortUserInfo> _members; // Map<userID, UserInfo>
  Map<String, ShortTaskInfo> _tasks; // Map<taskID, TaskInfo>
  Map<String, Object> _taskCompletionHistory;

  GroupInfo({
    @required groupID,
    @required managerID,
    @required title,
    description,
    photoUrl,
    members,
    tasks,
    taskCompletionHistory,
  }) {
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
      photoUrl: photoUrl,
      members: members,
      tasks: tasks,
    );
  }

  // ===========================================================
  // ========================= Getters =========================
  // ===========================================================
  String get groupID => _groupID;

  String get managerID => _managerID;

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  String get description => _description;

  // ignore: unnecessary_getters_setters
  String get photoUrl => _photoUrl;

  Map<String, ShortUserInfo> get members => _members;

  Map<String, ShortTaskInfo> get tasks => _tasks;

  Map<String, Object> get taskCompletionHistory => _taskCompletionHistory;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================
  // ignore: unnecessary_getters_setters
  set title(String value) => _title = value;

  // ignore: unnecessary_getters_setters
  set photoUrl(String value) => _photoUrl = value;

  // ignore: unnecessary_getters_setters
  set description(String value) => _description = value;
}
