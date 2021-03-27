
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Drawer.dart';
import 'package:flutter_ready_prod/models/Message.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';

class Dismissal extends StatefulWidget {
  @override
  _DismissalState createState() => _DismissalState();
}

class _DismissalState extends State<Dismissal> {
  
//List<Message> lst = Webservice().load(Message.fromMessages("1")),
  
  List<String> lst = [
    '1',
    '2',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  Future<List<String>> getMyFavData() async {
    return Future.value(lst);
  }

  /* Future<void> deleteFromDataBase(int index) async {
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Message.removeAt(index);
    });
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List')
        ),
        drawer: AppDrawer().build(context),
        bottomNavigationBar: BottomNav(),
        body: FutureBuilder(
            future: getMyFavData(),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Container(
                  child: Center(
                    child:
                        CircularProgressIndicator(backgroundColor: Colors.red),
                  ),
                );
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              //await deleteFromDataBase(index);
                            }
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.startToEnd,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(lst[index]),
                            color: Colors.blue,
                            margin: EdgeInsets.all(5.0),
                          ));
                    });
            }),
      ),
    );
  }
}