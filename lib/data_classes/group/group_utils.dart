import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';

class GroupUtils {
/*  static Map<String, ShortUserInfo> generateMembersMap(membersObject) {
    Map<String, ShortUserInfo> members = new Map();
    (membersObject as Map<dynamic, dynamic>).values.forEach((userInfo) {
      // if we get a map that the values are already valid ShortUser info we add the "as is"
      if (userInfo.runtimeType == ShortUserInfo) {
        ShortUserInfo asShortUserInfo = userInfo as ShortUserInfo;
        members.putIfAbsent(asShortUserInfo.uid, () => asShortUserInfo);
      } else {
        // if we get a dynamic map we convert to ShortUserInfo
        members.putIfAbsent(userInfo['userID'], () {
          return new ShortUserInfo(
            userID: userInfo['userID'],
            displayName: userInfo['displayName'],
            photoUrl: userInfo['photoUrl'] ?? "",
          );
        });
      }
    });
    return members;
  }*/

  static GroupInfo generateGroupInfoFromObject(object) {
    return (object.runtimeType == GroupInfo)
        ? object
        : new GroupInfo(
            groupID: object['groupID'],
            title: object['title'],
            description: object['description'],
            managerID: object['managerID'],
            photoUrl: object['photoUrl'],
            tasks: TaskUtils.generateTasksMapFromObject(object['tasks']),
            members: UserUtils.generateUsersMapFromObject(object['members']),
//      taskCompletionHistory: object[''],   //TODO add implementation
          );
  }

  static ShortGroupInfo generateShortGroupInfoFromObject(object) {
    return (object.runtimeType == ShortGroupInfo)
        ? object
        : new ShortGroupInfo(
            groupID: object['groupID'],
            title: object['title'],
            managerID: object['managerID'],
            members: UserUtils.generateUsersMapFromObject(object['members']),
            tasks: TaskUtils.generateTasksMapFromObject(object['tasks']),
          );
  }

  static Map<String, dynamic> generateObjectFromGroupsMap(Map<String, ShortGroupInfo> groups) {
    Map<String, dynamic> groupsMap = new Map();
    groups.map((groupID, shortGroupInfo) {
      groupsMap.putIfAbsent(groupID, () {
        return generateObjectFromShortGroupInfo(shortGroupInfo);
      });
    });
    return groupsMap;
  }

  static Map<String, dynamic> generateObjectFromShortGroupInfo(ShortGroupInfo shortGroupInfo) {
    return {
      'groupID': shortGroupInfo.groupID,
      'title': shortGroupInfo.title,
      'managerID': shortGroupInfo.managerID,
      'members': UserUtils.generateObjectFromUsersMap(shortGroupInfo.members),
    };
  }

  static Map<String, dynamic> generateObjectFromGroupInfo(GroupInfo groupInfo) {
    return {
      'groupID': groupInfo.groupID,
      'title': groupInfo.title,
      'description': groupInfo.description,
      'managerID': groupInfo.managerID,
      'photoUrl': groupInfo.photoUrl,
      'members': UserUtils.generateObjectFromUsersMap(groupInfo.members),
      'tasks': TaskUtils.generateObjectFromTasksMap(groupInfo.tasks),
//    groupInfo.taskCompletionHistory  //TODO implement
    };
  }
}
