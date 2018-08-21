import 'dart:async';

import 'package:do_it/app.dart';
import 'package:do_it/authenticator.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DoItTextField(
                  controller: _emailController,
                  label: 'Email',
                  isRequired: true,
                  textInputType: TextInputType.emailAddress,
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
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
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
                        print("clicked register");
                        if (_formKey.currentState.validate()) {
                          print("register form is valid");
                          try {
                            await widget.auth.registerUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              displayName: _displayNameController.text,
                            );
                            Navigator.pop(context);
                            widget.onSignedIn();
                          } catch (e) {
                            _showErrorDialog(e.message);
                          }
                        } else {
                          print("register form is invalid");
                        }
                      },
                    );
                  }),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(title: Text('Oops...'), content: Text(message), actions: <Widget>[
            new SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ]);
        });
  }
}
