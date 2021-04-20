import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/BottomNav.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:provider/provider.dart';

class ShiftDetailsScreen extends StatefulWidget {
  
  final Shift _shift;
  bool _isSelected = false;
  
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
  var shiftUpdate = '';
  bool _switchValue = false;
  
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
    if(_shift.confirm == 'Y'){
      confirmVal = true;
    } else {
      confirmVal = false;
    }
  } 

  void _submit (context){
    print(_idController.text);
    print(_siteController.text);
    print(_startController.text);
    print(_endController.text);
    print(_statusController.text);
    print(confirmVal);

    if(confirmVal){
      shiftUpdate = 'Y';
    } else {
      shiftUpdate = 'N';
    }

    //UPDATE STATUS TO A
    Provider.of<Auth>(context, listen:false).updateStatus(
      data: {
        'EmployeeConfirmed':shiftUpdate,
        'ShiftId': _idController.text
      },
      success: (){
        //Navigator.of(context).pop();
        //Navigator.pop(context);

        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Confirmation has been Updated!")
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
    final buttonColor = const Color(0xFF27447E);

    print(_shift.confirm);
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Swing Ref: " + _shift.ref),
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
                  labelText: 'Swing Start' 
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
                  labelText: 'Swing End' 
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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Text(
                    "Confirmed ",
                    style: TextStyle(
                      //color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CupertinoSwitch(
                    value: confirmVal,
                    onChanged: (bool value) {
                      setState(() {
                        confirmVal = value;
                      });
                    },
                  ),
                ],  
              ),
              
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
                  color: buttonColor
                ),
              )
              ///
            ]
          )
        )
      )
    ); 
  }

  Future<Shift> byShift(String id) async {
  
    final result = await Shift().byShift(id);

    print("RESULT: $result ");
    
    // ignore: unrelated_type_equality_checks
    if (result == false) {
      throw new FormatException('thrown-error');
    }

    //final dur = const Duration(seconds: 2);
    //return new Future.delayed(dur, () => result);
    
    return result;
  }
  
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}    
