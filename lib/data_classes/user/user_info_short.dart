class ShortUserInfo {
  String _userID;
  String _displayName;
  String _photoUrl;

  ShortUserInfo({userID, displayName, photoUrl}) {
    this._userID = userID;
    this._displayName = displayName;
    this._photoUrl = photoUrl;
  }

  String get photoUrl => _photoUrl; // ignore: unnecessary_getters_setters

  String get displayName => _displayName;

  String get userID => _userID;

  set photoUrl(String value) => _photoUrl = value; // ignore: unnecessary_getters_setters
}
