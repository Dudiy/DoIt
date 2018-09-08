import 'package:do_it/widgets/custom/imageContainer.dart';
import 'package:do_it/widgets/custom/imageFetcher.dart';
import 'package:do_it/widgets/nfc/lifecycle_nfc_watcher.dart';
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
  static const LOADING_GIF = 'assets/loading_anim_high.gif';
  static const DEFAULT_PICTURE = 'assets/images/unknown_profile_pic.jpg';
  String photoUrl = DEFAULT_PICTURE;

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
          leading: GestureDetector(
            onTap: () => App.instance.usersManager.uploadProfilePic().then((val) {
                  setState(() {
                    photoUrl = App.instance.loggedInUser.photoUrl;
                  });
                }),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(children: <Widget>[
//                ImageContainer(imagePath: photoUrl),
                Center(
                  child: Container(
                      width: 65.0,
                      height: 65.0,
                      child: ClipOval(
                        child: ImageFetcher.fetch(imagePath: photoUrl, defaultImagePath: DEFAULT_PICTURE),
                      )),
                ),
//                _addProfilePicture(),
                Container(child: LifecycleNfcWatcher()),
              ]),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UserSettingsPage(widget.onSignedOut)));
              },
            ),
          ],
        ),
        body: MyGroupsPage());
  }

  _addProfilePicture() {
    return photoUrl == DEFAULT_PICTURE
        ? Image.asset(DEFAULT_PICTURE)
        : FadeInImage.assetNetwork(
            placeholder: LOADING_GIF,
            image: photoUrl,
          );
  }
}
