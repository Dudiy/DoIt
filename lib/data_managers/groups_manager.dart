import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/constants/should_be_sync.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class GroupsManager {
  App app = App.instance;
  Firestore _firestore;

  GroupsManager(this._firestore);

  /* ############## GET FROM DB ############## */

  ///
  /// get all current user's groups from db
  ///
  Future<List<ShortGroupInfo>> getMyGroupsFromDB() async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    QuerySnapshot groupsQuerySnapshot = await _firestore.collection(GROUPS).getDocuments();
    return conventDBGroupsToGroupInfoList(loggedInUser.userID, groupsQuerySnapshot);
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

  Future<List<String>> getMyGroupsIDsFromDB() async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    QuerySnapshot groupsQuerySnapshot = await _firestore.collection(GROUPS).getDocuments();
    return conventDBGroupsToGroupIdList(loggedInUser.userID, groupsQuerySnapshot);
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

  @ShouldBeSync()
  Future<GroupInfo> getGroupInfoByID(String groupID) async {
    DocumentSnapshot groupRef = await _firestore.document('$GROUPS/$groupID').get();
    if (groupRef.data == null) throw ('GroupsManager: groupID \'$groupID\' was nof found in the DB');
    return GroupUtils.generateGroupInfoFromObject(groupRef.data);
  }

  ///
  /// get all group's tasks from db
  ///
  Future<List<ShortTaskInfo>> getMyGroupTasksFromDB(String groupID) async {
    DocumentSnapshot groupRef = await _firestore.document('$GROUPS/$groupID').get();
    return conventDBGroupTaskToObjectList(groupRef);
  }

  ///
  /// get tasksQuerySnapshot from db and return only group's tasks
  ///
  static List<ShortTaskInfo> conventDBGroupTaskToObjectList(DocumentSnapshot documentSnapshotTasks) {
    return TaskUtils.generateTasksMapFromObject(documentSnapshotTasks.data['tasks']).values.toList();
  }

  /* ############## INSERT TO DB ############## */
  Future addNewGroup({
    @required String title,
    @required String description,
    String photoURL,
  }) async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot add a new group when a user is not logged in');
    }
    String _groupID = App.instance.generateRandomID();
    GroupInfo groupInfo = new GroupInfo(
      groupID: _groupID,
      managerID: loggedInUser.userID,
      title: title,
      description: description,
      photoUrl: photoURL,
      members: {
        loggedInUser.userID: {
          'userID': loggedInUser.userID,
          'displayName': loggedInUser.displayName,
          'photoURL': loggedInUser.photoUrl,
        }
      },
    );
    await _firestore.document('$GROUPS/$_groupID').setData(GroupUtils.generateObjectFromGroupInfo(groupInfo));
    print('GroupManager: Group $title was added succesfully');
  }

  Future<GroupInfo> updateGroupInfo({
    @required String groupIdToChange,
    String title,
    String description,
    String photoUrl,
  }) async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) throw Exception('GroupManager: Cannot update group when a user is not logged in');
    GroupInfo groupInfo = await getGroupInfoByID(groupIdToChange);
    if (groupInfo == null) throw Exception('GroupManager: cannot update group, groupID was not found in the DB');
    if (groupInfo.managerID != loggedInUser.userID)
      throw Exception('GroupManager: only group managers can update the group info');

    if (title != null) groupInfo.title = title;
    if (description != null) groupInfo.description = description;
    if (photoUrl != null) groupInfo.photoUrl = photoUrl;
    await _firestore
        .document('$GROUPS/${groupInfo.groupID}')
        .updateData(GroupUtils.generateObjectFromGroupInfo(groupInfo));
    print('GroupManager: Group $title was updated succesfully');
    return groupInfo;
  }

  Future<void> deleteGroup({@required String groupID}) async {
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    String loggedInUserID = app.getLoggedInUserID();
    if (loggedInUserID == null) throw new Exception('GroupManager: User is not logged in, cannot delete group');
    if (groupInfo.managerID != loggedInUserID)
      throw new Exception('GroupManager: Only the group manager can delete a group');
    await Future.forEach(groupInfo.tasks.keys, (taskID) async {
      await app.tasksManager.deleteTask(taskID, false);
    });
    await _firestore.document('$GROUPS/$groupID').delete();
  }

  Future<void> deleteAllCompletedTasksFromGroup({@required groupID}) async {
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    String loggedInUserID = app.getLoggedInUserID();
    if (loggedInUserID == null)
      throw new Exception('GroupManager: User is not logged in, cannot delete completed tasks');
    if (groupInfo.managerID != loggedInUserID)
      throw new Exception('GroupManager: Only the group manager can delete completed tasks');
    QuerySnapshot querySnapshot = await _firestore.collection('$GROUPS/$groupID/$COMPLETED_TASKS').getDocuments();
    await Future.forEach(querySnapshot.documents, (completedTaskDoc) {
      _firestore.document('$GROUPS/$groupID/$COMPLETED_TASKS/${completedTaskDoc.documentID}').delete();
    });
  }

  void joinGroup(String groupID) async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) throw Exception('GroupManager: Cannot join a new group when a user is not logged in');
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    if (groupInfo == null)
      throw Exception('GroupManager: cannot join group, no group with ID $groupID was found in the DB');
    Map<String, ShortUserInfo> members = groupInfo.members;
    if (!(members.containsKey(loggedInUser.userID))) {
      members.putIfAbsent(loggedInUser.userID, () => loggedInUser);
      _firestore
          .document('$GROUPS/${groupInfo.groupID}')
          .updateData(<String, dynamic>{'members': UserUtils.generateObjectFromUsersMap(members)});
      print('GroupManager: ${loggedInUser.displayName} has joined the group: $groupID');
    }
  }

  @ShouldBeSync()
  Future<void> removeTaskFromGroup(String groupID, String taskID) async {
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    if (groupInfo.tasks.containsKey(taskID)) {
      groupInfo.tasks.remove(taskID);
      await _firestore
          .document('$GROUPS/$groupID')
          .updateData({'tasks': TaskUtils.generateObjectFromTasksMap(groupInfo.tasks)});
    }
  }

  Future<void> addTaskToGroup(
      {@required String groupID, @required ShortTaskInfo shortTaskInfo, bool allowNonManagerAdd = false}) async {
    DocumentSnapshot groupSnapshot = await _firestore.document('$GROUPS/$groupID').get();
    if (app.getLoggedInUser() == null) throw Exception('GroupsManager: cannot add task when user is not logged in');
    if (!allowNonManagerAdd && app.getLoggedInUser().userID != groupSnapshot.data['managerID']) {
      throw Exception('GroupsManager: only manager can add tasks to a group');
    }

    Map tasks = groupSnapshot.data['tasks'];
    tasks[shortTaskInfo.taskID] = TaskUtils.generateObjectFromShortTaskInfo(shortTaskInfo);
    _firestore.document('$GROUPS/$groupID').updateData({
      'tasks': tasks,
    });
  }

  Future<void> addCompletedTaskToGroup({
    @required String groupID,
    @required CompletedTaskInfo completedTaskInfo,
  }) async {
    if (app.getLoggedInUser() == null) throw Exception('GroupsManager: cannot add task when user is not logged in');
    await _firestore
        .document('$GROUPS/$groupID/$COMPLETED_TASKS/${completedTaskInfo.taskID}')
        .setData(TaskUtils.generateObjectFromCompletedTaskInfo(completedTaskInfo));
  }

  Future<void> deleteAllGroupsUserIsManagerOf(String userId) async {
    getAllGroupsFromDB().then((allGroups) {
      allGroups.forEach((group) {
        if (group.managerID == userId) deleteGroup(groupID: group.groupID);
      });
    });
  }

  Future<void> deleteUserFromAllGroups(String userID) async {
    getAllGroupsFromDB().then((allGroups) {
      allGroups.forEach((group) {
        if (group.members.containsKey(userID)) {
          deleteUserFromGroup(group.groupID, userID);
        }
      });
    });
  }

  void deleteUserFromGroup(String groupID, String userID) async {
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    // delete user from group
    groupInfo.members.remove(userID);
    _firestore
        .document('$GROUPS/$groupID')
        .updateData({'members': UserUtils.generateObjectFromUsersMap(groupInfo.members)});

    // unassigned all user tasks
    app.tasksManager.getAllMyTasks().then((allTask) {
      allTask.forEach((task) {
        app.tasksManager.unassignedTask(task.taskID);
      });
    });
  }

  Future<List<GroupInfo>> getAllGroupsFromDB() async {
    QuerySnapshot snapshot = await App.instance.firestore.collection('$GROUPS').getDocuments();
    return snapshot.documents.map((doc) {
      return GroupUtils.generateGroupInfoFromObject(doc.data);
    }).toList();
  }

  Future<Map<String, Map<String, dynamic>>> getGroupScoreboards(
      {@required String groupID, DateTime fromDate, DateTime toDate}) async {
    if (toDate == null) toDate = DateTime.now();
    Map<String, Map<String, dynamic>> scoreBoard = new Map();
    Map<String, ShortUserInfo> allGroupMembers = await getGroupInfoByID(groupID).then((groupInfo) {
      return groupInfo.members;
    });
    allGroupMembers.forEach((userID, userInfo) {
      scoreBoard[userID] = {
        'userInfo': userInfo,
        'score': 0,
      };
    });
    await getCompletedTasks(groupID: groupID, fromDate: fromDate, toDate: toDate).then((completedTasks) {
      completedTasks.forEach((completedTask) {
        scoreBoard[completedTask.userWhoCompleted.userID]['score'] += completedTask.value;
      });
    });
/*    QuerySnapshot snapshot = await _firestore.collection('$GROUPS/$groupID/$COMPLETED_TASKS').getDocuments();
    snapshot.documents.where((doc) {
      DateTime completedTime = doc.data['completedTime'];
      bool isAfterFromDate = fromDate == null ? true : completedTime.isAfter(fromDate);
      return isAfterFromDate && completedTime.isBefore(toDate);
    }).forEach((doc) {
      scoreBoard[doc.data['userWhoCompleted']['userID']]['score'] += doc.data['value'];
    });*/
    return scoreBoard;
  }

  Future<List<CompletedTaskInfo>> getCompletedTasks(
      {@required String groupID, DateTime fromDate, DateTime toDate}) async {
    if (toDate == null) toDate = DateTime.now();
    QuerySnapshot snapshot = await _firestore.collection('$GROUPS/$groupID/$COMPLETED_TASKS').getDocuments();
    return snapshot.documents.where((doc) {
      DateTime completedTime = doc.data['completedTime'];
      bool isAfterFromDate = fromDate == null ? true : completedTime.isAfter(fromDate);
      return isAfterFromDate && completedTime.isBefore(toDate);
    }).map((doc) {
      return TaskUtils.generateCompletedTaskInfoFromObject(doc.data);
    }).toList();
  }

  Future<ShortUserInfo> addMember({@required String groupID, @required String newMemberEmail}) async {
    ShortUserInfo newMemberInfo = await app.usersManager.getShortUserInfoByEmail(newMemberEmail);
    if (newMemberInfo == null) throw Exception('GroupsManager: No user found in the DB with the given email addres');
    getGroupInfoByID(groupID).then((groupInfo) {
      if (!groupInfo.members.containsKey(newMemberInfo.userID)) {
        groupInfo.members.putIfAbsent(newMemberInfo.userID, () => newMemberInfo);
        _firestore
            .document('$GROUPS/${groupInfo.groupID}')
            .updateData(<String, dynamic>{'members': UserUtils.generateObjectFromUsersMap(groupInfo.members)});
        print('GroupManager: ${newMemberInfo.displayName} was added to the group ${groupInfo.title}');
      }
    });
    return newMemberInfo;
  }
}
