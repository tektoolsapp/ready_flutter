import 'package:flutter/material.dart';

class WebserviceFail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Failed to load')
        ],
      ),
    );
  }
}