import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/login/register_widget.dart';
import 'package:do_it/widgets/login/reset_password_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Firestore firestore = App.instance.firestore;
  final Authenticator authenticator = App.instance.authenticator;
  final VoidCallback onSignedIn;

  LoginPage({this.onSignedIn});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
//  CollectionReference get users => widget.firestore.collection('users');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LoadingOverlay loadingOverlay = new LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: <Widget>[
              _drawLogo(context),
              SizedBox(height: 20.0),
              _drawLoginForm(),
              SizedBox(height: 20.0),
              Divider(color: Colors.black),
              _drawSignInServices(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawLogo(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 40.0),
        Column(
          children: <Widget>[
//                Image.asset('assets/diamond.png'), //TODO placeholder for logo
            SizedBox(height: 16.0),
            Text(
              'DoIt',
              style: Theme.of(context).textTheme.headline,
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ],
    );
  }

  Widget _drawLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DoItTextField(
            isRequired: true,
            controller: _emailController,
            label: 'Email',
          ),
          SizedBox(height: 12.0),
          DoItTextField(
            controller: _passwordController,
            label: 'Password',
            isRequired: true,
          ),
          _drawLoginButton(),
          FlatButton(
              child: Text("New user?  Create an account"),
              onPressed: () {
//                Navigator.pushNamed(context, '/Register');
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => RegisterPage(onSignedIn: widget.onSignedIn)));
              }),
          FlatButton(
              child: Text("Reset password"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage()));
              }),
        ],
      ),
    );
  }

  Widget _drawLoginButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        color: Theme.of(context).primaryColor,
        child: Text(
          'LOGIN',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            loadingOverlay.show(context: context, message: "Logging in...");
            widget.authenticator
                .signInWithEmailAndPassword(_emailController.text, _passwordController.text)
                .then((user) {
              loadingOverlay.hide();
              App.instance.refreshLoggedInUserFcmToken();
              print('${user.displayName} has logged in using email and password');
              widget.onSignedIn();
            }).catchError((error) {
              final snackbar = SnackBar(
                content: Text('Error while trying to log in: \n ${error.message}'),
              );
              scaffoldKey.currentState.showSnackBar(snackbar);
              print(error);
            });
          }
        },
      ),
    );
  }

  Widget _drawSignInServices() {
    return RaisedButton(
      child: Text('log in with google'),
      onPressed: () {
        loadingOverlay.show(context: context, message: "Logging in with google...");
        widget.authenticator.signInWithGoogle().then((signedInUser) {
          loadingOverlay.hide();
          if (signedInUser != null) {
            widget.onSignedIn();
          }
        }).catchError((e) {
          print('Error while trying to log in with google: \n${e.message}');
        });
      },
    );
  }
}
