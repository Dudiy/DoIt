import 'package:do_it/data_classes/group/group_utils.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_classes/task/task_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';

class TaskUtils {
  static Map<String, ShortTaskInfo> generateTasksMapFromObject(tasksObject) {
    Map<String, ShortTaskInfo> tasks = new Map();
    if (tasksObject != null) {
      (tasksObject as Map<dynamic, dynamic>).values.forEach((taskObject) {
        ShortTaskInfo shortTaskInfo = generateShortTaskInfoFromObject(taskObject);
        tasks.putIfAbsent(shortTaskInfo.taskID, () {
          return shortTaskInfo;
        });
      });
    }
    return tasks;
  }

  static TaskInfo generateTaskInfoFromObject(taskObject) {
    if (taskObject == null) return null;
    if (taskObject.runtimeType == TaskInfo) return taskObject;
    var recurringPolicy = taskObject['recurringPolicy'] ??
        {
          'weekly': false,
          'daily': false,
          'monthly': false,
          'yearly': false,
        };
    return new TaskInfo(
        taskID: taskObject['taskID'],
        title: taskObject['title'],
        description: taskObject['description'],
        value: taskObject['value'],
        isCompleted: taskObject['isCompleted'],
        startTime: taskObject['startTime'],
        endTime: taskObject['endTime'],
        parentGroupID: taskObject['parentGroupID'],
        parentGroupManagerID: taskObject['parentGroupManagerID'],
        assignedUsers: UserUtils.generateUsersMapFromObject(taskObject['assignedUsers']),
        recurringPolicy: {
          'weekly': recurringPolicy['weekly'],
          'daily': recurringPolicy['daily'],
          'monthly': recurringPolicy['monthly'],
          'yearly': recurringPolicy['yearly'],
        });
  }

  static ShortTaskInfo generateShortTaskInfoFromObject(object) {
    if (object.runtimeType == ShortTaskInfo) return object;
    return new ShortTaskInfo(
      taskID: object['taskID'],
      title: object['title'],
      value: object['value'],
      isCompleted: object['isCompleted'],
      startTime: object['startTime'],
      endTime: object['endTime'],
      parentGroupID: object['parentGroupID'],
      parentGroupManagerID: object['parentGroupManagerID'],
      assignedUsers: UserUtils.generateUsersMapFromObject(object['assignedUsers']),
    );
  }

  static Map<String, dynamic> generateObjectFromTasksMap(Map<String, ShortTaskInfo> tasks) {
    Map<String, dynamic> tasksMapObject = new Map();
    tasks.forEach((taskID, shortTaskInfo) {
      tasksMapObject.putIfAbsent(taskID, () {
        return generateObjectFromShortTaskInfo(shortTaskInfo);
      });
    });
    return tasksMapObject;
  }

  static Map<String, dynamic> generateObjectFromShortTaskInfo(ShortTaskInfo shortTaskInfo) {
    return {
      'taskID': shortTaskInfo.taskID,
      'title': shortTaskInfo.title,
      'value': shortTaskInfo.value,
      'parentGroupID': shortTaskInfo.parentGroupID,
      'parentGroupManagerID': shortTaskInfo.parentGroupManagerID,
      'isCompleted': shortTaskInfo.isCompleted,
      'startTime': shortTaskInfo.startTime.toString(),
      'endTime': shortTaskInfo.endTime.toString(),
      'assignedUsers': UserUtils.generateObjectFromUsersMap(shortTaskInfo.assignedUsers),
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
      'isCompleted': taskInfo.isCompleted,
      'startTime': taskInfo.startTime,
      'endTime': taskInfo.endTime,
      'assignedUsers': UserUtils.generateObjectFromUsersMap(taskInfo.assignedUsers),
      'recurringPolicy': taskInfo.recurringPolicy,
    };
  }
}
