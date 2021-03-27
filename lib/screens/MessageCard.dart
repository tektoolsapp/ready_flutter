import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessageCard extends StatefulWidget {

  final Message2 message;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  MessageCard(this.message, {this.onDelete, this.onUpdate});
  
  @override 
  _MessageCardState createState() => _MessageCardState(message, onDelete, onUpdate); 

}

class _MessageCardState extends State<MessageCard> {
  
  final storage = new FlutterSecureStorage();  
  Message2 message;
  final onDelete;
  final onUpdate;

  _MessageCardState(this.message, this.onDelete, this.onUpdate);  //constructor

  bool isSuccessFromApi = false;
  bool isLoading = false;

  //String _newMessageStatus;
  String _selectedIndex = "";
  String _currentMessage = 'empty';
  String _thisIndex = 'empty';

  //bool _itemRead;
  String _readStatus;
  
  @override
  void initState() {
    super.initState();
    //_itemRead = false;
    //_readStatus = 'P';
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
      //isLoading = true;
      
    });
    //call the api
    //after success or failure
    /* setState(() {
      isLoading = false;
      isSuccessFromApi = true;
    }); */
  }

  void messageReadOptions(){
    
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
              onUpdate();
              Navigator.pop(context);
              setState(() => {
                _readStatus = 'R'           
              });
              //print("SET READ STATUS $_readStatus");
            },
          ),  
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () => {
            Navigator.pop(context)
          },
        ) 
      ),
    );
  }

  void messageUnReadOptions(){
    
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
              onUpdate();
              Navigator.pop(context);
              setState(() => {
                _readStatus = 'P'
              });
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Cancel"),
          onPressed: () => {
            Navigator.pop(context)
          },
        ) 
      ),
    );
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
                  /* setState(() {
                    _selectedIndex = "";
                  }); */
                  
                  print("CLICKED A!");
              },
            ), 
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from photo library"),
              onTap: () {
                /* Navigator.pop(context),
                _showPhotoLibrary() */
                /* setState(() {
                  _selectedIndex = "";
                }); */
                
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
    
    bool nowSelected = _thisIndex == message.id;
    bool isSelected = _selectedIndex == _currentMessage;
    var messageStatus = message.status;

    //_readStatus = message.status;

    //print("NOW SELECTED: ${nowSelected}");
    //print("MESSAGE STATUS: ${messageStatus}");
    //print("IS SELECTED: $isSelected");

    //print("ITEM READ: $_itemRead");
    //print("READ STATUS: $_readStatus");
    
    declareVariable() {
        
      if (messageStatus == 'P'){

        if(_readStatus == 'P') {
            var tileColor = Color(0xFFFFFFFF);
            return tileColor;
          
        } else if(_readStatus == 'R') {
            var tileColor = Color(0xFFFFAB91);
            return tileColor;
        } else {
            var tileColor = Color(0xFFFFFFFF);
            return tileColor;
        } 

       } else if (messageStatus == 'R'){
          
        if(_readStatus == 'P') {
            var tileColor = Color(0xFFFFFFFF);
            return tileColor;
        
        } else if(_readStatus == 'R') {
            var tileColor = Color(0xFFFFAB91);
            return tileColor;
        } else {
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
          onDelete();
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
            var item = message.title;
            
            //print("Container was tapped: $item"); 
            //print("Message Status: ${message.status}"); 
            
            if(message.status == 'P') {
                
                if(_readStatus == 'R'){
                  messageUnReadOptions();
                } else {
                  messageReadOptions(); 
                }
            
            } else if(messageStatus == 'R') {
               
               if(_readStatus == 'P'){
                  messageReadOptions();
                } else {
                  messageUnReadOptions(); 
                } 
            
            }
          
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
  }
}