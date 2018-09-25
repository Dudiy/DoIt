import 'dart:convert';
import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/private.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class Notifier {
  Future<void> sendNotifications({
    @required String title,
    @required String body,
    @required Map<String, String> destUsersFcmTokens,
    Map<String, String> data,
  }) async {
    if (destUsersFcmTokens == null || destUsersFcmTokens.length == 0) return;
    if (data == null) {
      data = new Map();
    }
    data.putIfAbsent("click_action", () => "FLUTTER_NOTIFICATION_CLICK"); //, "id": "1", "status": "done"
    data.putIfAbsent("title", () => title);
    data.putIfAbsent("body", () => body);
    List<Future<MapEntry<String, http.Response>>> postNotificationFunctions = new List();
    destUsersFcmTokens.keys.forEach((fcmToken) {
      postNotificationFunctions.add(postNotification(title, body, data, fcmToken));
    });
    List<MapEntry<String, http.Response>> responses = await Future.wait(postNotificationFunctions);
    Iterable<MapEntry<String, http.Response>> badResponses = responses.where((res) => res.value.statusCode != 200);
    if (badResponses.length > 0) {
      String exceptionMsg = 'Error while sending notifications, the following users did not get the notification:\n';
      badResponses.forEach((entry) {
        exceptionMsg += '${destUsersFcmTokens[entry.key]}\n';
      });
      throw Exception(exceptionMsg);
    }

//    destUsersFcmTokens.forEach((fcmToken) async {
//      await postNotification(title, body, data, fcmToken);
//    });
  }

  Future<MapEntry<String, http.Response>> postNotification(
      String title, String body, Map<String, String> data, String fcmToken) async {
    http.Response res = await http.post(
      "https://fcm.googleapis.com/fcm/send",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=${Private.notificationAuthKey}",
      },
      body: jsonEncode(
        {
          "notification": {"title": title, "body": body},
          "priority": "high",
          "data": data,
          "to": fcmToken,
        },
      ),
    );
    return MapEntry(fcmToken, res);
  }
}
