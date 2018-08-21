import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:do_it/app.dart';
import 'package:do_it/data_classes/group/group_info_short.dart';
import 'package:do_it/widgets/my_groups_widget.dart';
import 'package:do_it/widgets/test_page.dart';
import 'package:do_it/widgets/user_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<ShortGroupInfo> _myGroups;
  AssetImage defaultImage = AssetImage('assets/images/loading_profile_pic.png');
  String photoUrl = App.instance.loggedInUser?.photoUrl ?? "";

  @override
  Widget build(BuildContext context) {
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
              child: Stack(
                children: <Widget>[
                  _getDefaultProfile(),
                  _getProfilePicFromDB(),
                ],
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
              }
            ),
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

  _getProfilePicFromDB() {
    Widget renderedWidget;
    try {
      renderedWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(style: BorderStyle.solid, color: Colors.lightBlueAccent),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(photoUrl, scale: 0.1, errorListener: () {
              // TODO does not hide the error message from the console
              setState(() {
                defaultImage = AssetImage('assets/images/unknown_profile_pic.png');
              });
            }),
          ),
        ),
      );
    } catch (e) {
      renderedWidget = Container();
    }
    return renderedWidget;
  }

  _getDefaultProfile() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(style: BorderStyle.solid, color: Colors.lightBlueAccent),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: defaultImage,
        ),
      ),
    );
  }
}
