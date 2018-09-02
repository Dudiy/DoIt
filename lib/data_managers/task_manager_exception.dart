import 'package:do_it/data_managers/task_manager_result.dart';

class TaskException implements Exception {
  TaskCompleteResult _result;
  final Exception _exception;

  TaskException(this._result, String message) : _exception = new Exception(message);

  TaskCompleteResult get result => _result;
}
