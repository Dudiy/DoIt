import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/login/register_widget.dart';
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
  final App app = App.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: 40.0),
              Image.asset('assets/logo_with_shadow.png', height: 100.0, width: 120.0),
              _drawLoginForm(),
              Divider(color: Colors.black),
              _drawSignInServices(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DoItTextField(
            isRequired: true,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            label: 'Email',
            textStyle: Theme.of(context).textTheme.body1,
          ),
          DoItTextField(
            controller: _passwordController,
            label: 'Password',
            isRequired: true,
            textStyle: Theme.of(context).textTheme.body1,
          ),
          _drawLoginButton(),
          Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              GestureDetector(
                  child: Text(
                    "New user?  Create an account",
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
//                Navigator.pushNamed(context, '/Register');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => RegisterPage(onSignedIn: widget.onSignedIn)));
                  }),
              SizedBox(height: 15.0),
              GestureDetector(
                  child: Text(
                    "Reset password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    TextEditingController _emailController = new TextEditingController();
                    DoItDialogs.showUserInputDialog(
                      context: context,
                      inputWidgets: [
                        DoItTextField(
                          label: "Email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          maxLines: 1,
                        )
                      ],
                      title: 'Reset password',
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        loadingOverlay.show(context: context, message: "sending reset password mail...");
                        app.usersManager.getShortUserInfoByEmail(_emailController.text).then((userInfo) {
                          if (userInfo != null) {
                            app.authenticator.sendPasswordResetEmail(_emailController.text);
                            loadingOverlay.hide();
                            Navigator.pop(context);
                            DoItDialogs.showNotificationDialog(
                              context: context,
                              title: "Reset password",
                              body: "Reset password email has been sent to ${_emailController.text}",
                            );
                          } else {
                            loadingOverlay.hide();
                            DoItDialogs.showErrorDialog(
                                context: context, message: "There is no registered user with the givan Email address");
                          }
                        });
                      },
                    );
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawLoginButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: app.themeData.primaryColor,
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
            FocusScope.of(context).requestFocus(new FocusNode());
            loadingOverlay.show(context: context, message: "Logging in...");
            try {
              widget.authenticator
                  .signInWithEmailAndPassword(_emailController.text, _passwordController.text)
                  .then((user) {
                loadingOverlay.hide();
                App.instance.refreshLoggedInUserFcmToken();

                print('${user.displayName} has logged in using email and password');
                widget.onSignedIn();
              }).catchError((error) {
                loadingOverlay.hide();
                DoItDialogs.showErrorDialog(
                  context: context,
                  message: 'Error while trying to log in: \n${error.message}',
                );
                print('Error while trying to log in: \n${error.message}');
              });
            } catch (error) {
              loadingOverlay.hide();
              DoItDialogs.showErrorDialog(
                context: context,
                message: 'Error while trying to log in: \n${error.message}',
              );
              print('Error while trying to log in: \n${error.message}');
            }
          }
        },
      ),
    );
  }

  Widget _drawSignInServices() {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'assets/icons_and_buttons/google_icon.png',
              width: 18.0,
            ),
          ),
          Text('Log in with google'),
        ],
      ),
      color: Colors.white,
      onPressed: () {
        loadingOverlay.show(context: context, message: "Logging in with google...");
        widget.authenticator.signInWithGoogle().then((signedInUser) {
          loadingOverlay.hide();
          if (signedInUser != null) {
            widget.onSignedIn();
          }
        }).catchError((e) {
          print('Error while trying to log in with google: \n${e.message}');
          loadingOverlay.hide();
        });
      },
    );
  }
}
