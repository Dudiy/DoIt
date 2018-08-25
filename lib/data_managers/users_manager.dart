import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/constants/db_constants.dart';
import 'package:do_it/data_classes/user/user_info_short.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UsersManager {
  Firestore _firestore;
  final App app = App.instance;

  UsersManager(this._firestore);

  // [] on parameter to make them optional
  Future<void> addUser(FirebaseUser user, [String displayName = "", String photoUrl = ""]) async {
    await _firestore.document('$USERS/${user.uid}').setData(<String, dynamic>{
      'userID': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? displayName,
      'photoUrl': user.photoUrl ?? photoUrl,
    });
  }

  Future<void> deleteUser() async {
    if (app.loggedInUser == null) throw Exception('UserManager: Cannot delete - no user is logged in');
    String userID = app.loggedInUser.userID;
    await App.instance.groupsManager.deleteAllGroupsUserIsManagerOf(userID);
    await App.instance.groupsManager.deleteUserFromAllGroups(userID);
    await App.instance.tasksManager.removeUserFromAllAssignedTasks(userID);
    await _firestore.document('$USERS/$userID').delete();
    await App.instance.authenticator.deleteUser();
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
    return new ShortUserInfo(
      userID: userDoc['userID'],
      displayName: userDoc['displayName'],
      photoUrl: userDoc['photoUrl'],
    );
  }

  Future uploadProfilePic() async {
    StorageReference storageRef = app.firebaseStorage.ref();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      // TODO do we want to limit the file size?
      double fileSizeInMb = await file.length() / 1000000;
      if (fileSizeInMb > MAX_PROFILE_PIC_SIZE_MB)
        throw Exception('UsersManager: cannot upload profile pic, max file size is $MAX_PROFILE_PIC_SIZE_MB Mb');
      StorageUploadTask uploadTask = storageRef.child("users/${app.loggedInUser.userID}/profile.jpg").putFile(file);
      await uploadTask.future.then((uploadTask) {
        updateUser(app.loggedInUser.userID, uploadTask.downloadUrl.toString());
        App.instance.loggedInUser.photoUrl = uploadTask.downloadUrl.toString();
      });
    }
  }

  // returns null if given email is not found
  Future<ShortUserInfo> getShortUserInfoByEmail(String newMemberEmail) async {
    ShortUserInfo newMemberInfo;
    QuerySnapshot query =
        await _firestore.collection('$USERS').where('email', isEqualTo: newMemberEmail).getDocuments();
    List<DocumentSnapshot> documents = query.documents;
    if (documents.length > 0) {
      DocumentSnapshot newMemberDoc = query.documents.firstWhere((doc) {
        return doc.data['email'] == newMemberEmail;
      });
      if (newMemberDoc.data != null) {
        newMemberInfo = UserUtils.generateShortUserInfoFromObject(newMemberDoc.data);
      }
    }
    return newMemberInfo;
  }
}
