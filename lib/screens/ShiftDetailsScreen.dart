import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/FormSubmitButton.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/MyFormTextField.dart';
//import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:flutter_ready_prod/models/Shift2.dart';
import 'package:flutter_ready_prod/models/Test.dart';
//import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:provider/provider.dart';

class ShiftDetailsScreen extends StatefulWidget {
  //final Test _test;

  //ShiftDetailsScreen({Test test}) : _test = test;
  
  final Shift _shift;
  //ShiftDetailsScreen({Shift shift}) : _shift = shift;
  
  final Shift2 _shift2;
  ShiftDetailsScreen({Shift shift, Shift2 shift2}) : _shift = shift, _shift2 = shift2;
  
  @override
  State<StatefulWidget> createState() {
    return ShiftDetailsScreenState(_shift, _shift2);
  }
}

class ShiftDetailsScreenState extends State<ShiftDetailsScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSwitched = false;
  //bool _switchValue = false;
  //
  bool confirmVal = false;
  bool updateData = true;
  var shiftUpdate = '';
  var hasTravelDocs = true;
  
  final Shift _shift;
  final Shift2 _shift2;

  Future<Shift> futureForm;

  ShiftDetailsScreenState(Shift shift, Shift2 shift2) : _shift = shift, _shift2 = shift2;
  
    // uniquely identifies a Form
    // observe that we're passing the FormState
    // and not MyFormState which is our widget
    final _formKey = GlobalKey<FormState>();
    
    // holds the form data for access
    final model = Shift();
    final model2 = Shift2();

    //TextEditingController _siteController;
    //bool confirmVal = false;
    //bool initVal = false;
    ///var shiftUpdate = '';

    //Future<Shift> _formFuture;

    // email RegExp
    // we'll use this RegExp to check if the
    // form's emailAddress value entered is a valid
    // emailAddress or not and raise a validation error 
    // for the erroneous case
    //final _emailRegExp = RegExp(
      //  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  
  @override
  void initState() {
    /* if(model.confirmStatus){
      confirmVal = true;
    } else {
      confirmVal = false;
    } */
    futureForm = byShift(_shift.id);
    updateData = true;
    
    super.initState();
    
    print("FF: $futureForm");
    
    //futureAlbum = fetchAlbum();



    //_idController = new TextEditingController(text: _shift.id);
    //_siteController = new TextEditingController(text: _shift.site);
    //_startController = new TextEditingController(text: _shift.start + " - " + _shift.time);
    //_endController = new TextEditingController(text: _shift.end + " - " + _shift.endtime);
    //_statusController = new TextEditingController(text: _shift.status);
    
  }

  void _getTravelDocs() {
    print("travel docs");

  }
  void _submit (context){
    //print(_idController.text);
    //print(_siteController.text);
    //print(_startController.text);
    //print(_endController.text);
    //print(_statusController.text);
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
        'ShiftId': _shift.id
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

  @override
  Widget build(BuildContext context) {
    
    final Size screenSize = MediaQuery.of(context).size;
    final buttonColor = const Color(0xFF27447E);
    
    /* void _postForm(model, testId){
      print('SUBMIT');
      print(testId);
      print(model.emailAddress);
      print(model.password);

      Provider.of<Test>(context, listen:false).postForm(
      data: {
        'test_id': testId,
        'test_email' : model.id,
        'test_password' :  model.id
      },
      success: (){
        //Navigator.of(context).pop();
        //Navigator.pop(context);

        scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Good to go!")
            //duration: Duration(seconds: 2),
          ));
        print("SUCCESS");

      },
      error: (){
        print("ERROR");
        scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Error, Try again!")
            //duration: Duration(seconds: 2),
          ));
      }
    );
  } */

  /* void _attemptChange(bool newState) {
    
    print("CLICKED");
    
    setState(() {
      confirmVal = newState;
      //newState ? _switchCase = 'ON' : _switchCase = 'OFF';
    });
  } */
    
  return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
        title: Text("Swing Ref: " + _shift.ref + "-" + _shift.id),
    ),
    body:
      Consumer<Auth>(
        builder: (context, test, child) {
          return FutureBuilder(
            //future: Webservice().load(Shift2.byShift(_shift.id)),
            future: futureForm,
            builder: (context, snapshot) {
              
              if(snapshot.hasError) {
                //return WebserviceFail();
                print("SNAPSHOT: ${snapshot.error}");
              }
              if(snapshot.hasData) {
                
                //var testId = snapshot.data.site;
                //print("DATA $testId");

                //var testStatus = _shift.id;
                //print("STATUS_______ $testStatus");
                
                print("UPDATE DATA: $updateData");

                if(updateData){
                  if(snapshot.data.confirm == 'Y'){
                    confirmVal = true;
                  } else {
                    confirmVal = false;
                  }                 
                }
          
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(0.0),
                        width: double.infinity,
                        //height: double.infinity,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 15.0, 15, 15.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: <Widget>[
                            SizedBox(height: 10.0,),
                            Text(
                              "Confirm Swing Availability",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0, 
                                fontWeight: FontWeight.w500),
                              ),
                            SizedBox(height: 25.0,),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  MyFormTextField(
                                    enabled: false,
                                    initVal: snapshot.data.site,
                                    isObscure: false,
                                    decoration: InputDecoration(
                                        labelText: "Site",
                                        hintText: "Enter Site Description",
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return 'Please enter a Site Description';
                                        //} else if (!_emailRegExp.hasMatch(value)) {
                                            //return 'Invalid email address!';
                                        }
                                        return null;
                                    },
                                    onSaved: (value) {
                                        model.site = value;
                                    },
                                  ),
                                  SizedBox(height: 25.0,),
                                  MyFormTextField(
                                    enabled: false,
                                    initVal: snapshot.data.start + " - " + snapshot.data.time,
                                    isObscure: false,
                                    decoration: InputDecoration(
                                        labelText: "Swing Start",
                                        hintText: "Start Date/Time",
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return 'Please enter a Start Date/Time';
                                        }
                                        return null;
                                    },
                                    onSaved: (value) {
                                        model.start = value;
                                    },
                                  ),
                                  SizedBox(height: 25.0,),
                                  MyFormTextField(
                                    enabled: false,
                                    initVal: snapshot.data.end + " - " + snapshot.data.endtime,
                                    isObscure: false,
                                    decoration: InputDecoration(
                                        labelText: "Swing End",
                                        hintText: "End Date/Time",
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return 'Please enter an End Date/Time';
                                        }
                                        return null;
                                    },
                                    onSaved: (value) {
                                        model.start = value;
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
                                            updateData = false;
                                          });
                                          _submit(context);
                                        },
                                      ),
                                    ],  
                                  ),
                                  
                                  Visibility(
                                  visible: hasTravelDocs, 
                                  child: Container(
                                    width: screenSize.width,
                                    height: 60,
                                    margin: EdgeInsets.only(
                                      top: 25
                                    ),
                                    child: RaisedButton(
                                      child: Text(
                                        'View Travel Docs',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25 
                                        )
                                      ),
                                      //onPressed: () => _getTravelDocs(),
                                      
                                      onPressed: () => {
                                        setState(() {
                                          hasTravelDocs = true;
                                        }),
                                        //Navigator.pop(context)
                                        //_getTravelDocs()
                                        Navigator.of(context).pushNamed(
                                          '/travelDocs',
                                          arguments: snapshot.data.id 
                                        )
                                        
                                      },
                                      
                                      
                                      color: buttonColor
                                    ),
                                  )
                                )
                                  //
                                
                                ///end form children
                                ]
                              ),
                              ///  
                            )  
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              
              }
              return Loading();
            }
          ); 
        }
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