import 'dart:async';

import 'package:flutter/services.dart';

class NfcWriter {
  static const CLASS_PATH = "doit:nfc";
  static const GET_LAST_TEXT_READ_AND_RESET = "getLastTextReadAndReset";
  static const SET_STATE = "setState";
  static const GET_STATE = "getState";
  static const SET_TEXT_TO_WRITE = "setTextToWrite";
  static const READ_STATE = "1";
  static const WRITE_STATE = "2";
  static const platform = const MethodChannel(CLASS_PATH);
  final String _taskId;

  NfcWriter(this._taskId);

  Future<void> enableWrite() async {
    await platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': WRITE_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
      platform.invokeMethod(SET_TEXT_TO_WRITE, <String, dynamic>{
        'textToWrite': _taskId == null ? "" : _taskId,
      }).then((returnVal) {
        print("when device get NFC it will write: " + _taskId);
      });
    });
  }

  Future<void> disableWrite() async {
    platform.invokeMethod(SET_STATE, <String, dynamic>{
      'state': READ_STATE,
    }).then((returnVal) {
      print("NFC status: " + returnVal);
    });
  }
}
