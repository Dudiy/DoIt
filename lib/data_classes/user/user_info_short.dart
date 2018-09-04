import 'package:meta/meta.dart';

class ShortUserInfo {
  String _userID;
  String _displayName;
  String _photoUrl;

  ShortUserInfo({
    @required userID,
    @required displayName,
    photoUrl,
  }) {
    assert(userID != null && userID.isNotEmpty);
    assert(displayName != null && displayName.isNotEmpty);
    this._userID = userID;
    this._displayName = displayName;
    this._photoUrl = photoUrl;
  }

  // ===========================================================
  // ========================= Getters =========================
  // ===========================================================
  String get photoUrl => _photoUrl; // ignore: unnecessary_getters_setters

  String get displayName => _displayName;

  String get userID => _userID;

  // ===========================================================
  // ========================= Setters =========================
  // ===========================================================
  set photoUrl(String value) =>
      _photoUrl = value; // ignore: unnecessary_getters_setters

}
