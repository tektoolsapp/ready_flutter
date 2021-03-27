//import 'dart:html';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Message.dart';
import 'package:flutter_ready_prod/models/messageCounter.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  @override 
  _MessagesScreenState createState() => _MessagesScreenState(); 
}

class _MessagesScreenState extends State<MessagesScreen> {

  String _homeScreenText = "Waiting for token...";
  // ignore: unused_field
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final storage = new FlutterSecureStorage();
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  String _newMessageStatus;
  String _selectedIndex = "";
  String _currentMessage = 'empty';
  String _thisIndex = 'empty';

  /* @override
  void initState() {
    super.initState();
  } */

  @override
  void initState() {
    super.initState();
    
    //_populateMessages();
    
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushX Messaging message: $message";
        });
        print("MESSAGE REC: $message");
        _increment();
        //_populateMessages();
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushY Messaging message: $message";
        });
        print("LAUNCH MESSAGE REC: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushZ Messaging message: $message";
        });
        print("RESUME MESSAGE REC: $message");
        _increment();
        //_populateMessages();
        
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      //print(_homeScreenText);
    });
  }

  void _increment() async {
    String numMessages = await storage.read(key: 'numMessages');    
    print("STORED PRE INCREMENT: $numMessages");
    Provider.of<MessageCounter>(context, listen: false).increment(numMessages);  
  }

  void _decrement() async {
    String numMessages = await storage.read(key: 'numMessages');    
    print("STORED PRE DECREMENT: $numMessages");
    Provider.of<MessageCounter>(context, listen: false).decrement(numMessages);  
  }
  
  Future<void> _deleteMessage(message) async {

    var deleteId = message.id;
    print("DELETE: $deleteId"); 

    _newMessageStatus = await storage.read(key: "new_status");

    Provider.of<Message>(context, listen:false).deleteMessage(
      data: {
        'message_id': message.id,
        'message_status': _newMessageStatus,
      },
      success: (){
        //Navigator.of(context).pop();
        //Navigator.pop(context);

        /* scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Good to go!")
            //duration: Duration(seconds: 2),
          )); */
        print("SUCCESS");

        _decrement();

        setState(() {
          //_color = Color(0xFFFF8A65);
          _currentMessage = message.id;
          _thisIndex = 'empty';
        });

      },
      error: (){
        print("ERROR");
        /* scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Error, Try again!")
            //duration: Duration(seconds: 2),
          )); */
          /* Scaffold.of(context)
                .showSnackBar(SnackBar(
                  content: Text("Errors"),
                  duration: Duration(seconds: 1),
                )
                ); */
      }
    ); 

  }

  Future<void> _updateMessage(message) async {

    var deleteId = message.id;
    print("DELETE: $deleteId"); 

    _newMessageStatus = await storage.read(key: "new_status");

    Provider.of<Message>(context, listen:false).deleteMessage(
      data: {
        'message_id': message.id,
        'message_status': _newMessageStatus,
      },
      success: (){
        //Navigator.of(context).pop();
        //Navigator.pop(context);

        /* scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Good to go!")
            //duration: Duration(seconds: 2),
          )); */
        print("UPDATED");

        //_decrement();

        setState(() {
          //_color = Color(0xFFFF8A65);
          _currentMessage = message.id;
          _thisIndex = 'empty';
        });

      },
      error: (){
        print("ERROR");
        /* scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Error, Try again!")
            //duration: Duration(seconds: 2),
          )); */
          /* Scaffold.of(context)
                .showSnackBar(SnackBar(
                  content: Text("Errors"),
                  duration: Duration(seconds: 1),
                )
                ); */
      }
    ); 

  }

  //_storeMessages(messages) async {
  
  //Future<void> _storeMessages(numMessages) async {
  
  void _storeMessages(numMessages) async {
    
    String numMessages = await storage.read(key: 'numMessages');    
    
    //numMessages = int.tryParse(numMessages);
    
    print("STORE FETCHED MESSAGES: $numMessages");
    
    Provider.of<MessageCounter>(context, listen: false).storeMessages(numMessages.toString());  

    //final counter = Provider.of<MessageCounter>(context, listen: false ); 
 
  }

  @override
  Widget build(BuildContext context) {
    
    // ignore: unused_local_variable
    //final auth = Provider.of<Auth>(context, listen:false);

    //var authID = auth.user.id; 

    //print("AUTH ID $authID");

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
              
              //future: Webservice().load(Message.getMessages(auth.user.id.toString())),
              future: Webservice().load(Message.getMessages(auth.loginUserId.toString())),
                
                builder: (context, snapshot) {
                  
                  if(snapshot.hasError) {
                    return WebserviceFail();
                  }
                  if(snapshot.hasData) {
                    
                    var numMessages = snapshot.data.length;
                    
                    //_storeMessages(numMessages.toString());
                    
                    //var numMessages = snapshot.data.length;
                    
                    print("NUM MESS BUILDER: $numMessages");
                    
                    if(numMessages > 0){
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          //if(index == 0){
                            //updateMessages(snapshot.data.length);
                          //}
                          return _buildShift(snapshot.data[index], context, index);
                        }
                      );
                    } else {
                       return Container(
                          margin: new EdgeInsets.all(20.0),
                          color: Colors.transparent,
                          //height: 200,
                          //width: 200,
                          alignment: Alignment(0.0, 0.0),
                          child: Text(
                            "You have no messages",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold 
                              )
                          )
                        );
                    }
                  }
                  return Loading();
                }
              );  
            }
          )
      );
    }

    Widget _buildShift (Message message, context, index){   
      
      bool nowSelected = _thisIndex == message.id;
      bool isSelected = _selectedIndex == _currentMessage;

      var messageId = message.id;
      var messageStatus = message.status;
          
      print("---INDEX: $index -- $messageId -- $messageStatus -- SI: $_selectedIndex -- SEL: $nowSelected -- SEL: $isSelected");
      
      declareVariable() {
        
        if (messageStatus == 'P'){
            
          if(isSelected == true ){
              //SET WHITE
              var tileColor = Color(0xFFFFAB91);
              return tileColor;     
          
          } else if (isSelected == false && nowSelected == true ){
              //SET WHITE
              var tileColor = Color(0xFFFFFFFF);
              return tileColor;
          
          } else {
              //SET WHITE
              var tileColor = Color(0xFFFFFFFF);
              return tileColor;
          }    
        
        } else if (messageStatus == 'R'){
          
          if(isSelected == true ){
              //SET ORANGE
              //var tileColor = const Color(0xFF27447E);
              var tileColor = Color(0xFFFFFFFF);
              return tileColor;
          
          } else if (isSelected == false && nowSelected == true ){
              //SET GREY
              var tileColor = Color(0xFFCFD8DC);
              return tileColor;
          
          } else {
              //SET ORANGE
              var tileColor = Color(0xFFFFAB91);
              return tileColor;
          }

        } 
               
      }
      
      print(declareVariable());
      
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await storage.write(key: "new_status", value: 'X');
            _deleteMessage(message);
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
            //color: message.status == 'R' || isSelected && _revertSelection == false ? Colors.blue[300].withOpacity(0.8) : Colors.grey[700],
            color: declareVariable(),
            margin: EdgeInsets.all(10), 
            child:  ListTile(
              isThreeLine: true,
              title: Text(message.title + " - " + message.sent),
              subtitle: Text(message.body), 
              trailing: Icon(Icons.more_vert),
              dense: false,           
              onLongPress: (){
                
              final snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Long Press'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () async {
                      
                      //
                    
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              
              },
              onTap: () async {
                
                setState(() {
                  _thisIndex = message.id;
                });
                
                if(message.status == 'P') {
                  await storage.write(key: "new_status", value: 'R');
                  await _updateMessage(message);

                  
                } else if (message.status == 'R') {

                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Currently Marked as Read'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () async {
                        
                        print("R SEL INDEX: $_selectedIndex");
                        
                        setState(() {
                          _thisIndex = message.id;
                        });

                        await storage.write(key: "new_status", value: 'P');
                        await _updateMessage(message);
                      },
                    ),
                  );
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);  
                }
              }
              
            )
          )
      );
    }
  
    updateMessages(length){
      print("UPDATE $length");
    }
}