import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Message.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  @override 
  _MessagesScreenState createState() => _MessagesScreenState(); 
}

class _MessagesScreenState extends State<MessagesScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //String selected = "";

  int tappedIndex;

  @override
  void initState() {
    super.initState();
    //isSelected = null;
  }

  //
  @override
  Widget build(BuildContext context) {
    
    // ignore: unused_local_variable
    final auth = Provider.of<Auth>(context, listen:false);
    //final message = Provider.of<Message>(context, listen:false);

    return Scaffold (
        appBar: AppBar(
          title: Text('Messages')
        ),
        drawer: AppDrawer().build(context),
        bottomNavigationBar: BottomNav(),
        body: 
        Consumer<Auth>(
          builder: (context, auth, child) {
            return FutureBuilder(
              future: Webservice().load(Message.fromMessages(auth.user.id.toString())),
                builder: (context, snapshot) {
                  
                  if(snapshot.hasError) {
                    return WebserviceFail();
                  }
                  if(snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        if(index == 0){
                          updateMessages(snapshot.data.length);
                        }
                        return _buildShift(snapshot.data[index], context, index);
                      }
                    );
                  }
                  return Loading();
                }
              );  
            }
          )
      );
    }

    Widget _buildShift (Message message, context, index){   
      
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            //await deleteFromDataBase(index);
            //var thisKey = UniqueKey();
            
            print("DELETE $index");
          }
        },
        background: Container(
          color: Colors.red,
          margin: EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.startToEnd,
          child: Card(
            //color: Colors.blue,
            //color:  tappedIndex == index ? Colors.blue : Colors.grey, 
            //color: message.isSelected == true ? Colors.amber : Colors.white,
            color: message.status == 'P' ? Colors.amber: Colors.white,
            margin: EdgeInsets.all(10), 
            child:  ListTile(
                title: Text(message.body
              ),
              onTap: () {
                setState(() {
                  message.isSelected = true;
                });
                
                final snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Marked as Read'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              //child: Text('Show SnackBar'),
              
              
              
              /* Navigator.of(context).pushNamed(
                '/shiftMessageDetails',
                arguments: message 
              ); */
              /* Scaffold.of(context)
                .showSnackBar(SnackBar(
                  content: Text("Marked as Read"),
                  duration: Duration(seconds: 1),
                )
              ); */
            //},
            )
          )
      
        /*child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(message.body),
          color: Colors.blue,
          margin: EdgeInsets.all(5.0),
        ) */
      );

      /* return Column (
        children: <Widget> [
          Ink(
          color: message.status == 'P' ? Colors.lightGreen : Colors.transparent,  
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              message.title,
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              message.body
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/shiftMessageDetails',
                arguments: message 
              );
            },
            ),
          ),
          Container(
            decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blueGrey[100]),
            ),
            ),
          )
        ],
      ); */
    }
  
    updateMessages(length){
      print("UPDATE $length");
    }


  // 
}