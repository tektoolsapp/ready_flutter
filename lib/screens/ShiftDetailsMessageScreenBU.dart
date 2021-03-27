import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/Message2.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ready_prod/models/Message.dart';

class ShiftDetailsMessageScreen extends StatefulWidget {
  
  final Message2 _message;

  ShiftDetailsMessageScreen({Message2 message}) : _message = message;


  @override
  State<StatefulWidget> createState() {
    //return ShiftDetailsMessageScreenState(_message);
    return ShiftDetailsMessageScreenState(_message);
  }  
}

class ShiftDetailsMessageScreenState extends State<ShiftDetailsMessageScreen> {
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool confirmVal = false;


  final Message2 _message;

  ShiftDetailsMessageScreenState(Message2 message) : _message = message;
  //ShiftDetailsMessageScreenState(Message2 message) : message = message;
  //ShiftDetailsMessageScreenState({ Key key, @required this.message,}) : super(key: key);
  
  //TextEditingController _idController;
  //TextEditingController _siteController;
  //TextEditingController _startController;
  //TextEditingController _endController;
  //TextEditingController _statusController;

  final _siteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_siteController = new TextEditingController();
    /* _idController = new TextEditingController(text: _message.id);
    _siteController = new TextEditingController(text: _message.id);
    _startController = new TextEditingController(text: _message.id + " - " + _message.id);
    _endController = new TextEditingController(text: _message.id + " - " + _message.id);
    _statusController = new TextEditingController(text: _message.status); */
  }

  void _performUpdate(context) {
    var site = _siteController.text;

    print('SAVE attempt: $site');
  }
  
  void _submit (){
    //print(_idController.text);
    //print(_siteController.text);
    //print(_startController.text);
    //print(_endController.text);
    //print(_statusController.text);
    //print(confirmVal);
    print("SUBMIT");
    print(_siteController.text);
    
  }  

  //STYLED CHECKBOX WORTH LOOKING AT
  //https://www.geeksforgeeks.org/flutter-checkboxlisttile/

  @override
  Widget build(BuildContext context) {
      
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Message Ref: " + _message.shift),
      ),
      bottomNavigationBar: BottomNav(),
      body: 
      Consumer<Auth>(
        builder: (context, auth, child) {
          return FutureBuilder(
            future: Webservice().load(Message.byShift(_message.shift.toString())),
            //future: Webservice().load(Message.byShift(myInt)),
            builder: (context, snapshot) {        
              if(snapshot.hasError) {
                  return WebserviceFail();
              }
              if(snapshot.hasData) {
                return Container( 
                  padding: EdgeInsets.all(20),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 25.0,),
                        TextFormField(
                          enableInteractiveSelection: false, // will disable paste operation
                          //focusNode: new AlwaysDisabledFocusNode(),
                          //initialValue: _message.shift,
                          controller: _siteController,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          decoration: InputDecoration(
                            //hintText: message.id,
                            hintText: _message.shift,
                            hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                              color: Colors.teal,
                              ),
                            ),
                            labelText: 'Site' 
                          ),
                        ),
                        SizedBox(height: 50.0,),
                        Container(
                          width: screenSize.width,
                          height: 60,
                          margin: EdgeInsets.only(
                            top: 25
                          ),
                          child: RaisedButton(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25 
                              )
                            ),
                            onPressed: () => _performUpdate(context),
                            color: Colors.blue
                          ),
                        )
                      ]
                    )
                  )
                );       
              }
              return Loading(); 
            } 
          );
        },
      ),
    ); 
  }
}
  
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
} 

  


