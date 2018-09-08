import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/task/task_info_completed.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';

class TaskUtils {
  // returns both current and future tasks
  static Map<String, ShortTaskInfo> generateTasksMapFromObject(tasksObject) {
    Map<String, ShortTaskInfo> tasks = new Map();
    if (tasksObject != null) {
      (tasksObject as Map<dynamic, dynamic>).values.forEach((taskObject) {
        ShortTaskInfo shortTaskInfo =
            generateShortTaskInfoFromObject(taskObject);
//        if (shortTaskInfo.startTime.isBefore(DateTime.now())) {
        tasks.putIfAbsent(shortTaskInfo.taskID, () {
          return shortTaskInfo;
        });
//        }
      });
    }
    return tasks;
  }

  static TaskInfo generateTaskInfoFromObject(taskObject) {
    if (taskObject == null) return null;
    if (taskObject.runtimeType == TaskInfo) return taskObject;
    eRecurringPolicy recurringPolicy =
        RecurringPolicyUtils.parse(taskObject['recurringPolicy']) ??
            eRecurringPolicy.none;
    return new TaskInfo(
      taskID: taskObject['taskID'],
      title: taskObject['title'],
      description: taskObject['description'],
      value: taskObject['value'],
      startTime: taskObject['startTime'],
      endTime: taskObject['endTime'],
      parentGroupID: taskObject['parentGroupID'],
      parentGroupManagerID: taskObject['parentGroupManagerID'],
      assignedUsers:
          UserUtils.generateUsersMapFromObject(taskObject['assignedUsers']),
      recurringPolicy: recurringPolicy,
    );
  }

  static int compare(ShortTaskInfo task1, ShortTaskInfo task2){
    if (task1.endTime == null && task2.endTime == null) return 0;
    if (task1.endTime == null) return 1;
    if (task2.endTime == null) return -1;
    if (task1.endTime == task2.endTime) return 0;
    return task1.endTime.isAfter(task2.endTime) ? 1 : -1;

  }

  static ShortTaskInfo generateShortTaskInfoFromObject(object) {
    if (object.runtimeType == ShortTaskInfo) return object;
    eRecurringPolicy recurringPolicy =
        RecurringPolicyUtils.parse(object['recurringPolicy']) ??
            eRecurringPolicy.none;
    return new ShortTaskInfo(
      taskID: object['taskID'],
      title: object['title'],
      description: object['description'],
      value: object['value'],
      startTime: object['startTime'],
      endTime: object['endTime'],
      recurringPolicy: recurringPolicy,
      parentGroupID: object['parentGroupID'],
      parentGroupManagerID: object['parentGroupManagerID'],
      assignedUsers:
          UserUtils.generateUsersMapFromObject(object['assignedUsers']),
    );
  }

  static Map<String, dynamic> generateObjectFromTasksMap(
      Map<String, ShortTaskInfo> tasks) {
    Map<String, dynamic> tasksMapObject = new Map();
    tasks.forEach((taskID, shortTaskInfo) {
      tasksMapObject.putIfAbsent(taskID, () {
        return generateObjectFromShortTaskInfo(shortTaskInfo);
      });
    });
    return tasksMapObject;
  }

  static Map<String, dynamic> generateObjectFromShortTaskInfo(
      ShortTaskInfo shortTaskInfo) {
    return {
      'taskID': shortTaskInfo.taskID,
      'title': shortTaskInfo.title,
      'description': shortTaskInfo.description,
      'value': shortTaskInfo.value,
      'parentGroupID': shortTaskInfo.parentGroupID,
      'parentGroupManagerID': shortTaskInfo.parentGroupManagerID,
      'startTime': shortTaskInfo.startTime,
      'endTime': shortTaskInfo.endTime,
      'recurringPolicy': shortTaskInfo.recurringPolicy.toString(),
      'assignedUsers':
          UserUtils.generateObjectFromUsersMap(shortTaskInfo.assignedUsers),
    };
  }

  static Map<String, dynamic> generateObjectFromTaskInfo(TaskInfo taskInfo) {
    return {
      'taskID': taskInfo.taskID,
      'title': taskInfo.title,
      'description': taskInfo.description,
      'value': taskInfo.value,
      'parentGroupID': taskInfo.parentGroupID,
      'parentGroupManagerID': taskInfo.parentGroupManagerID,
      'startTime': taskInfo.startTime,
      'endTime': taskInfo.endTime,
      'assignedUsers':
          UserUtils.generateObjectFromUsersMap(taskInfo.assignedUsers),
      'recurringPolicy': taskInfo.recurringPolicy.toString(),
    };
  }

  static Map<String, dynamic> generateObjectFromCompletedTaskInfo(
      CompletedTaskInfo completedTaskInfo) {
    return {
      'taskID': completedTaskInfo.taskID,
      'title': completedTaskInfo.title,
      'description': completedTaskInfo.description,
      'value': completedTaskInfo.value,
      'parentGroupID': completedTaskInfo.parentGroupID,
      'parentGroupManagerID': completedTaskInfo.parentGroupManagerID,
      'completedTime': completedTaskInfo.completedTime,
      'userWhoCompleted': UserUtils
          .generateObjectFromShortUserInfo(completedTaskInfo.userWhoCompleted),
    };
  }

  static CompletedTaskInfo generateCompletedTaskInfoFromObject(object) {
    if (object.runtimeType == CompletedTaskInfo) return object;
    return new CompletedTaskInfo(
      taskID: object['taskID'],
      title: object['title'],
      description: object['description'],
      value: object['value'],
      parentGroupID: object['parentGroupID'],
      parentGroupManagerID: object['parentGroupManagerID'],
      completedTime: object['completedTime'],
      userWhoCompleted:
          UserUtils.generateShortUserInfoFromObject(object['userWhoCompleted']),
    );
  }
}
