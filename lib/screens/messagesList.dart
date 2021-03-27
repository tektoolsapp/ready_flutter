import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:flutter_ready_prod/webservice/Webservice2.dart';

class MessagesList extends StatefulWidget {

  @override
  createState() => MessagesListState(); 
}

class MessagesListState extends State<MessagesList> {

  // ignore: deprecated_member_use
  List<Message2> _messages = List<Message2>(); 

  @override
  void initState() {
    super.initState();
    _populateMessages(); 
  }

  void _populateMessages() {
   
    Webservice().load(Message2.getMessages('1')).then((messages) => {
      setState(() => {
        _messages = messages
      })
    });

  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
      return ListTile(
        title: Text(_messages[index].title, style: TextStyle(fontSize: 18)), 
        subtitle: Text(_messages[index].body, style: TextStyle(fontSize: 18)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
        ),
        body: ListView.builder(
          itemCount: _messages.length,
          itemBuilder: _buildItemsForListView,
        )
      );
  }
}