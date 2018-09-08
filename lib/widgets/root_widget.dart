import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/private.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/home_page.dart';
import 'package:do_it/widgets/loadingPage.dart';
import 'package:do_it/widgets/login/login_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum eAuthenticationStatus { SIGNED_IN, NOT_SIGNED_IN, NOT_INITIALIZED }

class RootPage extends StatefulWidget {
  final Authenticator authenticator = App.instance.authenticator;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  eAuthenticationStatus authStatus = eAuthenticationStatus.NOT_INITIALIZED;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'test',
      options: const FirebaseOptions(
        googleAppID: Private.googleAppID,
        apiKey: Private.apiKey,
        projectID: 'doit-grouptaskmanager',
      ),
    );
    await App.instance.init(app);
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
    widget.authenticator.getCurrentUser().then((user) {
      setState(() {
        authStatus = user == null ? eAuthenticationStatus.NOT_SIGNED_IN : eAuthenticationStatus.SIGNED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget widgetToReturn;
    switch (authStatus) {
      case eAuthenticationStatus.NOT_INITIALIZED:
        widgetToReturn = LoadingPage();
        break;
      case eAuthenticationStatus.NOT_SIGNED_IN:
        widgetToReturn = LoginPage(onSignedIn: _signedIn);
//        widgetToReturn = LoadingPage();
        break;
      case eAuthenticationStatus.SIGNED_IN:
        widgetToReturn = HomePage(onSignedOut: _signedOut);
        break;
    }
    return widgetToReturn;
  }

  void _signedIn() {
    setState(() {
      authStatus = eAuthenticationStatus.SIGNED_IN;
    });
  }

  Future _signedOut() async {
    App.instance.authenticator.signOut();
    await App.instance.setLoggedInUser(null);
    setState(() {
      authStatus = eAuthenticationStatus.NOT_SIGNED_IN;
    });
  }
}
