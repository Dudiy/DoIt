import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';

class UserInfo {
  String _userID;
  String _displayName;
  String _photoURL;
  String _email;
  Map<String, ShortGroupInfo> _groups = new Map();
  Map<String, ShortTaskInfo> _tasks = new Map();
  Map<String, Object> _messages = new Map(); //Map<messageID, MessageInfo>

  addTask(String taskID, ShortTaskInfo shortTaskInfo) {
    _tasks.putIfAbsent(taskID, () => shortTaskInfo);
  }

  ShortUserInfo getShortUserInfo() {
    return new ShortUserInfo(
      userID: _userID,
      displayName: _displayName,
      photoUrl: _photoURL,
    );
  }

  Map<String, Object> get messages => _messages;

  Map<String, ShortTaskInfo> get tasks => _tasks;

  Map<String, ShortGroupInfo> get groups => _groups;

  String get email => _email;

  String get photoURL => _photoURL;

  String get displayName => _displayName;

  String get userID => _userID;
}
