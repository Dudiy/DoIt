import 'package:do_it/app.dart';
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
  String photoUrl="";

  @override
  Widget build(BuildContext context) {
    photoUrl = App.instance.loggedInUser?.photoUrl ?? "";
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
              child: Center(
                child: FadeInImage.assetNetwork(
                  placeholder: LOADING_GIF,
                  image: photoUrl,
                ),
              ),
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
}
