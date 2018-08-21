import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/my_groups_widget.dart';
import 'package:do_it/widgets/user_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  final App app = App.instance;

  @override
  TestPageState createState() {
    return new TestPageState();
  }
}

class TestPageState extends State<TestPage> {
  static const platform = const MethodChannel('doit.flutter.io/nfc');

  String _batteryLevel = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }
}
