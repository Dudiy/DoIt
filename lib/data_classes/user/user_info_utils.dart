import 'package:do_it/data_classes/user/user_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';

class UserUtils {
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
    if (userInfoObject == null) {
      throw Exception('UserInfoUtils: cannot create shortUserInfo from null');
    }
    return (userInfoObject.runtimeType == ShortUserInfo)
        ? userInfoObject
        : new ShortUserInfo(
            userID: userInfoObject['userID'],
            displayName: userInfoObject['displayName'],
            photoUrl: userInfoObject['photoUrl'],
          );
  }

  static UserInfo generateFullUserInfoFromObject(userInfoObject) {
    if (userInfoObject == null) {
      throw Exception('UserInfoUtils: cannot create userInfo from null');
    }
    return (userInfoObject.runtimeType == UserInfo)
        ? userInfoObject
        : new UserInfo(
            userID: userInfoObject['userID'],
            displayName: userInfoObject['displayName'],
            email: userInfoObject['email'],
            fcmToken: userInfoObject['fcmToken'],
            photoUrl: userInfoObject['photoUrl'],
            bgImage: userInfoObject['bgImage'],
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
      'fcmToken': userInfo.fcmToken,
      'bgImage': userInfo.bgImage,
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
