import 'dart:async';
import 'dart:io';

import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/constants/background_images.dart';
import 'package:do_it/data_classes/user/user_info.dart';
import 'package:do_it/data_classes/user/user_info_utils.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/language_selector_dialog.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/raised_button_with_icon.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

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
  final TextEditingController _messageBodyController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String appVersion = '';
  UserInfo userInfo;
  File uploadedImageFile;

  @override
  void initState() {
    app.usersManager.getFullUserInfo(app.loggedInUser.userID).then((retrievedUserInfo) {
      if (!mounted) return;
      setState(() {
        userInfo = retrievedUserInfo;
      });
    });
    PackageInfo.fromPlatform().then((packageInfo){
      setState(() {
        appVersion = packageInfo.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.textDirection,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: app.themeData.primaryColor,
            title: Text(app.strings.appSettings),
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
                        _userDetails(),
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
                          DoItRaisedButtonWithIcon(
                            icon: Icon(Icons.color_lens, color: app.themeData.primaryColor),
                            text: Text(app.strings.changeTheme),
                            onPressed: () async => _changeThemeClicked(context),
                          ),
                          DoItRaisedButtonWithIcon(
                            icon: Icon(Icons.language, color: app.themeData.primaryColor),
                            text: Text(app.strings.changeLanguage),
                            onPressed: () async => LanguageSelector.showAsDialog(context).then((v){
                              setState(() {});
                            }),
                          ),
                          DoItRaisedButtonWithIcon(
                            icon: Icon(Icons.email, color: app.themeData.primaryColor),
                            text: Text(app.strings.messageDevs),
                            onPressed: () => _sendMessageToDevsClicked(context),
                          ),
                          DoItRaisedButtonWithIcon(
                            icon: Icon(Icons.autorenew, color: app.themeData.primaryColor),
                            text: Text(app.strings.resetPassword),
                            onPressed: () async {
                              final Auth.FirebaseUser currentUser = await app.authenticator.getCurrentUser();
                              app.authenticator.sendPasswordResetEmail(currentUser.email);
                              DoItDialogs.showNotificationDialog(
                                context: context,
                                title: app.strings.resetPassword,
                                body: '${app.strings.resetPasswordSentTo} ${userInfo?.email}',
                              );
                            },
                          ),
                          DoItRaisedButtonWithIcon(
                            icon: Icon(Icons.exit_to_app, color: app.themeData.primaryColor),
                            text: Text(app.strings.signOut),
                            onPressed: () {
                              DoItDialogs.showConfirmDialog(context: context, message: '${app.strings.signOut}?').then((confirmed) {
                                if (confirmed) {
                                  Navigator.pop(context);
                                  widget.onSignedOut();
                                }
                              });
                            },
                          ),
                          Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${app.strings.version}: $appVersion'),
                          ),),
                          Expanded(child: Container()),
                          Divider(),
                          DoItRaisedButtonWithIcon(
                            text: Text(app.strings.deleteAccount, style: TextStyle(color: Colors.white)),
                            icon: Icon(Icons.delete, color: Colors.white),
                            color: Theme.of(context).errorColor,
                            onPressed: () => _deleteUserClicked(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changeThemeClicked(BuildContext context) {
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
                    app.strings.selectTheme,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
                new Expanded(
                  child: GridView.count(
                    primary: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20.0),
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    children: List.generate(backgroundImages.length, (i) {
                      return _imageContainerWithText(
                          imageContainer:
                              ImageContainer(assetPath: backgroundImages.values.toList()[i]["assetPath"], size: 25.0),
                          imageSize: 40.0,
                          onTap: () {
                            app.usersManager.updateBgImage(userInfo.userID, backgroundImages.keys.toList()[i]);
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
                              (backgroundImages.values.toList()[i]["themeData"] as ThemeData).primaryColorLight);
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
  }

  void _sendMessageToDevsClicked(BuildContext context) {
    DoItDialogs.showUserInputDialog(
      context: context,
      title: app.strings.composeMsgToDevsTitle,
      inputWidgets: [
        DoItTextField(
          label: '',
          isRequired: true,
          maxLines: 8,
          controller: _messageBodyController,
        ),
      ],
      onSubmit: () {
        _sendMessageToDevs(_messageBodyController.text);
      },
    ).whenComplete(() => _messageBodyController.clear());
  }

  void _deleteUserClicked(BuildContext context) {
    DoItDialogs.showConfirmDialog(
      context: context,
      message: app.strings.deleteAccountConfirmMsg,
      isWarning: true,
      actionButtonText: app.strings.deleteAccount,
    ).then(
      (deleteConfirmed) {
        if (deleteConfirmed) {
          loadingOverlay.show(context: context, message: app.strings.deletingAccount);
          app.usersManager.deleteUser().whenComplete(() {
            loadingOverlay.hide();
            widget.onSignedOut();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          });
        }
      },
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
          app.strings.tapToChange,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13.0),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _profilePicClicked();
        },
        child: Stack(
          children: <Widget>[
            ImageContainer(
              size: PROFILE_PIC_SIZE,
              imagePath: app.loggedInUser.photoUrl,
              imageFile: uploadedImageFile,
              defaultImagePath: UNKNOWN_PROFILE_PIC,
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

  void _profilePicClicked() {
    app.usersManager
        .uploadProfilePic(() => loadingOverlay.show(context: context, message: app.strings.uploadingImage))
        .then((uploadedPhoto) {
      setState(() {
        uploadedImageFile = uploadedPhoto;
      });
      widget.onProfilePicChanged(uploadedPhoto);
      loadingOverlay.hide();
    }).catchError((e) {
      loadingOverlay.hide();
      DoItDialogs.showErrorDialog(context: context, message: '${app.strings.uploadPhotoErrMsg}${e.message}');
    });
  }

  Widget _userDetails() {
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
                  '${app.strings.displayName}: ${app.loggedInUser.displayName}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${app.strings.email}: ${userInfo == null ? "" : userInfo.email}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${app.strings.userID}: ',
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

  Future<void> _sendMessageToDevs(String message) async {
    assert(message != null || message.isNotEmpty);
    String response;
    Navigator.pop(context);
    await app.firestore
        .collection('userMessages')
        .add({
          'sender': UserUtils.generateObjectFromShortUserInfo(userInfo.getShortUserInfo()),
          'message': message,
          'sentTime': DateTime.now(),
        })
        .whenComplete(() => response = app.strings.msgSentToDevs)
        .catchError((error) => response = '${app.strings.sendMsgToDevsErr}${error.toString()}');

    if (!mounted) return;

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(response),
      duration: Duration(seconds: 2),
    ));
  }
}
