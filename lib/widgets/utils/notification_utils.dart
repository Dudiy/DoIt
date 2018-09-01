import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:do_it/private.dart';

class Notifier {
  sendNotifications({
    @required String title,
    @required String body,
    @required List<String> destUsersFcmTokens,
    Map<String, String> data,
  }) {
    if (destUsersFcmTokens == null || destUsersFcmTokens.length == 0) return;
    if (data == null) {
      data = new Map();
    }
    data.putIfAbsent("click_action", () => "FLUTTER_NOTIFICATION_CLICK"); //, "id": "1", "status": "done"
    data.putIfAbsent("title", () => title);
    data.putIfAbsent("body", () => body);
    destUsersFcmTokens.forEach((fcmToken) {
      http
          .post("https://fcm.googleapis.com/fcm/send",
              headers: {
                "Content-Type": "application/json",
                "Authorization": "key=${Private.notificationAuthKey}",
              },
              body: jsonEncode({
                "notification": {"title": title, "body": body},
                "priority": "high",
                "data": data,
                "to": fcmToken,
              }))
          .then((res) {
        print(res);
      });
    });
  }
}
