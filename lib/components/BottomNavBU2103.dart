import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/messageCounter.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_ready_app/auth/Auth.dart';
//import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin<BottomNav> {
  
  int _currentIndex = 0;
  
  //https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation
  //https://medium.com/flutter/getting-to-the-bottom-of-navigation-in-flutter-b3e440b9386
 
  Widget build(BuildContext context){
    
    final messageCounter = Provider.of<MessageCounter>(context);
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Notifications'),
          icon: Icon(Icons.notifications),
        )
      ]
    );
  }

  void _onItemTapped(int index) {   
    //print("TAPPED: $index");
    setState(() {
      _currentIndex = index;
      if (index == 0){
        Navigator.of(context).pushNamed(
          '/',              
        );
      }
    });
  }

}