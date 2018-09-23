import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';

class GroupUtils {
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
          );
  }

  static ShortGroupInfo generateShortGroupInfoFromObject(object) {
    return (object.runtimeType == ShortGroupInfo)
        ? object
        : new ShortGroupInfo(
            groupID: object['groupID'],
            title: object['title'],
            managerID: object['managerID'],
            photoUrl: object['photoUrl'],
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
      'photoUrl': shortGroupInfo.photoUrl,
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
    };
  }

  ///
  /// get groupsQuerySnapshot from db and return only user's groups
  ///
  static List<ShortGroupInfo> conventDBGroupsToGroupInfoList(String userId, QuerySnapshot groupsQuerySnapshot) {
    List<ShortGroupInfo> myGroups = groupsQuerySnapshot.documents.where((doc) {
      return userId != null && GroupUtils.generateShortGroupInfoFromObject(doc.data).members.containsKey(userId);
    }).map((docSnap) {
      return GroupUtils.generateShortGroupInfoFromObject(docSnap.data);
    }).toList();
    return myGroups;
  }

  static List<String> conventDBGroupsToGroupIdList(String userId, QuerySnapshot groupsQuerySnapshot) {
    List<String> myGroups = new List();
    groupsQuerySnapshot.documents.where((doc) {
      return userId != null && GroupUtils.generateShortGroupInfoFromObject(doc.data).members.containsKey(userId);
    }).forEach((docSnap) {
      myGroups.add(docSnap.data['groupID']);
    });
    return myGroups;
  }

  ///
  /// get tasksQuerySnapshot from db and return only group's tasks
  ///
  static List<ShortTaskInfo> conventDBGroupTaskToObjectList(DocumentSnapshot documentSnapshotTasks) {
    return TaskUtils.generateTasksMapFromObject(documentSnapshotTasks.data['tasks']).values.toList();
  }
}
