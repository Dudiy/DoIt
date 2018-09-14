import 'package:do_it/app.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
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
  final LoadingOverlay loadingOverlay = new LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("user info"), actions: <Widget>[]),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  final FirebaseUser currentUser = await App.instance.authenticator.getCurrentUser();
                  app.authenticator.sendPasswordResetEmail(currentUser.email);
                },
                child: const Text('reset password'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSignedOut();
                },
                child: const Text('Sign out'),
              ),
              Divider(),
              RaisedButton(
                color: Theme.of(context).errorColor,
                child: const Text('Delete user', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  DoItDialogs.showConfirmDialog(
                    context: context,
                    message: "are you sure you want to delete this account? this cannot be undone",
                    isWarning: true,
                    actionButtonText: "Delete accout",
                  ).then((deleteConfirmed) {
                    if (deleteConfirmed) {
                      loadingOverlay.show(context: context, message: "deleting this account...");
                      app.usersManager.deleteUser().then((val) {
                        loadingOverlay.hide();
                        widget.onSignedOut();
                        Navigator.pop(context);
                      });
                    }
                  });
                },
              ),
//          ImagePickerPage(),
            ],
          ),
        ),
      ),
    );
  }
}
