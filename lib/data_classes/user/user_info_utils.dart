import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';

class UserUtils {
/*  static Map<String, ShortUserInfo> generateAssignedUsersMapFromObject(assignedUsersObject) {
    Map<String, ShortUserInfo> assignedUsers = new Map();
    if (assignedUsersObject != null) {
      (assignedUsersObject as Map<dynamic, dynamic>).values.forEach((userInfo) {
        if (userInfo.runtimeType == ShortUserInfo) {
          ShortUserInfo shortUserInfo = userInfo as ShortUserInfo;
          assignedUsers.putIfAbsent(shortUserInfo.uid, () => shortUserInfo);
        } else {
          assignedUsers.putIfAbsent(userInfo['userID'], () {
            return new ShortUserInfo(
              uid: userInfo['userID'],
              displayName: userInfo['displayName'],
              photoUrl: userInfo['photoUrl'],
            );
          });
        }
      });
    }
    return assignedUsers;
  }
  */
  static Map<String, ShortUserInfo> generateUsersMapFromObject(usersMapObject) {
    Map<String, ShortUserInfo> usersMap = new Map();
    if (usersMapObject != null) {
      (usersMapObject as Map<dynamic, dynamic>).values.forEach((userInfo) {
        ShortUserInfo shortUserInfo = generateShortUserInfoFromObject(userInfo);
        usersMap.putIfAbsent(shortUserInfo.userID, () => shortUserInfo);
      });
    }
    return usersMap;
  }

  static ShortUserInfo generateShortUserInfoFromObject(userInfoObject) {
    return (userInfoObject.runtimeType == ShortUserInfo)
        ? userInfoObject
        : new ShortUserInfo(
            userID: userInfoObject['userID'],
            displayName: userInfoObject['displayName'],
            photoUrl: userInfoObject['photoUrl'],
          );
  }

  static Map<String, dynamic> generateObjectFromUsersMap(Map<String, ShortUserInfo> members) {
    Map<String, dynamic> usersMap = new Map();
    members.forEach((userID, shortUserInfo) {
      usersMap.putIfAbsent(userID, () {
        return generateObjectFromShortUserInfo(shortUserInfo);
      });
    });
    return usersMap;
  }

  static Map<String, dynamic> generateObjectFromUserInfo(UserInfo userInfo) {
    return {
      'userID': userInfo.userID,
      'displayName': userInfo.displayName,
      'photoUrl': userInfo.photoURL,
      'email': userInfo.email,
      'groups': GroupUtils.generateObjectFromGroupsMap(userInfo.groups),
      'tasks': TaskUtils.generateObjectFromTasksMap(userInfo.tasks),
//      'messages': userInfo._messages,
    };
  }

  static Map<String, dynamic> generateObjectFromShortUserInfo(ShortUserInfo shortUserInfo) {
    return {
      'userID': shortUserInfo.userID,
      'displayName': shortUserInfo.displayName,
      'photoUrl': shortUserInfo.photoUrl,
    };
  }
}
