import 'dart:async';

import 'package:do_it/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class Authenticator {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    // TODO for now only work with hard code config per computer
    // https://stackoverflow.com/questions/40088741/google-sign-in-error-statusstatuscode-developer-error-resolution-null
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await getCurrentUser();
    assert(user.uid == currentUser.uid);

    print('$user has signed in using google \n Adding to firebase...');
    await App.instance.usersManager.addUser(user);
    await App.instance.setLoggedInUser(user);
    print('${user.displayName} wass added to firebase');
    return user;
  }

  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    assert(user.email != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    await App.instance.setLoggedInUser(user);
    print('$user has signed in using email and password');
    return user;
  }

  Future<FirebaseUser> registerUserWithEmailAndPassword(
      {@required String email, @required String password, @required String displayName, String photoUrl}) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    try {
      await App.instance.usersManager.addUser(user, displayName, photoUrl);
    } catch (e) {
      await user.delete();
      throw new Exception('The user was not added - error while adding to DB. \n inner exception: $e');
    }

    await App.instance.setLoggedInUser(user);
    return user;
  }

  void sendPasswordResetEmail() async {
    final FirebaseUser currentUser = await getCurrentUser();
    _firebaseAuth.sendPasswordResetEmail(email: currentUser.email).whenComplete(() {
      print("password reset successfully, email sent");
    });
  }

  Future<void> deleteUser() async {
    final FirebaseUser currentUser = await getCurrentUser();
    await currentUser.delete().whenComplete((){
      print("user auth removed");
    });
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
