import 'package:flutter/material.dart';

class MyFormTextField extends StatelessWidget {
  Function(String) onSaved;
  InputDecoration decoration;
  Function(String) validator;
  final bool isObscure;
  final initVal;

  MyFormTextField(
      {this.isObscure, 
      this.initVal,
      this.decoration, 
      this.validator, 
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initVal,
      obscureText: isObscure,
      decoration: decoration,
      validator: validator,
      onSaved: onSaved,
    );
  }
}