import 'package:do_it/app.dart';

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
  PARENT_GROUP_NOT_FOUND,
  START_TIME_AFTER_END_TIME,
  ADD_TASK_FAIL,
}

class TaskMethodResultUtils {
  static String message(TaskMethodResult enumType, [String taskTitle = ""]) {
    final App app = App.instance;
    switch (enumType) {
      case TaskMethodResult.COMPLETE_SUCCESS:
        return "${app.strings.taskCompletedMsg} \"" + taskTitle + "\"";
      case TaskMethodResult.USER_NOT_LOGGED_IN:
        return app.strings.loginToCompleteTaskMsg;
      case TaskMethodResult.USER_WHO_COMPLETED_TASK_NOT_FOUND:
        return app.strings.userCompletedNotInDbErrMsg;
      case TaskMethodResult.TASK_NOT_FOUND:
        return app.strings.taskNotFoundErrMsg;
      case TaskMethodResult.USER_NOT_ASSIGNED_TO_TASK:
        return app.strings.userNotAssignedToTaskErrMsg;
      case TaskMethodResult.PARENT_GROUP_NOT_FOUND:
        return app.strings.parentGroupNotFoundErrMsg;
      case TaskMethodResult.START_TIME_AFTER_END_TIME:
        return app.strings.startTimeAfterEndTimeErrMsg;
      case TaskMethodResult.ADD_TASK_FAIL:
        return app.strings.addTaskFailedErrMsg;
      default:
        return app.strings.unknownCompleteTaskStatusErrMsg;
    }
  }
}
