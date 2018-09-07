import 'package:do_it/data_managers/task_manager_result.dart';

class TaskException implements Exception {
  TaskMethodResult _result;
  final Exception _exception;

  TaskException(this._result, String message) : _exception = new Exception(message);

  TaskMethodResult get result => _result;

  @override
  String toString() {
    return _exception.toString();
  }


}
