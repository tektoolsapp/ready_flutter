import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';

class HomeScreen extends StatelessWidget{
  @override
  
  //final myPath = env['FOO'];

  Widget build(BuildContext context){
    
    //print("FOO $myPath");
    
    return Scaffold (
      appBar: AppBar(
         title: Text("Ready Resources") 
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Home Page",
              style: Theme.of(context).textTheme.headline5
          ),
          
          ]
        ),
        
      )
    );
  }
}