import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/user/user_info.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UsersManager {
  Firestore _firestore;
  final App app = App.instance;

  UsersManager(this._firestore);

  // [] on parameter to make them optional
  Future<void> addUser(Auth.FirebaseUser user, [String displayName = "", String photoUrl = ""]) async {
    DocumentSnapshot documentSnapshot = await App.instance.firestore.document('$USERS/${user.uid}').get();
    bool isUserAlreadyInDB = documentSnapshot.data != null;
    String photoUrl = "";
    if (isUserAlreadyInDB && documentSnapshot['photoUrl'] != null) {
      photoUrl = documentSnapshot['photoUrl'];
    } else if (user.photoUrl != null) {
      photoUrl = user.photoUrl;
    }

    //TODO implement message handlers

    String fcmToken = await app.firebaseMessaging.getToken();

    // create new userInfo from parameters
    UserInfo userInfo = new UserInfo(
      userID: user.uid,
      displayName: user.displayName ?? displayName,
      fcmToken: fcmToken,
      email: user.email,
      photoUrl: photoUrl,
    );
    await _firestore.document('$USERS/${user.uid}').setData(UserUtils.generateObjectFromUserInfo(userInfo));
  }

  Future<void> deleteUser() async {
    if (app.loggedInUser == null) throw Exception('UserManager: Cannot delete - no user is logged in');
    String userID = app.loggedInUser.userID;
    await App.instance.groupsManager.deleteAllGroupsUserIsManagerOf(userID);
    await App.instance.groupsManager.deleteUserFromAllGroups(userID);
    // unnecessary because user is removed from all tasks when he is removed from all groups
    // TODO delete after commit
//    await App.instance.tasksManager.removeUserFromAllAssignedTasks(userID);
    print('userId: $userID - deleting user from DB'); //TODO delete
    await _firestore.document('$USERS/$userID').delete();
    print('userId: $userID - user deleted from DB'); //TODO delete
    print('userId: $userID - deleting user from Auth'); //TODO delete
    await App.instance.authenticator.deleteUser();
    print('userId: $userID - user deleted from Auth'); //TODO delete
  }

  //we only want the user to be able to change his picture and not hes other data
  Future<void> updateUser(String userID, String photoUrl) async {
    await _firestore.document('$USERS/$userID').updateData(<String, dynamic>{
      'photoUrl': photoUrl,
    });
  }

  Future<ShortUserInfo> getShortUserInfo(String userID) async {
    DocumentSnapshot userDoc = await _firestore.document('$USERS/$userID').get();
    if (userDoc.data == null) return null;
    return UserUtils.generateShortUserInfoFromObject(userDoc.data);
  }

  Future<UserInfo> getFullUserInfo(String userID) async {
    DocumentSnapshot userDoc = await _firestore.document('$USERS/$userID').get();
    if (userDoc.data == null) return null;
    return UserUtils.generateFullUserInfoFromObject(userDoc.data);
  }

  Future<File> uploadProfilePic(Function showLoadingCallback) async {
    StorageReference storageRef = app.firebaseStorage.ref();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      showLoadingCallback();
      // TODO do we want to limit the file size?
      double fileSizeInMb = await file.length() / 1000000;
      if (fileSizeInMb > MAX_PROFILE_PIC_SIZE_MB)
        throw Exception('UsersManager: cannot upload profile pic, max file size is $MAX_PROFILE_PIC_SIZE_MB Mb');
      StorageUploadTask uploadTask = storageRef.child("users/${app.loggedInUser.userID}/profile.jpg").putFile(file);
      UploadTaskSnapshot uploadTaskSnapshot = await uploadTask.future;
      updateUser(app.loggedInUser.userID, uploadTaskSnapshot.downloadUrl.toString());
      App.instance.loggedInUser.photoUrl = uploadTaskSnapshot.downloadUrl.toString();
    }
    return file;
  }

  // returns null if given email is not found
  Future<ShortUserInfo> getShortUserInfoByEmail(String newMemberEmail) async {
    ShortUserInfo newMemberInfo;
    QuerySnapshot query =
        await _firestore.collection('$USERS').where('email', isEqualTo: newMemberEmail).getDocuments();
    List<DocumentSnapshot> documents = query.documents;
    if (documents.length > 0) {
      DocumentSnapshot newMemberDoc = query.documents.firstWhere((doc) {
        return (doc.data['email'] as String).toLowerCase() == newMemberEmail;
      });
      if (newMemberDoc.data != null) {
        newMemberInfo = UserUtils.generateShortUserInfoFromObject(newMemberDoc.data);
      }
    }
    return newMemberInfo;
  }

  Future<String> getFcmToken(String userID) async {
    return (await getFullUserInfo(userID)).fcmToken;
  }

  Future<void> updateFcmToken(String userID, String newToken) async {
    App.instance.firestore.document('$USERS/$userID').updateData({
      'fcmToken' : newToken,
    });
  }
}
