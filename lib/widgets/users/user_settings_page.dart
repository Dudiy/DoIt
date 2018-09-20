import 'dart:io';

import 'package:do_it/app.dart';
import 'package:do_it/constants/background_images.dart';
import 'package:do_it/data_classes/user/user_info.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
//import 'package:do_it/widgets/image_picker.dart';

class UserSettingsPage extends StatefulWidget {
  final VoidCallback onSignedOut;
  final Function onProfilePicChanged;

  UserSettingsPage(this.onSignedOut, this.onProfilePicChanged);

  @override
  UserSettingsPageState createState() {
    return new UserSettingsPageState();
  }
}

class UserSettingsPageState extends State<UserSettingsPage> {
  final app = App.instance;
  final LoadingOverlay loadingOverlay = new LoadingOverlay();
  UserInfo userInfo;
  File uploadedImageFile;

  @override
  void initState() {
    app.usersManager.getFullUserInfo(app.loggedInUser.userID).then((retrievedUserInfo) {
      setState(() {
        userInfo = retrievedUserInfo;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.instance.themeData.primaryColor,
        title: Text("App settings"),
      ),
      body: SafeArea(
        child: Container(
          decoration: app.getBackgroundImage(),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                color: app.themeData.primaryColorLight.withAlpha(200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: Row(
                  children: <Widget>[
                    _profilePicture(),
                    _userDetails(context),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        child: const Text('Change theme'),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          "Select Theme",
                                          style: Theme.of(context).textTheme.title.copyWith(
                                              fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                      new Expanded(
                                        child: GridView.count(
                                          primary: true,
                                          padding: EdgeInsets.all(20.0),
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.0,
                                          mainAxisSpacing: 20.0,
                                          crossAxisSpacing: 20.0,
                                          children: List.generate(backgroundImages.length, (i) {
                                            return _imageContainerWithText(
                                                imageContainer: ImageContainer(
                                                    assetPath: backgroundImages.values.toList()[i]["assetPath"],
                                                    size: 25.0),
                                                imageSize: 50.0,
                                                onTap: () {
                                                  app.usersManager.updateBgImage(
                                                      userInfo.userID, backgroundImages.keys.toList()[i]);
                                                  setState(() {
                                                    app.bgImagePath = backgroundImages.values.toList()[i]["assetPath"];
                                                    app.themeData = backgroundImages.values.toList()[i]["themeData"];
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                textOverlay: backgroundImages.keys.toList()[i],
                                                fontSize: 15.0,
                                                fontColor: Colors.black,
                                                textBackgroundColor:
                                                    (backgroundImages.values.toList()[i]["themeData"] as ThemeData)
                                                        .primaryColorLight);
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              /**/
                            },
                          );
                        },
                      ),
                      RaisedButton(
                        child: const Text('Reset password'),
                        onPressed: () async {
                          final Auth.FirebaseUser currentUser = await App.instance.authenticator.getCurrentUser();
                          app.authenticator.sendPasswordResetEmail(currentUser.email);
                          DoItDialogs.showNotificationDialog(
                            context: context,
                            title: "Reset password",
                            body: "Reset password email has been sent to ${userInfo?.email}",
                          );
                        },
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSignedOut();
                        },
                        child: const Text('Sign out'),
                      ),
                      Expanded(child: Container()),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePicture() {
    const double PROFILE_PIC_SIZE = 100.0;
    var editImageText = <Widget>[
      Expanded(
        child: Container(),
      ),
      Container(
        width: PROFILE_PIC_SIZE - 2,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          color: Colors.black54,
        ),
        child: Text(
          'tap to change',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13.0),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          App.instance.usersManager
              .uploadProfilePic(() => loadingOverlay.show(context: context, message: "Updating profile picture..."))
              .then((uploadedPhoto) {
            setState(() {
              uploadedImageFile = uploadedPhoto;
            });
            widget.onProfilePicChanged(uploadedPhoto);
            loadingOverlay.hide();
          });
        },
        child: Stack(
          children: <Widget>[
            ImageContainer(
              size: PROFILE_PIC_SIZE,
              imagePath: app.loggedInUser.photoUrl,
              imageFile: uploadedImageFile,
              defaultImagePath: "assets/images/unknown_profile_pic.jpg",
            ),
            Container(
              height: PROFILE_PIC_SIZE,
              width: PROFILE_PIC_SIZE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisSize: MainAxisSize.max,
                children: editImageText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _userDetails(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Display name: ${app.loggedInUser.displayName}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Email: ${userInfo == null ? "" : userInfo.email}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'User ID: ',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  '${app.loggedInUser.userID}',
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _imageContainerWithText({
    @required ImageContainer imageContainer,
    Color textBackgroundColor = Colors.black54,
    double imageSize = 25.0,
    String textOverlay = "",
    VoidCallback onTap,
    double fontSize = 16.0,
    Color fontColor = Colors.white70,
  }) {
    var editImageText = <Widget>[
      Expanded(
        child: Container(),
      ),
      Container(
        width: imageSize - 2,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          color: textBackgroundColor,
        ),
        child: Text(
          textOverlay,
          textAlign: TextAlign.center,
          style: TextStyle(color: fontColor, fontSize: fontSize),
        ),
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          imageContainer,
          Container(
            height: imageSize,
            width: imageSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: editImageText,
            ),
          ),
        ],
      ),
    );
  }
}
