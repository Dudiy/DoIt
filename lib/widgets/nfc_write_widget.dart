import 'package:do_it/app.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NfcWritePage extends StatefulWidget {
  final String _taskId;

  NfcWritePage(this._taskId);

  @override
  NfcWritePageState createState() {
    return new NfcWritePageState();
  }
}

class NfcWritePageState extends State<NfcWritePage> {
  static const CLASS_PATH = "doit:nfc";
  static const GET_LAST_TEXT_READ_AND_RESET = "getLastTextReadAndReset";
  static const SET_STATE = "setState";
  static const GET_STATE = "getState";
  static const  SET_TEXT_TO_WRITE = "setTextToWrite";
  static const READ_STATE = "1";
  static const WRITE_STATE = "2";
  static const platform = const MethodChannel(CLASS_PATH);
  final app = App.instance;
  final TextEditingController _taskIdToWrite = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Write task to NFC"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Please put device on NFC tag",
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _enableWriteToNfc();
  }

  @override
  void dispose() {
    super.dispose();
    _disableWriteToNfc();
  }

  _enableWriteToNfc() async {
    platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': WRITE_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
    });
    platform.invokeMethod(SET_TEXT_TO_WRITE, <String, dynamic>{
      'textToWrite': widget._taskId == null ? "" : widget._taskId ,
    }).then((returnVal) {
      print("when device get NFC it will write: " + _taskIdToWrite.text);
    });
  }

  _disableWriteToNfc() async {
    platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': READ_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
    });
  }


}
