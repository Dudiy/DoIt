import 'package:meta/meta.dart';

class ShortUserInfo {
  String _userID;
  String _displayName;
  String _photoUrl;
  String _fcmToken;

  ShortUserInfo({
    @required userID,
    @required displayName,
    @required fcmToken,
    photoUrl,
  }) {
    assert(userID != null && userID.isNotEmpty);
    assert(displayName != null && displayName.isNotEmpty);
    assert(fcmToken != null && fcmToken.isNotEmpty);
    this._userID = userID;
    this._displayName = displayName;
    this._photoUrl = photoUrl;
    this._fcmToken = fcmToken;
  }

  String get photoUrl => _photoUrl; // ignore: unnecessary_getters_setters

  String get displayName => _displayName;

  String get userID => _userID;

  String get fcmToken => _fcmToken;

  set photoUrl(String value) => _photoUrl = value; // ignore: unnecessary_getters_setters

}
