import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';

class LoggedOutScreen extends StatefulWidget {
  @override
  LoggedOutScreenState createState() => new LoggedOutScreenState();
}

class LoggedOutScreenState extends State<LoggedOutScreen> {
  @override
  void initState() {
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged Out'),
      ),
      drawer: AppDrawer().build(context),
      //bottomNavigationBar: BottomNav(),
      body: Material(
        child: Column(
          children: <Widget>[
            Center(
              child: Text("_homeScreenText"),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Text("_messageText"),
              ),
            ])
          ],),
      )
    );
  }

}