import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/messageCounter.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin<BottomNav> {
  
  final PrimaryColor = const Color(0xFF27447E);
  
  int _currentIndex = 0;

  //bool showStack = false;
  
  //https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation
  //https://medium.com/flutter/getting-to-the-bottom-of-navigation-in-flutter-b3e440b9386
 
  Widget build(BuildContext context){
  
    final counter = Provider.of<MessageCounter>(context, listen: false );

    if(counter.messageCounter > 0){
      setState(() => {
        counter.showStack = true
      });
    }

    int _bottomNavBarSelectedIndex = 0;
    //bool _newNotification = false;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 24.0,
            color: PrimaryColor,
          ),
          title: Text('Home'),
          //label: ,
        ),
        BottomNavigationBarItem(
          icon: counter.showStack
              ? Stack(
            children: <Widget>[
              Icon(
                Icons.notifications,
                size: 24.0,
                color: PrimaryColor,
              ),           
              Consumer<MessageCounter>(
                builder: (context, counter, child) {             
                  return Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        counter.messageCounter.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              )
            ],
          )
              : Icon(
                  Icons.notifications,
                  size: 24.0,
                  color: PrimaryColor,
                ),
          title: Text('Notifications'),
        ),
      ],
      currentIndex: _bottomNavBarSelectedIndex,
      selectedItemColor: PrimaryColor,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {   
    //print("TAPPED: $index");
    setState(() {
      _currentIndex = index;
      if (index == 0){
        Navigator.of(context).pushNamed(
          '/logged_in',              
        );
      } else if(index == 1){
        Navigator.of(context).pushNamed(
          '/new_messages',              
        );
      }
    });
  }

}