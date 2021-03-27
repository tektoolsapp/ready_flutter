import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final Function() onPressed;
  FormSubmitButton({this.onPressed});

  final buttonColor = const Color(0xFF27447E);
  final buttonText = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: RaisedButton(
          onPressed: onPressed,
          color: buttonColor,
          child: Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25 
              )
          )
        ),
        width: double.infinity,
        height: 60
      );  
  }
}