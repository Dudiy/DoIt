import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:meta/meta.dart';

class TasksManager {
  App app = App.instance;
  Firestore _firestore;

  TasksManager(this._firestore);

  Future addTask({
    @required String title,
    @required String description,
    @required int value,
    @required ShortGroupInfo parentGroup,
    DateTime startTime,
    DateTime endTime,
    Object recurringPolicy,
    Map<String, ShortUserInfo> assignedUsers,
  }) async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) throw Exception('TaskManager: Cannot add a task when a user is not logged in');
    if (parentGroup.managerID != loggedInUser.userID) throw Exception('only group manager can add tasks to group');

    String _taskID = App.instance.generateRandomID();
    TaskInfo taskInfo = new TaskInfo(
      taskID: _taskID,
      title: title,
      description: description,
      value: value,
      parentGroup: parentGroup,
      isCompleted: false,
      startTime: startTime ?? DateTime.now().toString(),
      endTime: endTime?.toString(),
      recurringPolicy: recurringPolicy ??
          {
            'weekly': false,
            'daily': false,
            'monthly': false,
            'yearly': false,
          },
      assignedUsers: assignedUsers ?? new Map<String, ShortUserInfo>(), //TODO does this work?
    );
    ShortTaskInfo shortTaskInfo = taskInfo.getShortTaskInfo();
    await _firestore
        .document('$TASKS/$_taskID')
        .setData(TaskUtils.generateObjectFromTaskInfo(taskInfo))
        .whenComplete(() {
      app.groupsManager
          .addTaskToGroup(
            groupID: parentGroup.groupID,
            shortTaskInfo: shortTaskInfo,
          )
          .then((val) => print('TaskManager: Task \"$title\" was added succesfully to group'));
    }).catchError((e) {
      print('TasksManager: error while trying to add task');
      throw new Exception('TasksManager: error while trying to add task. \ninner:${e.message}');
    });
  }

  // delete from group parameter is for when deleting an entire group - set to false fo efficiency
  deleteTask(String taskID, [bool deleteFromGroup = true]) async {
    TaskInfo taskInfo = await getTaskById(taskID);
    if (deleteFromGroup) app.groupsManager.removeTaskFromGroup(taskInfo.parentGroup.groupID, taskInfo.taskID);
    _firestore.document('$TASKS/$taskID').delete();
  }

  Future<TaskInfo> getTaskById(String taskID) async {
    DocumentSnapshot taskRef = await _firestore.document('$TASKS/$taskID').get();
    return TaskUtils.generateTaskInfoFromObject(taskRef.data);
  }

  Future<List<ShortTaskInfo>> getAllMyTasks() async {
    String loggedInUserID = app.getLoggedInUserID();
    QuerySnapshot snapshot = await _firestore.collection('$TASKS').getDocuments();
    List<ShortTaskInfo> myGroups = snapshot.documents.where((doc) {
      Map<String, ShortUserInfo> assignedUsers = TaskUtils.generateShortTaskInfoFromObject(doc.data).assignedUsers;
      return assignedUsers.length == null || assignedUsers.length == 0 || assignedUsers.containsKey(loggedInUserID);
    }).map((docSnap) {
      return TaskUtils.generateShortTaskInfoFromObject(docSnap.data);
    }).toList();
    return myGroups;
  }

  // if the removed user is the only one that the task is assigned to the task will become assigned to all group members
  Future<void> removeUserFromAssignedTasks(String userID) async {
    QuerySnapshot snapshot = await _firestore.collection('$TASKS').getDocuments();
    snapshot.documents.forEach((taskDoc) {
      ShortTaskInfo shortTaskInfo = TaskUtils.generateShortTaskInfoFromObject(taskDoc.data);
      if (shortTaskInfo.assignedUsers.containsKey(userID)) {
        shortTaskInfo.assignedUsers.remove(userID);
        _firestore
            .document('$TASKS/${shortTaskInfo.taskID}')
            .updateData({'assignedUsers': UserUtils.generateObjectFromUsersMap(shortTaskInfo.assignedUsers)});
      }
    });
  }
}
