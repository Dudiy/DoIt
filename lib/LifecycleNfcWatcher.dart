import 'package:do_it/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LifecycleNfcWatcher extends StatefulWidget {
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
  AppLifecycleState _lastLifecycleState;

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
      _lastLifecycleState = state;
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
      if(taskId != null){
        print("NFC READ TEST: " + taskId);
        App.instance.tasksManager.completeTask(
            taskID: taskId,
            userWhoCompletedID: App.instance.getLoggedInUserID()
        );
      }
    });
  }

  ///
  /// write to nfc already done
  /// switch to read NFC mode
  ///
  void _writeToNfc() {
    platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': READ_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null)
      return Text('This widget has not observed any lifecycle changes.', textDirection: TextDirection.ltr);

    return Text('The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
        textDirection: TextDirection.ltr);
  }
}
