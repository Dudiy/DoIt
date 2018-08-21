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
      platform.invokeMethod(GET_LAST_TEXT_READ_AND_RESET).then((textReadFromNfc) {
        if (textReadFromNfc != null) {
          platform.invokeMethod(GET_STATE).then((nfcState) {
            print("NFC state: " + nfcState);
            if (READ_STATE.toString() == nfcState) {
              // TODO method on textReadFromNfc
              print("NFC REAS TEST: " + textReadFromNfc);
            } else {
              // TODO method on textReadFromNfc
              print("NFC WRITE TEST: " + textReadFromNfc);
            }
          });
        } else {
          // TODO delete
          print("NFC TEST: there isn't data to read");
        }
      });
    } on PlatformException catch (e) {
      print("NFC exception");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null)
      return Text('This widget has not observed any lifecycle changes.', textDirection: TextDirection.ltr);

    return Text('The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
        textDirection: TextDirection.ltr);
  }
}

//void main() {
//  runApp(Center(child: LifecycleWatcher()));
//}
