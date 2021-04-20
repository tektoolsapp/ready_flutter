import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/screens/auth/PinCode.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  
  final PrimaryColor = const Color(0xFF27447E);
  
  Widget build(BuildContext context){
    return Drawer(      
        child: Consumer<Auth>(
        builder: (context, auth, child){
          
          //var loggedIn = auth.loggedIn;
          
          //print("AUTH: $loggedIn");
          
          if(auth.loggedIn){  
            return Container( 
              child: _buildMenu(context, auth)
            );
          } else {
            
            //print("AUTH: $loggedIn");
            
            return ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Login"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute (
                        builder: (context) => PinCodeVerificationScreen('')
                      )
                    );
                  },
                )
              ],
            );  
          }
        }
      ),
    );
  }

  //DRAW ITEMS WITH ICONS 
  //https://stackoverflow.com/questions/57888097/flutter-how-to-set-drawer-header-width-to-the-max
  
  Widget _buildMenu (context, auth){
      return ListView(
          children: <Widget>[
            Container(
              height: 70.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: PrimaryColor,
                ), 
                child: Text(
                  "Logged in as: " + auth.user.name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color : Colors.white
                  )
                ),
                //accountEmail: Text(auth.user.email),
              ),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  '/logged_out',              
                );
                Provider.of<Auth>(context, listen: false).signout(
                  success: (){
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('You are logged out'))
                    );
                  }
                );
              }
            ),
            ListTile(
              title: Text("Home"),
              onTap: () => _navigate(context, '/logged_in'),
            ),
            ListTile(
              title: Text("Current Swings"),
              onTap: () => _navigate(context, '/shifts'),
            ),
            /* ListTile(
              title: Text("Messages"),
              onTap: () => _navigate(context, '/messages'),
            ), */
            ListTile(
              title: Text("Messages"),
              onTap: () => _navigate(context, '/old_messages'),
            ),
            ListTile(
              title: Text("Test"),
              onTap: () => _navigate(context, '/test'),
            ),
            ListTile(
              title: Text("Error Handling"),
              onTap: () => _navigate(context, '/errors'),
            ),
            ListTile(
              title: Text("Photos"),
              onTap: () => _navigate(context, '/photos'),
            ),
            ListTile(
              title: Text("Travel Docs"),
              onTap: () => _navigate(context, '/travelDocs'),
            ),
            ListTile(
              title: Text("View PDF"),
              onTap: () => _navigate(context, '/viewPdf'),
            ),
            /* ListTile(
              title: Text("Contacts"),
              onTap: () => _navigate(context, '/contacts'),
            ),
            ListTile(
              title: Text("New Messages"),
              onTap: () => _navigate(context, '/new_messages'),
            ),
            ListTile(
              title: Text("Artices"),
              onTap: () => _navigate(context, '/news_articles'),
            ), */
          ] 
      );
    }

    void _navigate (context, String name){
        
        print("NAME: $name");

        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(name); 
    }
}