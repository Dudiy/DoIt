import 'dart:io';

import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/widgets/custom/imageFetcher.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/groups/my_groups_widget.dart';
import 'package:do_it/widgets/nfc/lifecycle_nfc_watcher.dart';
import 'package:do_it/widgets/users/user_settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignedOut;
  final App app = App.instance;

  HomePage({this.onSignedOut});

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static const LOADING_GIF = LOADING_ANIMATION;
  static const DEFAULT_PICTURE = UNKNOWN_PROFILE_PIC;
  LoadingOverlay loadingOverlay = new LoadingOverlay();
  String photoUrl = DEFAULT_PICTURE;
  File userProfilePicFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (App.instance.loggedInUser?.photoUrl != null && App.instance.loggedInUser?.photoUrl != "") {
      photoUrl = App.instance.loggedInUser?.photoUrl;
    } else {
      photoUrl = DEFAULT_PICTURE;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: App.instance.themeData.primaryColor,
          leading: GestureDetector(
            onTap: () {
              App.instance.usersManager
                  .uploadProfilePic(() => loadingOverlay.show(context: context, message: "Uploading image..."))
                  .then((uploadedPhoto) {
                loadingOverlay.hide();
                setState(() {
                  photoUrl = App.instance.loggedInUser.photoUrl;
                  if (uploadedPhoto != null) {
                    userProfilePicFile = uploadedPhoto;
                  }
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(children: <Widget>[
                Center(
                  child: Container(
                      width: 65.0,
                      height: 65.0,
                      child: ClipOval(
                        child: _getProfilePic(),
                      )),
                ),
                Container(child: LifecycleNfcWatcher(_nfcTriggerRender)),
              ]),
            ),
          ),
          title: Text(App.instance.loggedInUser.displayName),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserSettingsPage(widget.onSignedOut, profilePicChanged)));
              },
            ),
          ],
        ),
        body: MyGroupsPage());
  }

  void profilePicChanged(File newProfilePic) {
    setState(() {
      userProfilePicFile = newProfilePic;
    });
  }

  _getProfilePic() {
    return userProfilePicFile == null
        ? ImageFetcher.fetch(imagePath: photoUrl, defaultImagePath: DEFAULT_PICTURE)
        : Image.file(
            userProfilePicFile,
            fit: BoxFit.fill,
          );
  }

  _nfcTriggerRender() {
    setState(() {
      // empty implementation in order to render that widget
    });
  }
}
