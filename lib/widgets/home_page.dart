import 'package:do_it/app.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/groups/my_groups_widget.dart';
import 'package:do_it/widgets/users/user_settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignedOut;
  final App app = App.instance;

  HomePage({this.onSignedOut});

  void _signOut() async {
    try {
      onSignedOut();
    } catch (e) {
      print('Error while trying to sign out: \n${e.message}');
    }
  }

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static const LOADING_GIF = 'assets/images/loading_profile_pic.png';
  static const DEFAULT_PICTURE = 'assets/images/unknown_profile_pic.png';
  String photoUrl = DEFAULT_PICTURE;

  @override
  void initState() {
    super.initState();
    App.instance.firebaseMessaging.configure(
      // when app is closed
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch message:');
      },
      // when app is running
      onMessage: (Map<String, dynamic> message) {
        DoItDialogs.showNotificationDialog(
          context: context,
          title: message['title'],
          body: message['body'],
        );
        print('onMessage message:');
      },
      // when app is minimised
      onResume: (Map<String, dynamic> message) {
        print('onResume message:');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (App.instance.loggedInUser?.photoUrl != null && App.instance.loggedInUser?.photoUrl != "") {
      photoUrl = App.instance.loggedInUser?.photoUrl;
    }else{
      photoUrl = DEFAULT_PICTURE;
    }

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => App.instance.usersManager.uploadProfilePic().then((val) {
                  setState(() {
                    photoUrl = App.instance.loggedInUser.photoUrl;
                  });
                }),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: _addProfilePicture(),
            ),
          ),
          title: Text("DoIt"),
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: widget._signOut,
            ),
            FlatButton(
                child: Icon(Icons.mood, color: Colors.white),
                onPressed: () {
//                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestPage()));
                  DoItDialogs.showNotificationDialog(context: context, title: 'test', body: 'hello');
                  App.instance.test();
                }),
            FlatButton(
              child: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator
                    .of(context)
                    .push(MaterialPageRoute(builder: (context) => UserSettingsPage(widget.onSignedOut)));
              },
            ),
          ],
        ),
        body: MyGroupsPage());
  }

  _addProfilePicture() {
    return photoUrl == DEFAULT_PICTURE
        ? DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
            image: AssetImage(DEFAULT_PICTURE),
          )))
        : Center(
            child: FadeInImage.assetNetwork(
              placeholder: LOADING_GIF,
              image: photoUrl,
            ),
          );
  }
}
