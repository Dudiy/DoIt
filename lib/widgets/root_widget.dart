import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/widgets/custom/dialog.dart';
import 'package:do_it/widgets/home_page.dart';
import 'package:do_it/widgets/login/login_widget.dart';
import 'package:flutter/material.dart';

enum eAuthenticationStatus { SIGNED_IN, NOT_SIGNED_IN }

class RootPage extends StatefulWidget {
  final Authenticator authenticator = App.instance.authenticator;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  eAuthenticationStatus authStatus = eAuthenticationStatus.NOT_SIGNED_IN;

  @override
  void initState() {
    super.initState();
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
      case eAuthenticationStatus.NOT_SIGNED_IN:
        widgetToReturn = LoginPage(onSignedIn: _signedIn);
        break;
      case eAuthenticationStatus.SIGNED_IN:
        widgetToReturn = HomePage(
          onSignedOut: _signedOut,
        );
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
