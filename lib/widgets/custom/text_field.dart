import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoItTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final maxLength;
  final bool isRequired;
  final bool enabled;
  final int maxLines;
  final TextAlign textAlign;
  final String initValue;
  final Function fieldValidator;
  final String validationErrorMsg;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  DoItTextField({
    @required this.label,
    this.padding = const EdgeInsets.all(8.0),
    this.controller,
    this.maxLength,
    this.maxLines,
    this.initValue,
    this.textStyle,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.isRequired = false,
    this.enabled = true,
    this.fieldValidator,
    this.validationErrorMsg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        style: textStyle,
        textAlign: textAlign,
        keyboardType: keyboardType,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        initialValue: initValue,
        obscureText: label.contains('Password') || label.contains('password'),
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          labelStyle: TextStyle(height: 1.5),
          filled: true,
          fillColor: Colors.white70,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        validator: (value) {
          if (isRequired && value.isEmpty) return 'This field cannot be empty';
          if (keyboardType == TextInputType.emailAddress) {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(value)) return 'Invalid email address';
          }
          if (fieldValidator != null && !fieldValidator(value)) {
            return validationErrorMsg;
          }
        },
      ),
    );
  }
}
