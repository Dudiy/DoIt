import 'package:do_it/app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:do_it/widgets/image_picker.dart';

class UserSettingsPage extends StatefulWidget {
  final VoidCallback onSignedOut;

  UserSettingsPage(this.onSignedOut);

  @override
  UserSettingsPageState createState() {
    return new UserSettingsPageState();
  }
}

class UserSettingsPageState extends State<UserSettingsPage> {
  final app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("user info"), actions: <Widget>[]),
        body: SafeArea(
            child: Container(
                child: Column(children: <Widget>[
          RaisedButton(
            onPressed: () async {
              final FirebaseUser currentUser = await App.instance.authenticator.getCurrentUser();
              app.authenticator.sendPasswordResetEmail(currentUser.email);
            },
            child: const Text('reset password'),
          ),
          RaisedButton(
            onPressed: () {
              app.usersManager.deleteUser().then((val) {
                widget.onSignedOut();
                Navigator.pop(context);
              });
            },
            child: const Text('Delete user'),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onSignedOut();
            },
            child: const Text('Sign out'),
          ),
//          ImagePickerPage(),
        ]))));
  }
}
