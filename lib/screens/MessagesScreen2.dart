import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_ready_prod/models/messageCounter.dart';
import 'package:flutter_ready_prod/screens/MessageCard.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MessagesScreen2 extends StatefulWidget {
  @override
  _MessagesScreen2State createState() => _MessagesScreen2State();
}

class _MessagesScreen2State extends State<MessagesScreen2> {
  
  // ignore: deprecated_member_use
  List<Message2> _messages = List<Message2>(); 
  
  String _newMessageStatus;
  bool _isLoading = true;
  int _numLoaded = 0;
  bool showStack = false;
  
  String _homeScreenText = "Waiting for token...";
  // ignore: unused_field
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final storage = new FlutterSecureStorage();

  void _storeMessages(numMessages) async {
    //String numMessages = await storage.read(key: 'numMessages');    
    print("STORE FETCHED MESSAGES: $numMessages");
    Provider.of<MessageCounter>(context, listen: false).storeMessages(numMessages);  
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
  
  @override
  void initState() {
    super.initState();
    
    _populateMessages();
    
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "PushX Messaging message: $message";
        });
        print("MESSAGE REC: $message");
        //_increment();
        _populateMessages();
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
        _populateMessages();
        
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

  Future<void> _populateMessages() async {
    var userId = await storage.read(key: 'user');
    final counter = Provider.of<MessageCounter>(context, listen: false ); 
    Webservice().load(Message2.getMessages(userId)).then((messages) => {
      
      setState(() => {
        _messages = messages,
        _isLoading = false,
        _numLoaded = _messages.length,
        counter.messageCounter = _messages.length
        }
      ),

      _storeMessages(_messages.length)

    });
    
  }

  updateList(List<Message2> _messages){

    setState(() => {
        //_messages = messages,
        //_isLoading = false,
        //_numLoaded = _messages.length,
        //counter.messageCounter = _messages.length
        }
      );

  }

  Future<void> _deleteMessage(messages, index) async {
  //Future<void> _deleteMessage(messages, index) async {

    var message = messages[index];
    _newMessageStatus = await storage.read(key: "new_status");

    Provider.of<Message2>(context, listen:false).deleteMessage(
      data: {
        'message_id': message.id,
        'message_status': _newMessageStatus,
      },
      success: () async {  
        print("DECREMENT:");

        //_decrement();
         
        /* setState(() {
          _messages = List.from(_messages)
            ..removeAt(index);
        }); */

        setState(() {
          _messages.removeAt(index);
        });

        print("FETCH AFTER DECREMENT:");
        //_populateMessages();

        //updateList(List<Message2> _messages);

        //print("MESSAGES AFTER DECREMENT: ${_messages[0]}");
      
      },
      error: (){
        print("ERROR");
      }
    ); 
  }  

  Future<void> _updateMessage(messages, index) async {

    var message = messages[index];
    _newMessageStatus = await storage.read(key: "new_status");

    Provider.of<Message2>(context, listen:false).deleteMessage(
      data: {
        'message_id': message.id,
        'message_status': _newMessageStatus,
      },
      success: () async {  
        print("UPDATE");
        //_decrement();
      
      },
      error: (){
        print("ERROR");
      }
    ); 
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Messages')
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: _isLoading ? _buildLoadingScreen() : _numLoaded > 0 ? _buildListView(_messages) : _buildNoMessagesScreen(),
    ); 
  }

  Widget _buildListView(List<Message2> messages) {
    
    //print("BUILDING");    
    //print("MESSAGES: ${messages}");
    print("BUILD NUM MESSAGES: ${messages.length}");

    //await 
    //storage.write(key: "numMessages", value: messages.length.toString()); 
    
    if(messages.length > 0) {  
      print("BUILDING LIST_________________________________:");
      return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageCard(messages[index], onDelete: () => _deleteMessage(messages, index), onUpdate: () => _updateMessage(messages, index));
        },
      );
    } else {
      return _buildNoMessagesScreen();
    }
  }

  Widget _buildNoMessagesScreen() {
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

  Widget _buildLoadingScreen() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}