import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:provider/provider.dart';

class ShiftDetailsScreen extends StatefulWidget {
  
  final Shift _shift;

  ShiftDetailsScreen({Shift shift}) : _shift = shift;

  @override
  State<StatefulWidget> createState() {
    return ShiftDetailsScreenState(_shift);
  }  
}

class ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  final Shift _shift;

  bool confirmVal = false;
  
  ShiftDetailsScreenState(Shift shift) : _shift = shift;
  TextEditingController _idController;
  TextEditingController _siteController;
  TextEditingController _startController;
  TextEditingController _endController;
  TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _idController = new TextEditingController(text: _shift.id);
    _siteController = new TextEditingController(text: _shift.site);
    _startController = new TextEditingController(text: _shift.start + " - " + _shift.time);
    _endController = new TextEditingController(text: _shift.end + " - " + _shift.endtime);
    _statusController = new TextEditingController(text: _shift.status);
  }

  void _submit (context){
    print(_idController.text);
    print(_siteController.text);
    print(_startController.text);
    print(_endController.text);
    print(_statusController.text);
    print(confirmVal);

    //UPDATE STATUS TO A
    Provider.of<Auth>(context, listen:false).updateStatus(
      data: {
        'shift_id': _idController.text,
        'shift_status': _statusController.text
      },
      success: (){
        Navigator.of(context).pop();
        Navigator.pop(context);

        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Updated!")
          //duration: Duration(seconds: 2),
        ));
      },
      error: (){
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Updating Error, Try again!")
          //duration: Duration(seconds: 2),
        ));
      }
    );
  }  

  //STYLED CHECKBOX WORTH LOOKING AT
  //https://www.geeksforgeeks.org/flutter-checkboxlisttile/

  @override
  Widget build(BuildContext context) {
    
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Shift Ref: " + _shift.ref),
      ),
      bottomNavigationBar: BottomNav(),
      body: Container( 
        padding: EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25.0,),
              Visibility(
                visible: false,
                child: TextFormField(
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: _idController,
                ),
              ),
              Visibility(
                visible: false,
                child: TextFormField(
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: _statusController,
                ),
              ),
              TextFormField(
                enableInteractiveSelection: false, // will disable paste operation
                focusNode: new AlwaysDisabledFocusNode(),
                controller: _siteController,
                style: TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  hintText: _shift.site,
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightGreen
                    )
                  ),
                  labelText: 'Site' 
                ),
              ),
              SizedBox(height: 25.0,),
              TextFormField(
                enableInteractiveSelection: false, // will disable paste operation
                focusNode: new AlwaysDisabledFocusNode(),
                controller: _startController,
                style: TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  hintText: _shift.start,
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.teal,
                    ),
                  ),
                  labelText: 'Shift Start' 
                ),
              ),
              SizedBox(height: 25.0,),
              TextFormField(
                enableInteractiveSelection: false, // will disable paste operation
                focusNode: new AlwaysDisabledFocusNode(),
                controller: _endController,
                style: TextStyle(fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  hintText: _shift.end,
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.teal,
                    ),
                  ),
                  labelText: 'Shift End' 
                ),
              ),
              SizedBox(height: 25.0,),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  'Check to Confirm Availability',
                  style: TextStyle(
                      fontSize: 20 
                    )
                ),
                value: confirmVal,
                onChanged: (bool value) {
                  setState(() {
                    confirmVal = value;
                  });
                },
              ),  
              SizedBox(height: 25.0,),
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
                  onPressed: () => _submit(context),
                  color: Colors.blue
                ),
              )
              ///
            ]
          )
        )
      )
    ); 
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}    
