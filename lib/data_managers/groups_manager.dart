import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
    ShortUserInfo loggedInUser = app.loggedInUser;
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all groups when a user is not logged in');
    }
    QuerySnapshot groupsQuerySnapshot = await _firestore.collection(GROUPS).getDocuments();
    return GroupUtils.conventDBGroupsToGroupInfoList(loggedInUser.userID, groupsQuerySnapshot);
  }

  Future<List<String>> getMyGroupsIDsFromDB() async {
    ShortUserInfo loggedInUser = app.loggedInUser;
    if (loggedInUser == null) {
      throw Exception('GroupManager: Cannot get all group IDs when a user is not logged in');
    }
    QuerySnapshot groupsQuerySnapshot = await _firestore.collection(GROUPS).getDocuments();
    return GroupUtils.conventDBGroupsToGroupIdList(loggedInUser.userID, groupsQuerySnapshot);
  }

  Future<GroupInfo> getGroupInfoByID(String groupID) async {
    // TODO delete
//    DocumentSnapshot groupRef = await _firestore.document('$GROUPS/1').get();
    // TODO uncomment
    DocumentSnapshot groupRef = await _firestore.document('$GROUPS/$groupID').get();
    if (groupRef.data == null) throw Exception('GroupsManager: groupID \'$groupID\' was not found in the DB');
    return GroupUtils.generateGroupInfoFromObject(groupRef.data);
  }

  ///
  /// get all group's tasks from db
  ///
  Future<List<ShortTaskInfo>> getGroupTasksFromDB(String groupID) async {
    DocumentSnapshot groupRef = await _firestore.document('$GROUPS/$groupID').get();
    return GroupUtils.conventDBGroupTaskToObjectList(groupRef);
  }

  /* ############## INSERT TO DB ############## */
  Future addNewGroup({
    @required String title,
    @required String description,
    String photoURL,
  }) async {
    ShortUserInfo loggedInUser = app.loggedInUser;
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
    ShortUserInfo loggedInUser = app.loggedInUser;
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
    /* delete from firebase db */
    print('groupID:$groupID - in deleteGroup'); //TODO delete
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    String loggedInUserID = app.getLoggedInUserID();
    if (loggedInUserID == null) throw new Exception('GroupManager: User is not logged in, cannot delete group');
    if (groupInfo.managerID != loggedInUserID)
      throw new Exception('GroupManager: Only the group manager can delete a group');
    await Future.forEach(groupInfo.tasks.keys, (taskID) async {
      await app.tasksManager.deleteTask(taskID, false);
    });
    await _firestore.collection('$GROUPS/$groupID/$COMPLETED_TASKS').getDocuments().then((docSnapshots) {
      docSnapshots.documents.forEach((doc) {
        _firestore.document('$GROUPS/$groupID/$COMPLETED_TASKS/${doc.data['taskID']}').delete();
      });
    });
    await _firestore.document('$GROUPS/$groupID').delete().whenComplete(() {
      print('GroupsManager: groupID:$groupID deleted');
    });
    print('groupID:$groupID - returning from deleteGroup'); //TODO delete

    /* delete from firebase storage */
    String pathToDelete = "$GROUPS/$groupID/profile.jpg";
    StorageReference storageRef = App.instance.firebaseStorage.ref().child(pathToDelete);
    try {
      await storageRef.delete();
      print("GroupManager: deleted group picture from firebase storage in path: " + pathToDelete);
    } catch (e) {
      print("GroupManager: failed to delete group picture from firebase storage in path: " + pathToDelete);
    }
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
    ShortUserInfo loggedInUser = app.loggedInUser;
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

  Future<void> removeTaskFromGroup(String groupID, String taskID) async {
    print('groupID: $groupID - taskID:$taskID: in removeTaskFromGroup'); //TODO delete
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    if (groupInfo.tasks.containsKey(taskID)) {
      groupInfo.tasks.remove(taskID);
      await _firestore
          .document('$GROUPS/$groupID')
          .updateData({'tasks': TaskUtils.generateObjectFromTasksMap(groupInfo.tasks)});
    }
    print('groupID: $groupID - taskID:$taskID: returning from removeTaskFromGroup'); //TODO delete
  }

  Future<void> addTaskToGroup(
      {@required String groupID, @required ShortTaskInfo shortTaskInfo, bool allowNonManagerAdd = false}) async {
    DocumentSnapshot groupSnapshot = await _firestore.document('$GROUPS/$groupID').get();
    if (app.loggedInUser == null) throw Exception('GroupsManager: cannot add task when user is not logged in');
    if (!allowNonManagerAdd && app.loggedInUser.userID != groupSnapshot.data['managerID']) {
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
    if (app.loggedInUser == null) throw Exception('GroupsManager: cannot add task when user is not logged in');
    await _firestore
        .document('$GROUPS/$groupID/$COMPLETED_TASKS/${completedTaskInfo.taskID}')
        .setData(TaskUtils.generateObjectFromCompletedTaskInfo(completedTaskInfo));
  }

  //deletes all group asynchronously but only returns after all groups are deleted
  Future<void> deleteAllGroupsUserIsManagerOf(String userID) async {
    print('userId: $userID - in deleteAllGroupsUserIsManagerOf'); //TODO delete
    List<GroupInfo> allGroupsFromDB = await getAllGroupsFromDB();
    List<Future> deleteGroupFunctions = new List();
    allGroupsFromDB.forEach((groupInfo) {
      if (groupInfo.managerID == userID) {
        deleteGroupFunctions.add(deleteGroup(groupID: groupInfo.groupID));
      }
    });
    await Future.wait(deleteGroupFunctions);
    print('userId: $userID - returning from deleteAllGroupsUserIsManagerOf'); //TODO delete
  }

  Future<void> deleteUserFromAllGroups(String userID) async {
    print('userId: $userID - in deleteUserFromAllGroups'); //TODO delete
    List<GroupInfo> allGroupsFromDB = await getAllGroupsFromDB();
    List<Future> deleteUserFromGroupFunctions = new List();
    allGroupsFromDB.forEach((group) {
      if (group.members.containsKey(userID)) {
        deleteUserFromGroupFunctions.add(deleteUserFromGroup(group.groupID, userID));
      }
    });
    await Future.wait(deleteUserFromGroupFunctions);
    print('userId: $userID - returning from deleteUserFromAllGroups'); //TODO delete
  }

  Future<void> deleteUserFromGroup(String groupID, String userID) async {
    print('userId: $userID, groupID: $groupID - in deleteUserFromGroup'); //TODO delete
    GroupInfo groupInfo = await getGroupInfoByID(groupID);
    // delete user from group
    groupInfo.members.remove(userID);
    Future<void> removeUserFromGroupMembersFuture = _firestore
        .document('$GROUPS/$groupID')
        .updateData({'members': UserUtils.generateObjectFromUsersMap(groupInfo.members)});

    // un-assign user from all tasks
    Iterable<ShortTaskInfo> tasksAssignedToUserInGroup =
        groupInfo.tasks.values.where((shortTaskInfo) => shortTaskInfo.assignedUsers.containsKey(userID));
    // used foreach and not wait => synchronous, because if done async, one thread can delete one task and
    // re-upload the list with another task that was just deleted by another thread
    await Future.forEach(tasksAssignedToUserInGroup, (task) async {
      await app.tasksManager.removeUserFromAssignedTask(userID: userID, taskID: task.taskID);
    });
    await Future.wait([removeUserFromGroupMembersFuture]);
    print('userId: $userID, groupID: $groupID  - returning from deleteUserFromGroup'); //TODO delete
  }

  Future<List<GroupInfo>> getAllGroupsFromDB() async {
    QuerySnapshot snapshot = await App.instance.firestore.collection('$GROUPS').getDocuments();
    return snapshot.documents.map((doc) {
      return GroupUtils.generateGroupInfoFromObject(doc.data);
    }).toList();
  }

  Future<Map<String, Map<String, dynamic>>> getGroupScoreboard(
      {@required String groupID, DateTime fromDate, DateTime toDate}) async {
    if (toDate == null) toDate = DateTime.now();
    Map<String, Map<String, dynamic>> scoreBoard = new Map(); // {userID, {userInfo, score}}
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
        // verify that the user who completed the task is still in the group
        if (scoreBoard.containsKey(completedTask.userWhoCompleted.userID)) {
          scoreBoard[completedTask.userWhoCompleted.userID]['score'] += completedTask.value;
        }
      });
    });
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
    if (newMemberInfo == null) throw Exception('GroupsManager: No user found in the DB with the given email address');
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

  Future<File> uploadGroupPic(GroupInfo groupInfo, Function showLoadingCallback) async {
    StorageReference storageRef = app.firebaseStorage.ref();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      showLoadingCallback();
      // TODO do we want to limit the file size?
      double fileSizeInMb = await file.length() / 1000000;
      if (fileSizeInMb > MAX_PIC_UPLOAD_SIZE_MB) throw Exception('Maximum file size is $MAX_PIC_UPLOAD_SIZE_MB Mb');
      StorageUploadTask uploadTask = storageRef.child("$GROUPS/${groupInfo.groupID}/profile.jpg").putFile(file);
      UploadTaskSnapshot uploadTaskSnapshot = await uploadTask.future;
      await updateGroup(groupInfo.groupID, uploadTaskSnapshot.downloadUrl.toString());
      groupInfo.photoUrl = uploadTaskSnapshot.downloadUrl.toString();
    }
    return file;
  }

  //we only want the user to be able to change his picture and not hes other data
  Future<void> updateGroup(String groupId, String photoUrl) async {
    await _firestore.document('$GROUPS/$groupId').updateData(<String, dynamic>{
      'photoUrl': photoUrl,
    });
  }
}
