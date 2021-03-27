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
//import 'package:flutter_ready_prod/models/Message.dart';


class MessagesScreen extends StatelessWidget {

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
                        return _buildShift(snapshot.data[index], context);
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

    Widget _buildShift (Message message, context){   
      return Column (
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
      );
    }
  
    updateMessages(length){
      print("UPDATE $length");
    }
  }