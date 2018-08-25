import 'package:do_it/app.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NfcWritePage extends StatefulWidget {
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
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DoItTextField(
                      controller: _taskIdToWrite,
                      label: 'Task id to write to NFC',
                      isRequired: true,
                      textInputType: TextInputType.text,
                    ),
                    RaisedButton(
                      onPressed: _enableWriteToNfc,
                      child: const Text('write to nfc'),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _enableWriteToNfc() async {
    await platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': WRITE_STATE,
    }).then((returnVal) {
      print("write NFC status: " + returnVal);
    });
    await platform.invokeMethod(SET_TEXT_TO_WRITE, <String, dynamic>{
      'textToWrite': _taskIdToWrite == null ? "" : _taskIdToWrite.text,
    }).then((returnVal) {
      print("when device get NFC it will write: " + _taskIdToWrite.text);
    });
  }
}
