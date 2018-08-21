import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_managers/groups_manager.dart';
import 'package:do_it/data_managers/tasks_manager.dart';
import 'package:do_it/data_managers/users_manager.dart';
import 'package:do_it/private.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  updateLoggedInUserPhotoUrl(String url){
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
    await authenticator.getCurrentUser().then((user) async {
      if (user != null) {
        await usersManager.getShortUserInfo(user.uid).then((shortUserInfo) {
          // if the current logged in user is no longer in the DB sign out
          if (shortUserInfo == null) FirebaseAuth.instance.signOut();
          _loggedInUser = shortUserInfo;
        });
      }
    });
  }

  // TODO delete
  Future test() async {
    print('in test');
    App.instance.groupsManager.joinGroup('2f05b57d-b4b0-40d3-8b50-c3095e4af68e');
//    App.instance.usersManager.deleteUser();
//    App.instance.groupsManager.deleteGroup(groupID: '3d74aec1-8200-402c-9ca4-8ad16b5d96ad');
  }
}
