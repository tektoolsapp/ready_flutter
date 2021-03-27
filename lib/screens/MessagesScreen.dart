//import 'dart:html';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
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
  bool isSelected = false;

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

    archiveItem(){
      print("archive");

    }

    Future<bool> promptUser(DismissDirection direction) async {
      String action;
      if (direction == DismissDirection.startToEnd) {
        // This is a delete action
        action = "Delete";
      } else {
        archiveItem();
        // This is an archive action
        action = "ASrchive";
      }

      return await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: Text("Are you sure you want to $action?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Ok"),
              onPressed: () {
                // Dismiss the dialog and
                // also dismiss the swiped item
                Navigator.of(context).pop(true);
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                // Dismiss the dialog but don't
                // dismiss the swiped item
                return Navigator.of(context).pop(false);
              },
            )
          ],
        ),
      ) ??
      false; // In case the user dismisses the dialog by clicking away from it
}

    void messageReadOptions(message){
    
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(   
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Mark As Read'),
              onPressed: () async {
                //print("MARK AS READ ${message.id}");
                await storage.write(key: "new_status", value: 'R');
                //print("GET READ STATUS $_readStatus");
                print("MARKING AS READ");
                _updateMessage(message);
                Navigator.pop(context);
                /* setState(() => {
                  _readStatus = 'R'           
                }); */
                setState(() {
                  _thisIndex = message.id;
                });
                //print("SET READ STATUS $_readStatus");
              },
            ),  
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel"),
            onPressed: () => {
              setState(() {
                _thisIndex = "";
              }),
              Navigator.pop(context)
            },
          ) 
        ),
      );
    }

    void messageUnReadOptions(message){
      
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Mark As Un-Read'),
              onPressed: () async {
                //print("MARK AS UN-READ ${message.id}");
                await storage.write(key: "new_status", value: 'P');
                print("MARKING AS UN-READ");
                _updateMessage(message);
                Navigator.pop(context);
                /* setState(() => {
                  _readStatus = 'P'
                }); */
                setState(() {
                  _thisIndex = message.id;
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text("Cancel"),
            onPressed: () => {
              setState(() {
                _thisIndex = "";
              }),
              Navigator.pop(context)
            },
          ) 
        ),
      );
    }

    Widget _buildShift (Message message, context, index){   
      
      bool nowSelected = _thisIndex == message.id;
      //bool isSelected = _selectedIndex == _currentMessage;

      var messageId = message.id;
      var messageStatus = message.status;
          
      print("INDEX: $index");
      print("THIS INDEX: $_thisIndex");
      print("MSG ID: $messageId"); 
      print("STATUS $messageStatus"); 
      print("SEL IND: $_selectedIndex"); 
      print("NOW SEL: $nowSelected"); 
      print("IS SEL: $isSelected");
      print("CURR MSG: $_currentMessage");
      
      declareVariable() {
        
        if (messageStatus == 'P'){
            
          print("HERE IN P");
          
          if(isSelected == true && nowSelected == true){
              //SET WHITE
              
              print("P OPTION 1"); 
              
              //var tileColor = Color(0xFFFFAB91);
              //var tileColor = Color(0xFFFFFFFF);
              var tileColor = Color(0xFFFFEB3B);
              return tileColor;  

          } else if (isSelected == false && nowSelected == true ){
              //SET WHITE
              
              print("P OPTION 2"); 
              
              var tileColor = Color(0xFFFFFFFF);
              return tileColor;
          
          } else {
              //SET WHITE
              
              print("P OPTION 3"); 
              
              var tileColor = Color(0xFFFFFFFF);
              //var tileColor = Color(0xFFFF4081);
              return tileColor;
          }    
        
        } else if (messageStatus == 'R'){
          
          print("HERE IN R");
          
          if(isSelected == true && nowSelected == true){
              //SET ORANGE
              //var tileColor = const Color(0xFF27447E);
              
              print("R OPTION 1"); 
              var tileColor = Color(0xFFFFEB3B);
              //var tileColor = Color(0xFFFFFFFF);
              return tileColor;
          
          } else if (isSelected == false && nowSelected == true ){
              //SET GREY
              
              print("R OPTION 2"); 

              var tileColor = Color(0xFFCFD8DC);
              return tileColor;
          
          } else {
              //SET ORANGE
              
              print("R OPTION 3"); 
              
              var tileColor = Color(0xFFFFAB91);
              return tileColor;
          }

        } 
               
      }
      
      //print(declareVariable());

        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              //if(message.status == 'P') {
                await storage.write(key: "new_status", value: 'X');
                print("DELETING IN CARD");
                //onDelete();
                _deleteMessage(message);
              //}
            }
          },
          confirmDismiss: (direction) => promptUser(direction),
          background: Container(
            color: Colors.red,
            margin: EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.startToEnd,
            child:
              GestureDetector(
                
                onTap: () async {
                
                  setState(() {
                     isSelected = true;
                    _thisIndex = message.id;
                  });

                  print("CLICKED INDEX STATE: $_thisIndex");
                  
                  if(messageStatus == 'P') {
                    
                    print("CLICKED STATUS P: $messageStatus");
                    
                    //await storage.write(key: "new_status", value: 'R');
                    //await _updateMessage(message);
                    messageReadOptions(message);

                  } else if (messageStatus == 'R') {

                    print("CLICKED STATUS R: $messageStatus");
                    
                    //print("R SEL INDEX: $_selectedIndex");
                          
                    /* setState(() {
                      _thisIndex = message.id;
                    }); */

                    messageUnReadOptions(message);

                  }
                      
                      
                      /* final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Currently Marked as Read'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            
                            print("R SEL INDEX: $_selectedIndex");
                            
                            setState(() {
                              _thisIndex = message.id;
                            });

                            messageReadOptions(message);
                            //await storage.write(key: "new_status", value: 'P');
                            //await _updateMessage(message);
                          },
                        ),
                      );
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);  
                    } */
                  //}
                  
                //)
              //)
                
                /*
                onTap: () async { 
                  var item = message.title;
                  
                  //print("Container was tapped: $item"); 
                  //print("Message Status: ${message.status}"); 
                  
                  if(message.status == 'P') {
                      
                    if(_rea == 'R'){
                        messageUnReadOptions(message);
                    } else {
                        messageReadOptions(message); 
                    }
                  
                  } else if(messageStatus == 'R') {
                    
                    if(_readStatus == 'P'){
                        messageReadOptions(message);
                    } else {
                        messageUnReadOptions(message); 
                    } 
                  
                  }
                  */
                
                },
                child: 
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  //color: message.status == 'R'? Colors.deepOrangeAccent : Colors.transparent,
                  color: declareVariable(),
                  //color: _selectedIndex == message.id ? Colors.deepOrangeAccent : Colors.purpleAccent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[500],
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /* Container(
                      padding: const EdgeInsets.only(top: 10, right: 15, bottom: 10),
                      child: ClipOval(
                        child: Image.asset(
                          //contact.imageUrl == null ? Image.asset('images/totally_logo_circle_green_a.png') : NetworkImage(contact.imageUrl),
                          //contact.imageUrl,
                          'images/totally_logo_circle_green_a.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ), */
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Text('${message.title} ${message.body}'),
                          SizedBox(height: 5),
                          Text(
                            '${message.title}',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: 2),
                          Text('${message.body}'),
                          SizedBox(height: 2),
                          Text('${message.shift}'),
                          SizedBox(height: 2),
                          Text('${message.sent}'),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /* Icon(
                          Icons.create,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 15.0),
                        Icon(
                          Icons.message,
                          color: Colors.grey[600],
                        ), */
                        SizedBox(width: 15.0),
                        new Container(
                          child: new IconButton(
                            icon: new Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              //if()
                              Navigator.of(context).pushNamed(
                                '/shifts'
                                //'/shiftMessageDetails',
                                //arguments: message 
                              );
                            },
                          ),
                          //margin: EdgeInsets.only(top: 25.0),
                        )
                      ],
                    ),
                  ],
                ),
              )
            )

          );
      
      /* return Dismissible(
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
      ); */
    }
  
    updateMessages(length){
      print("UPDATE $length");
    }
}