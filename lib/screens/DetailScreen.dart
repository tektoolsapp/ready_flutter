import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/models/Todo.dart';

class DetailScreen extends StatefulWidget {
  
  final Todo todo;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.todo}) : super(key: key);
  
  @override
  DetailScreenState createState() => new DetailScreenState(todo);
}

class DetailScreenState extends State<DetailScreen> {

  final todo;

  DetailScreenState(this.todo);
 
  @override
  void initState() {
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO LIST: ${todo.id}"),
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: Material(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(todo.title),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Text(todo.description),
              ),
            ])
          ],),
      )
    );
  }

}