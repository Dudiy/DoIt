
import 'package:do_it/data_classes/task/task_info.dart';

///
/// message for UI
///
enum TaskCompleteResult {
  SUCCESS,
  USER_NOT_LOGGED_IN,
  USER_WHO_COMPLETED_TASK_NOT_FOUND,
  TASK_NOT_FOUND,
  USER_NOT_ASSIGNED_TO_TASK,
  // group or user delete after task assign
  INNER_SYSTEM_INVALID_TASK,
}

class TaskCompleteResultUtils {
  static String message(TaskCompleteResult enumType, String taskTitle) {
    switch (enumType) {
      case TaskCompleteResult.SUCCESS:
        return "Task \""+ taskTitle +"\" complete !! :)";
      case TaskCompleteResult.USER_NOT_LOGGED_IN:
        return "Please log in first in order to complete the task";
      case TaskCompleteResult.USER_WHO_COMPLETED_TASK_NOT_FOUND:
        return "Please reconnect to the application in order to complete the task";
      case TaskCompleteResult.TASK_NOT_FOUND:
        return "Task not exist any more";
      case TaskCompleteResult.USER_NOT_ASSIGNED_TO_TASK:
        return "You aren't assigned to this task";
      case TaskCompleteResult.INNER_SYSTEM_INVALID_TASK:
        return "Task not exist any more";
      default:
        return "Unknown complete task status";
    }
  }
}
