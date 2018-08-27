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

  DoItTextField({
    @required this.label,
    this.controller,
    this.maxLength,
    this.maxLines,
    this.initValue,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        validator: (value) {
          if (isRequired && value.isEmpty) return 'This field cannot be empty';
        },
      ),
    );
  }
}
