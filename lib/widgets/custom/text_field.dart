import 'package:flutter/material.dart';

class DoItTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType textInputType;
  final maxLength;
  final bool isRequired;
  final bool enabled;

  DoItTextField({
    @required this.label,
    this.controller,
    this.textInputType,
    this.maxLength,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
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
