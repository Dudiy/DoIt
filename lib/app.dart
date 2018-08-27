import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/task/eRecurringPolicies.dart';
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
    var app = App.instance;

    print('in test');
//    App.instance.groupsManager.joinGroup('2c560738-7457-4ebb-af05-1d9cfec46f89');
    /*app.tasksManager.assignTaskToUser(
      taskID: '9f69bf0a-4547-4ae0-8418-be2258d4ec2e',
      userID: '7AVyihkEZlUoKkmmQqieswO2vvf1',
    );*/
    /*await app.tasksManager
        .completeTask(
      taskID: 'c9402590-cd7e-469d-8563-5e5e2fe6577a',
      userWhoCompletedID: '9Pw9pPNz8YYoFLM6QI7pDxrONIk1',
    );*/
//        .then((v) {
    /*await app.tasksManager.unCompleteTask(
      parentGroupID: 'af05e893-50b0-49c4-9333-9376bf99266f',
      taskID: '7e7c01d2-3fac-4957-a095-bf30d7bff15d',
    );*/
//    });

/*    Map<String, Map<String, dynamic>> groupScoreboards =
        await app.groupsManager.getGroupScoreboards(groupID: '2c560738-7457-4ebb-af05-1d9cfec46f89');
    groupScoreboards.forEach((userID, map){
      print('\t${map['userInfo'].displayName}:   ${map['score']}');
    });*/

//    ShortUserInfo shortUserInfoByEmail = await app.usersManager.getShortUserInfoByEmail('d@d.com');
    app.tasksManager
        .updateTask(taskIdToChange: '78c7f37d-aa5f-40f5-bc22-ab762bc7e063', recurringPolicy: eRecurringPolicy.weekly);
//    print(eRecurringPolicy.weekly);
//    print('foreach:');
//    for (var value in eRecurringPolicy.values) {
//      print(value);
//    }
    print('end of test');
  }
}
