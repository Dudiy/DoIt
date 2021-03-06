import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/data_classes/task/task_info.dart';
import 'package:do_it/data_managers/task_manager_exception.dart';
import 'package:do_it/data_managers/task_manager_result.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LifecycleNfcWatcher extends StatefulWidget {
  final Function _renderHomePage;

  LifecycleNfcWatcher(this._renderHomePage);

  @override
  _LifecycleNfcWatcherState createState() => _LifecycleNfcWatcherState();
}

class _LifecycleNfcWatcherState extends State<LifecycleNfcWatcher> with WidgetsBindingObserver {
  static const CLASS_PATH = "doit:nfc";
  static const GET_LAST_TEXT_READ_AND_RESET = "getLastTextReadAndReset";
  static const GET_STATE = "getState";
  static const SET_STATE = "setState";
  static const READ_STATE = "1";
  static const WRITE_STATE = "2";
  static const NA_STATE = "0";
  static const platform = const MethodChannel(CLASS_PATH);
  final App app = App.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _handleNfc();
    });
  }

  void _handleNfc() {
    try {
      platform.invokeMethod(GET_STATE).then((nfcState) {
        print("NFC state: " + nfcState);
        switch (nfcState) {
          case READ_STATE:
            _readFromNfc();
            break;
          case WRITE_STATE:
            _writeToNfc();
            break;
          case NA_STATE:
            print("NFC NA TEST: there isn't data to read");
            break;
        }
      });
    } on PlatformException {
      print("NFC exception");
    }
  }

  void _readFromNfc() {
    platform.invokeMethod(GET_LAST_TEXT_READ_AND_RESET).then((taskId) {
      if (taskId != null) {
        print("NFC READ TEST: " + taskId);
        _completeTask(taskId);
      }
    });
  }

  Future<void> _completeTask(taskId) async {
    TaskInfo taskInfo = await app.tasksManager.getTaskById(taskId);
    await app.tasksManager.completeTask(taskID: taskId, userWhoCompletedID: app.getLoggedInUserID()).then((dummyVal) {
      print(TaskMethodResult.COMPLETE_SUCCESS.toString());
      DoItDialogs.showNotificationDialog(
        context: context,
        title: "NFC tag scanned",
        body: TaskMethodResultUtils.message(TaskMethodResult.COMPLETE_SUCCESS, taskInfo.title),
      );
      widget._renderHomePage();
    }).catchError((error) {
      print(error.toString());
      if (error is TaskException) {
        DoItDialogs.showErrorDialog(
          context: context,
          message: TaskMethodResultUtils.message(error.result),
        );
      }
    });
  }

  ///
  /// write to nfc already done
  /// switch to read NFC mode
  ///
  Future<void> _writeToNfc() async {
    await platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': READ_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}
