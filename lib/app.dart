import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/constants/background_images.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/data_managers/tasks_manager.dart';
import 'package:do_it/data_managers/users_manager.dart';
import 'package:do_it/private.dart';
import 'package:do_it/widgets/utils/notification_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

///
/// singleton class
///
class App {
  ShortUserInfo _loggedInUser;
  Firestore firestore;
  UsersManager usersManager;
  GroupsManager groupsManager;
  TasksManager tasksManager;
  FirebaseStorage firebaseStorage;
  FirebaseMessaging firebaseMessaging;
  Notifier notifier = new Notifier();
  final Authenticator authenticator = new Authenticator();
  final Uuid uuid = new Uuid();
  String bgImagePath = BG_IMAGE_BLUE;
  ThemeData themeData = new ThemeData(
    primaryColor: Colors.blue,
    primaryColorLight: Colors.blueAccent[100],
  );

  // disabling the default ctor
  App._internalCtor();

  static final App instance = new App._internalCtor();

  void resetThemeData() {
    bgImagePath = BG_IMAGE_BLUE;
    themeData = new ThemeData(
      primaryColor: Colors.blue,
      primaryColorLight: Colors.blueAccent[100],
    );
  }

  ShortUserInfo get loggedInUser => _loggedInUser;

  String generateRandomID() {
    return uuid.v4();
  }

  Future setLoggedInUser([FirebaseUser user]) async {
    if (_loggedInUser != null && user != null) {
      throw Exception('App: cannot set logged in user when user is already logged in');
    }
    if (user == null){
      // user logged out
      _loggedInUser = null;
    } else {
      ShortUserInfo userFromDB = await usersManager.getShortUserInfo(user.uid);
      // user is authenticated but not in the DB (can happen after error while deleting)
      if (userFromDB == null) {
        authenticator.deleteUser();
        throw Exception("Cannot log in, user was not found in the DB");
      }
      // login success
      _loggedInUser = userFromDB;
      // after login success get user's theme
      usersManager.getFullUserInfo(user.uid).then((userInfo) {
        if (backgroundImages[userInfo.bgImage] != null) {
          bgImagePath = backgroundImages[userInfo.bgImage]["assetPath"];
          themeData = backgroundImages[userInfo.bgImage]["themeData"];
        }
      });
    }
//    _loggedInUser = user == null ? null : await usersManager.getShortUserInfo(user.uid);
  }

  updateLoggedInUserPhotoUrl(String url) {
    _loggedInUser.photoUrl = url;
  }

  ShortUserInfo getLoggedInUser() {
    return _loggedInUser;
  }

  String getLoggedInUserID() {
    return _loggedInUser.userID;
  }

  BoxDecoration getBackgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(bgImagePath),
      ),
    );
  }

  Future<void> init(FirebaseApp app) async {
    firestore = new Firestore(app: app);
    usersManager = new UsersManager(firestore);
    groupsManager = new GroupsManager(firestore);
    tasksManager = new TasksManager(firestore);
    firebaseStorage = new FirebaseStorage(app: app, storageBucket: Private.storageBucket);
    firebaseMessaging = new FirebaseMessaging();
    await authenticator.getCurrentUser().then((user) async {
      if (user != null) {
        await usersManager.getFullUserInfo(user.uid).then((userInfo) {
          // if the current logged in user is no longer in the DB sign out and delete the user
          if (userInfo == null) {
            FirebaseAuth.instance.signOut();
          } else {
            refreshLoggedInUserFcmToken();
            if (backgroundImages[userInfo.bgImage] != null) {
              bgImagePath = backgroundImages[userInfo.bgImage]["assetPath"];
              themeData = backgroundImages[userInfo.bgImage]["themeData"];
            }
            _loggedInUser = userInfo.getShortUserInfo();
          }
        });
      }
    });
  }

  Future refreshLoggedInUserFcmToken() async {
    String currentToken = await firebaseMessaging.getToken();
    String loggedInUserToken = await usersManager.getFcmToken(loggedInUser.userID);
    if (loggedInUserToken != currentToken) {
      usersManager.updateFcmToken(loggedInUser.userID, currentToken);
    }
  }
}
