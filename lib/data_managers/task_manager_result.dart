import 'package:do_it/data_classes/task/task_info.dart';

///
/// message for UI
///
enum TaskMethodResult {
  COMPLETE_SUCCESS,
  USER_NOT_LOGGED_IN,
  USER_WHO_COMPLETED_TASK_NOT_FOUND,
  TASK_NOT_FOUND,
  USER_NOT_ASSIGNED_TO_TASK,
  // group or user delete after task assign
  INNER_SYSTEM_INVALID_TASK,
  START_TIME_AFTER_END_TIME,
  ADD_TASK_FAIL,
}

class TaskMethodResultUtils {
  static String message(TaskMethodResult enumType, [String taskTitle =""]) {
    switch (enumType) {
      case TaskMethodResult.COMPLETE_SUCCESS:
        return "Task \"" + taskTitle + "\" complete !! :)";
      case TaskMethodResult.USER_NOT_LOGGED_IN:
        return "Please log in first in order to complete the task";
      case TaskMethodResult.USER_WHO_COMPLETED_TASK_NOT_FOUND:
        return "Please reconnect to the application in order to complete the task";
      case TaskMethodResult.TASK_NOT_FOUND:
        return "Task not exist any more";
      case TaskMethodResult.USER_NOT_ASSIGNED_TO_TASK:
        return "You aren't assigned to this task";
      case TaskMethodResult.INNER_SYSTEM_INVALID_TASK:
        return "Task not exist any more";
      case TaskMethodResult.START_TIME_AFTER_END_TIME:
        return "start time can\'t be after end time";
      case TaskMethodResult.ADD_TASK_FAIL:
        return "fail to add task";
      default:
        return "Unknown complete task status";
    }
  }
}
