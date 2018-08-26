import 'package:do_it/app.dart';
import 'package:do_it/widgets/custom/text_field.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  ResetPasswordPageState createState() {
    return new ResetPasswordPageState();
  }
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Reset password"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DoItTextField(
                      controller: _emailController,
                      label: 'Email',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                )),
            FlatButton(
                child: Text("Reset password"),
                onPressed: () {
                  App.instance.authenticator.sendPasswordResetEmail(_emailController.text);
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
