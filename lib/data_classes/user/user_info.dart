import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:meta/meta.dart';

class UserInfo {
  String _userID;
  String _displayName;
  String _photoURL;
  String _email;
  String _fcmToken;
  Map<String, ShortGroupInfo> _groups = new Map();
  Map<String, ShortTaskInfo> _tasks = new Map();

  UserInfo({
    @required String userID,
    @required String displayName,
    @required String fcmToken,
    @required String email,
    photoUrl,
  }) {
    assert(userID != null && userID.isNotEmpty);
    assert(displayName != null && displayName.isNotEmpty);
    assert(fcmToken != null && fcmToken.isNotEmpty);
    assert(email != null && email.isNotEmpty);
    this._userID = userID;
    this._displayName = displayName;
    this._photoURL = photoUrl;
    this._fcmToken = fcmToken;
    this._email = email;
  }

  addTask(String taskID, ShortTaskInfo shortTaskInfo) {
    _tasks.putIfAbsent(taskID, () => shortTaskInfo);
  }

  ShortUserInfo getShortUserInfo() {
    return new ShortUserInfo(
      userID: _userID,
      displayName: _displayName,
      photoUrl: _photoURL,
      fcmToken: _fcmToken,
    );
  }

//  Map<String, Object> _messages = new Map(); //Map<messageID, MessageInfo>

//  Map<String, Object> get messages => _messages;

  Map<String, ShortTaskInfo> get tasks => _tasks;

  Map<String, ShortGroupInfo> get groups => _groups;

  String get fcmToken => _fcmToken;

  String get email => _email;

  String get photoURL => _photoURL;

  String get displayName => _displayName;

  String get userID => _userID;
}
