import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/data_managers/tasks_manager.dart';
import 'package:do_it/data_managers/users_manager.dart';
import 'package:do_it/private.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/utils/notification_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  // disabling the default ctor
  App._internalCtor();

  static final App instance = new App._internalCtor();

  ShortUserInfo get loggedInUser => _loggedInUser;

  String generateRandomID() {
    return uuid.v4();
  }

  Future setLoggedInUser([FirebaseUser user]) async {
    if (_loggedInUser != null && user != null) {
      throw Exception('App: cannot set logged in user when user is already logged in');
    }
    _loggedInUser = user == null ? null : await usersManager.getShortUserInfo(user.uid);
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

  Future<void> init(FirebaseApp app) async {
    firestore = new Firestore(app: app);
    usersManager = new UsersManager(firestore);
    groupsManager = new GroupsManager(firestore);
    tasksManager = new TasksManager(firestore);
    firebaseStorage = new FirebaseStorage(app: app, storageBucket: Private.storageBucket);
    firebaseMessaging = new FirebaseMessaging();
    await authenticator.getCurrentUser().then((user) async {
      if (user != null) {
        await usersManager.getShortUserInfo(user.uid).then((shortUserInfo) {
          // if the current logged in user is no longer in the DB sign out and delete the user
          if (shortUserInfo == null) {
            FirebaseAuth.instance.signOut();
          } else {
            refreshLoggedInUserFcmToken();
          }
          _loggedInUser = shortUserInfo;
        });
      }
    });
/*    firebaseMessaging.configure(
      // when app is closed
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch message:');
      },
      // when app is running
      onMessage: (Map<String, dynamic> message) {

        print('onMessage message:');
      },
      // when app is minimised
      onResume: (Map<String, dynamic> message) {
        print('onResume message:');
      },
    );*/
  }

  Future refreshLoggedInUserFcmToken() async {
    String currentToken = await firebaseMessaging.getToken();
    String loggedInUserToken = await usersManager.getFcmToken(loggedInUser.userID);
    if (loggedInUserToken != currentToken) {
      usersManager.updateFcmToken(loggedInUser.userID, currentToken);
    }
  }

  // TODO delete
  Future test() async {
    var app = App.instance;
    print('in test');
    print('end of test');
  }

  Future<void> testAsync() async {
    print('starting func');
    await App.instance.firebaseStorage
        .ref()
        .child("users/${App.instance.loggedInUser.userID}/profile.jpg")
        .getData(5000000)
        .whenComplete(() {
      print('download complete');
      sleep(Duration(seconds: 3));
      print('after sleep');
    });
    print('testAsync function returning');
  }
}
