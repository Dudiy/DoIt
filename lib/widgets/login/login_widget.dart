import 'package:do_it/app.dart';
import 'package:do_it/constants/asset_paths.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:do_it/widgets/login/register_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;

  LoginPage({this.onSignedIn});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
              Image.asset(LOGO_WITH_SHADOW, height: 100.0, width: 120.0),
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
            label: app.strings.email,
            textStyle: Theme.of(context).textTheme.body1,
          ),
          DoItTextField(
            controller: _passwordController,
            label: app.strings.password,
            isRequired: true,
            textStyle: Theme.of(context).textTheme.body1,
            obscureText: true,
          ),
          _drawLoginButton(),
          Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              GestureDetector(
                  child: Text(
                    app.strings.newUserButton,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => RegisterPage(onSignedIn: widget.onSignedIn)));
                  }),
              SizedBox(height: 15.0),
              GestureDetector(
                  child: Text(
                    app.strings.resetPassword,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: () {
                    TextEditingController _emailController = new TextEditingController();
                    DoItDialogs.showUserInputDialog(
                      context: context,
                      inputWidgets: [
                        DoItTextField(
                          label: app.strings.email,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: true,
                          maxLines: 1,
                        )
                      ],
                      title: app.strings.resetPassword,
                      onSubmit: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        loadingOverlay.show(context: context, message: app.strings.sendingResetPasswordMsg);
                        app.usersManager.getShortUserInfoByEmail(_emailController.text).then((userInfo) {
                          if (userInfo != null) {
                            app.authenticator.sendPasswordResetEmail(_emailController.text);
                            loadingOverlay.hide();
                            Navigator.pop(context);
                            DoItDialogs.showNotificationDialog(
                              context: context,
                              title: app.strings.resetPassword,
                              body: '${app.strings.resetPasswordSentMsg} ${_emailController.text}',
                            );
                          } else {
                            loadingOverlay.hide();
                            DoItDialogs.showErrorDialog(
                                context: context, message: app.strings.noRegisteredUserWithEmailMsg);
                          }
                        });
                      },
                    );
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
          app.strings.loginButtonText,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            FocusScope.of(context).requestFocus(new FocusNode());
            loadingOverlay.show(context: context, message: app.strings.loggingIn);
            app.authenticator.signInWithEmailAndPassword(_emailController.text, _passwordController.text).then((user) {
              loadingOverlay.hide();
              app.refreshLoggedInUserFcmToken();

              print('${user.displayName} has logged in using email and password');
              widget.onSignedIn();
            }).catchError((error) {
              loadingOverlay.hide();
              DoItDialogs.showErrorDialog(
                context: context,
                message: '${app.strings.loginErrMsg} \n${error.message}',
              );
              print('Error while trying to log in: \n${error.message}');
            });
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
          Image.asset(
            GOOGLE_ICON,
            width: 18.0,
          ),
          SizedBox(width: 15.0),
          Text(app.strings.loginWithGoogle),
        ],
      ),
      color: Colors.white,
      onPressed: () {
        loadingOverlay.show(context: context, message: app.strings.loggingInWithGoogle);
        app.authenticator.signInWithGoogle().then((signedInUser) {
          loadingOverlay.hide();
          if (signedInUser != null) {
            widget.onSignedIn();
          }
        }).catchError((e) {
          print('${app.strings.loginWithGoogleErrMsg} \n${e.message}');
          loadingOverlay.hide();
        });
      },
    );
  }
}
