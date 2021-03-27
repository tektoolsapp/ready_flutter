import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/MessageNew.dart';

class MessageNewCard extends StatefulWidget {
  
  final MessageNew message;
  MessageNewCard(this.message);
  
  @override 
  _MessageNewCardState createState() => _MessageNewCardState(message); 

}

class _MessageNewCardState extends State<MessageNewCard> {

  MessageNew message;
 _MessageNewCardState(this.message);  //constructor

 String _selectedIndex = "";
 bool isSuccessFromApi = false;
 bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = "";
  }

  archiveItem(){
    print("archive");

  }

  Widget popup() {
    showDialog(context: context, builder: (builder) {
      return AlertDialog(
        content: !isSuccessFromApi ? Container(
          child: Text('Are you Sure???'),
        ) : Container( child: isLoading ? CircularProgressIndicator() : Text('Success'),),
        actions: <Widget>[
          Text('Cancel'),
          InkWell(
            child: Text('OK'),
            onTap: apiCall,
          )
        ],
      );
    });
  }

  void apiCall(){
    setState(() {
      isLoading = true;
    });
    //call the api
    //after success or failure
    /* setState(() {
      isLoading = false;
      isSuccessFromApi = true;
    }); */
  }

  void _showOptions(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text("Take a picture from camera"),
              onTap: () {
                //Navigator.of(context).pop();
                  // show the camera
                  //_showCamera(context);
                  setState(() {
                    _selectedIndex = "";
                  });
                  
                  print("CLICKED A!");
              },
            ), 
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from photo library"),
              onTap: () {
                /* Navigator.pop(context),
                _showPhotoLibrary() */
                setState(() {
                  _selectedIndex = "";
                });
                
                print("CLICKED B!");

              },
            )
          ])
        );
      }
    );
  }

  Future<bool> promptUser(DismissDirection direction) async {
  String action;
  if (direction == DismissDirection.startToEnd) {
    // This is a delete action
    action = "delete";
  } else {
    archiveItem();
    // This is an archive action
    action = "archive";
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
  
  @override
  Widget build(BuildContext context) {
    
    return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) async {
      if (direction == DismissDirection.startToEnd) {
        //await storage.write(key: "new_status", value: 'X');
        //_deleteMessage(message);
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
          onTap: () { 
          var item = message.title;
          setState(() {
            _selectedIndex = message.id;
          });
          print("Container was tapped: $item"); 
          //_showOptions(context);
          popup();
          /* Navigator.of(context).pushNamed(
              '/',             
            );  
          }, */
          },
          child: 
          Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            //color: contact.status == 'A'? Colors.deepOrangeAccent : Colors.purpleAccent,
            color: _selectedIndex == message.id ? Colors.deepOrangeAccent : Colors.purpleAccent,
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
              Container(
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
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${message.title} ${message.body}'),
                    SizedBox(height: 2),
                    Text('${message.sent}'),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.create,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 15.0),
                  Icon(
                    Icons.message,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 15.0),
                  Icon(
                    Icons.call,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
        )
      )

    );
  }
}