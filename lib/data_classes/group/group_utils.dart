import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
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
