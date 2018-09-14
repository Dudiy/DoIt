import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
import 'package:do_it/widgets/custom/dialog_generator.dart';
import 'package:do_it/widgets/custom/loadingOverlay.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  final Authenticator auth = App.instance.authenticator;

  RegisterPage({@required this.onSignedIn});

  @override
  RegisterPageState createState() {
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LoadingOverlay loadingOverlay = new LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Register"),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15.0),
                DoItTextField(
                  controller: _emailController,
                  label: 'Email',
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                DoItTextField(
                  controller: _displayNameController,
                  label: 'Name',
                  isRequired: true,
                ),
                DoItTextField(
                  controller: _passwordController,
                  label: 'Password',
                  isRequired: true,
                  fieldValidator: (String value) => value.length >= 6,
                  validationErrorMsg: 'Password must be at least 6 characters long',
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          loadingOverlay.show(context: context, message: "Registering new user...");
                          await widget.auth.registerUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            displayName: _displayNameController.text,
                          );
                          loadingOverlay.hide();
                          Navigator.pop(context);
                          widget.onSignedIn();
                        } catch (e) {
                          loadingOverlay.hide();
                          DoItDialogs.showErrorDialog(context: context, message: e.message);
                        }
                      } else {
                        print("register form is invalid");
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
