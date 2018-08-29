import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/constants/should_be_sync.dart';
import 'package:do_it/data_classes/group/group_info.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/task/task_info_utils.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:meta/meta.dart';

class TasksManager {
  App app = App.instance;
  Firestore _firestore;

  TasksManager(this._firestore);

  Future addTask({
    @required String title,
    @required String description,
    @required int value,
    @required String parentGroupID,
    @required String parentGroupManagerID,
    DateTime startTime,
    DateTime endTime,
    eRecurringPolicy recurringPolicy,
    Map<String, ShortUserInfo> assignedUsers,
    bool allowNonManagerAdd = false,
  }) async {
    ShortUserInfo loggedInUser = app.getLoggedInUser();
    if (loggedInUser == null) throw Exception('TaskManager: Cannot add a task when a user is not logged in');
    if (!allowNonManagerAdd && parentGroupManagerID != loggedInUser.userID)
      throw Exception('only group manager can add tasks to group');

    String _taskID = App.instance.generateRandomID();
    TaskInfo taskInfo = new TaskInfo(
      taskID: _taskID,
      title: title,
      description: description,
      value: value,
      parentGroupID: parentGroupID,
      parentGroupManagerID: parentGroupManagerID,
      startTime: startTime ?? DateTime.now(),
      endTime: endTime,
      recurringPolicy: recurringPolicy ?? eRecurringPolicy.none,
      assignedUsers: assignedUsers ?? new Map<String, String>(),
    );
    ShortTaskInfo shortTaskInfo = taskInfo.getShortTaskInfo();
    await _firestore
        .document('$TASKS/$_taskID')
        .setData(TaskUtils.generateObjectFromTaskInfo(taskInfo))
        .whenComplete(() {
      app.groupsManager
          .addTaskToGroup(
            groupID: parentGroupID,
            shortTaskInfo: shortTaskInfo,
            allowNonManagerAdd: allowNonManagerAdd,
          )
          .then((val) => print('TaskManager: Task \"$title\" was added succesfully to group'));
    }).catchError((e) {
      print('TasksManager: error while trying to add task');
      throw new Exception('TasksManager: error while trying to add task. \ninner:${e.message}');
    });
  }

  Future<TaskInfo> updateTask(
      {@required String taskIdToChange,
      String title,
      String description,
      int value,
      DateTime startTime,
      DateTime endTime,
      eRecurringPolicy recurringPolicy,
      Map<String, ShortUserInfo> assignedUsers,
      bool allowNonManagerUpdate = false}) async {
    /* validation */
    ShortUserInfo loggedInUser = app.loggedInUser;
    String errorMessagePrefix = 'TasksManager: cannot update task.';
    if (loggedInUser == null) throw Exception('$errorMessagePrefix User is not logged in');
    TaskInfo taskInfo = await getTaskById(taskIdToChange);
    if (taskInfo == null) throw Exception('$errorMessagePrefix TaskID was not found in the DB');
    if (!allowNonManagerUpdate && taskInfo.parentGroupManagerID != loggedInUser.userID)
      throw Exception('$errorMessagePrefix Only group managers can update tasks');

    /* build the new task */
    if (title != null) taskInfo.title = title;
    if (description != null) taskInfo.description = description;
    if (value != null) taskInfo.value = value;
    if (startTime != null) taskInfo.startTime = startTime;
    if (endTime != null) taskInfo.endTime = endTime;
    if (recurringPolicy != null) taskInfo.recurringPolicy = recurringPolicy;
    if (assignedUsers != null) taskInfo.assignedUsers = assignedUsers;

    /* update */
    await _updateTaskInDB(taskInfo);

    return taskInfo;
  }

  Future<void> _updateTaskInDB(TaskInfo taskInfo) async {
    await _firestore.document('$TASKS/${taskInfo.taskID}').updateData(TaskUtils.generateObjectFromTaskInfo(taskInfo));
    GroupInfo groupInfo = await app.groupsManager.getGroupInfoByID(taskInfo.parentGroupID);
    groupInfo.tasks[taskInfo.taskID] = taskInfo.getShortTaskInfo();
    await _firestore
        .document('$GROUPS/${taskInfo.parentGroupID}')
        .updateData({"tasks": TaskUtils.generateObjectFromTasksMap(groupInfo.tasks)});
    print('TasksManager: task ${taskInfo.title} was updated succesfully');
  }

  Future<void> completeTask({@required String taskID, @required String userWhoCompletedID}) async {
    // validations and error checking
    ShortUserInfo loggedInUser = app.loggedInUser;
    String errorMessagePrefix = 'TasksManager: cannot complete task.';
    if (loggedInUser == null) throw Exception('$errorMessagePrefix User is not logged in');
    ShortUserInfo userWhoCompleted = await app.usersManager.getShortUserInfo(userWhoCompletedID);
    if (loggedInUser == null) throw Exception('$errorMessagePrefix User who completed was not found in the DB');
    TaskInfo taskInfo = await getTaskById(taskID);
    if (taskInfo == null) throw Exception('$errorMessagePrefix TaskID was not found in the DB');
    GroupInfo parentGroupInfo = await app.groupsManager.getGroupInfoByID(taskInfo.parentGroupID);
    if (parentGroupInfo == null || !parentGroupInfo.members.containsKey(userWhoCompletedID))
      throw Exception('$errorMessagePrefix The given user is not a member of the task\'s parent group \n'
          'or parent group was not found in the DB');
    if (taskInfo.assignedUsers.length > 0 && !taskInfo.assignedUsers.containsKey(userWhoCompletedID))
      throw Exception('$errorMessagePrefix The given user was not assigned to this task');

    // complete the task (add completedTaskInfo to the groups sub-collection -> delete the original task)
    CompletedTaskInfo completedTaskInfo = taskInfo.generateCompletedTaskInfo(userWhoCompleted: userWhoCompleted);
    if (taskInfo.recurringPolicy == eRecurringPolicy.none) {
      await deleteTask(taskID);
    } else {
      DateTime newStartTime = _getStartTimeFromRecurringPolicy(taskInfo.startTime, taskInfo.recurringPolicy);
      DateTime newEndTime = _getStartTimeFromRecurringPolicy(taskInfo.endTime, taskInfo.recurringPolicy);
      updateTask(taskIdToChange: taskInfo.taskID, startTime: newStartTime, endTime: newEndTime);
    }
    await app.groupsManager.addCompletedTaskToGroup(
      groupID: parentGroupInfo.groupID,
      completedTaskInfo: completedTaskInfo,
    );
    print('TaskManager: taskID: $taskID has been completed');
  }

  Future<void> unCompleteTask({@required String parentGroupID, @required String taskID}) async {
    CompletedTaskInfo completedTask = await getCompletedTask(parentGroupID, taskID);
    addTask(
      title: completedTask.title,
      description: completedTask.description,
      value: completedTask.value,
      parentGroupID: completedTask.parentGroupID,
      parentGroupManagerID: completedTask.parentGroupManagerID,
      allowNonManagerAdd: true,
    );
    await _firestore.document('$GROUPS/$parentGroupID/$COMPLETED_TASKS/$taskID').delete();
  }

  Future<CompletedTaskInfo> getCompletedTask(String parentGroupID, String taskID) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.document('$GROUPS/$parentGroupID/$COMPLETED_TASKS/$taskID').get();
    if (documentSnapshot == null)
      throw Exception('Completed task, was not found in \"$GROUPS/$parentGroupID/$COMPLETED_TASKS/$taskID\"');
    return TaskUtils.generateCompletedTaskInfoFromObject(documentSnapshot.data);
  }

  Future<void> assignTaskToUser({String userID, String taskID}) async {
    ShortUserInfo shortUserInfo = await app.usersManager.getShortUserInfo(userID);
    TaskInfo taskInfo = await getTaskById(taskID);
    String errorMessagePrefix = 'TasksManager: cannot update task.';
    if (shortUserInfo == null) throw Exception('$errorMessagePrefix user was not found in the DB');
    if (taskInfo == null) throw Exception('$errorMessagePrefix the task was not found in the DB');
//    if (taskInfo.parentGroupManagerID != app.loggedInUser.userID)
//      throw Exception('$errorMessagePrefix only the parentGroup manager can assign usrs to tasks');
    //add user to "tasks" collection
    taskInfo.assignedUsers.putIfAbsent(userID, () => shortUserInfo);
    await updateTask(
      taskIdToChange: taskID,
      assignedUsers: taskInfo.assignedUsers,
      allowNonManagerUpdate: true,
    ).whenComplete(() => print('TasksManager: Task ${taskInfo.title} assigned to ${shortUserInfo.displayName}'));
  }

  // deleteFromGroup parameter is for when deleting an entire group - set to false fo efficiency
  @ShouldBeSync()
  Future<void> deleteTask(String taskID, [bool deleteFromGroup = true]) async {
    TaskInfo taskInfo = await getTaskById(taskID);
    if (deleteFromGroup) {
      await app.groupsManager.removeTaskFromGroup(taskInfo.parentGroupID, taskInfo.taskID);
    }
    await _firestore.document('$TASKS/$taskID').delete();
  }

  Future<TaskInfo> getTaskById(String taskID) async {
    DocumentSnapshot taskRef = await _firestore.document('$TASKS/$taskID').get();
    return TaskUtils.generateTaskInfoFromObject(taskRef.data);
  }

  /// in default returns all tasks assigned to me that their start date is before now from all groups
  /// we can filter by groupId
  Future<List<ShortTaskInfo>> getMyTasks([String groupId]) async {
    String loggedInUserID = app.getLoggedInUserID();
    List<String> myGroupsIDs;
    if (groupId != null) {
      myGroupsIDs = new List<String>();
      myGroupsIDs.add(groupId);
    } else {
      myGroupsIDs = await app.groupsManager.getMyGroupsIDsFromDB();
    }
    QuerySnapshot snapshot = await _firestore.collection('$TASKS').getDocuments();
    List<ShortTaskInfo> myTasks = snapshot.documents.where((doc) {
      ShortTaskInfo shortTaskInfo = TaskUtils.generateShortTaskInfoFromObject(doc.data);
      Map<String, ShortUserInfo> assignedUsers = shortTaskInfo.assignedUsers;
      if (shortTaskInfo.startTime.isAfter(DateTime.now())) return false;
      if (assignedUsers.length == null || assignedUsers.length == 0) {
        return myGroupsIDs.contains(shortTaskInfo.parentGroupID);
      } else {
        return assignedUsers.containsKey(loggedInUserID);
      }
    }).map((docSnap) {
      return TaskUtils.generateShortTaskInfoFromObject(docSnap.data);
    }).toList();
    return myTasks;
  }

  // if the removed user is the only one that the task is assigned to the task will become assigned to all group members
  Future<void> removeUserFromAllAssignedTasks(String userID) async {
    QuerySnapshot snapshot = await _firestore.collection('$TASKS').getDocuments();
    snapshot.documents.forEach((taskDoc) {
      ShortTaskInfo shortTaskInfo = TaskUtils.generateShortTaskInfoFromObject(taskDoc.data);
      if (shortTaskInfo.assignedUsers.containsKey(userID)) {
        shortTaskInfo.assignedUsers.remove(userID);
        updateTask(
          taskIdToChange: shortTaskInfo.taskID,
          assignedUsers: shortTaskInfo.assignedUsers,
          allowNonManagerUpdate: true,
        );
      }
    });
  }

  Future<void> removeUserFromAssignedTask({String userID, String taskID}) async {
    getTaskById(taskID).then((taskInfo) async {
      if (taskInfo.assignedUsers.containsKey(userID)) {
        taskInfo.assignedUsers.remove(userID);
        await updateTask(
          taskIdToChange: taskInfo.taskID,
          assignedUsers: taskInfo.assignedUsers,
          allowNonManagerUpdate: true,
        ).whenComplete(() => print('TasksManager: Task ${taskInfo.title} no longer assigned to $userID'));
      }
//      print('TasksManager: Task ${taskInfo.title} no longer assigned to $userID');
    });
  }

  DateTime _getStartTimeFromRecurringPolicy(DateTime time, eRecurringPolicy policy) {
    if (time == null) return null;

    DateTime newStartTime = DateTime.parse(time.toString());
    switch (policy) {
      case eRecurringPolicy.daily:
        newStartTime = newStartTime.add(Duration(days: 1));
        break;
      case eRecurringPolicy.weekly:
        newStartTime = newStartTime.add(Duration(days: 7));
        break;
      case eRecurringPolicy.monthly:
        newStartTime = DateTime(
          time.month < 12 ? newStartTime.year : newStartTime.year + 1,
          (newStartTime.month + 1) % 12,
          newStartTime.day,
          newStartTime.hour,
          newStartTime.minute,
        );
        break;
      case eRecurringPolicy.yearly:
        newStartTime = DateTime(
          newStartTime.year + 1,
          newStartTime.month,
          newStartTime.day,
          newStartTime.hour,
          newStartTime.minute,
        );
        break;
      default:
        break;
    }
    return newStartTime;
  }
}
