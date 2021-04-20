import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready Resources App'),
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: Material(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(""),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Text(""),
              ),
            ])
          ],),
      )
    );
  }

}