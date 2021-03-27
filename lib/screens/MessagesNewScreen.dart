import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/models/MessageNew.dart';
import 'package:flutter_ready_prod/screens/MessageNewCard.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';

class MessagesNewScreen extends StatefulWidget {
  @override
  _MessagesNewScreenState createState() => _MessagesNewScreenState();
}

class _MessagesNewScreenState extends State<MessagesNewScreen> {
  
  Future<List<MessageNew>> _messages;

  //List<MessageNew> _messages = List<MessageNew>(); 

  @override
  void initState() {
    super.initState();
    _populateMessages(); 
  }

  void _populateMessages() {
   
    Webservice().load(MessageNew.getMessages("1")).then((messages) => {
      setState(() => {
        _messages = messages
      })
    });

  }

  /* @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
} */
  
  @override
  Widget build(BuildContext context) {
    
    //final auth = Provider.of<Auth>(context, listen:false);
    
    return Scaffold (
      appBar: AppBar(
        title: Text('Messages')
      ),
      drawer: AppDrawer().build(context),
      bottomNavigationBar: BottomNav(),
      body: 
        FutureBuilder<List<MessageNew>>(
          future: _messages,
          builder: (ctx, snapshot) {
            List<MessageNew> messages = snapshot.data;
            
            print("SNAPSHOT $messages");
            
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return _buildListView(messages);
              default:
                return _buildLoadingScreen();
            }
          },
        )
    ); 
  }

  Widget _buildListView(List<MessageNew> messages) {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return MessageNewCard(messages[idx]);
      },
      itemCount: messages.length,
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