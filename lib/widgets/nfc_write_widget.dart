import 'package:do_it/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:do_it/widgets/image_picker.dart';

class NfcWritePage extends StatefulWidget {
  NfcWritePage();

  @override
  NfcWritePageState createState() {
    return new NfcWritePageState();
  }
}

class NfcWritePageState extends State<NfcWritePage> {
  static const CLASS_PATH = "doit:nfc";
  static const GET_LAST_TEXT_READ_AND_RESET = "getLastTextReadAndReset";
  static const GET_STATE = "getState";
  static const SET_STATE = "setState";
  static const READ_STATE = "1";
  static const WRITE_STATE = "2";
  static const platform = const MethodChannel(CLASS_PATH);
  final app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                child: Column(children: <Widget>[
      RaisedButton(
        onPressed: _enableWriteToNfc,
        child: const Text('write to nfc'),
      ),
    ]))));
  }

  _enableWriteToNfc() async {
    await platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': WRITE_STATE,
    }).then((returnVal) {
      print("write NFC status: " + returnVal);
    });
  }
}
