import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/FormSubmitButton.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/MyFormTextField.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Shift.dart';
import 'package:flutter_ready_prod/models/Shift2.dart';
import 'package:flutter_ready_prod/models/Test.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:provider/provider.dart';

class ShiftConfirmScreen extends StatefulWidget {
  //final Test _test;

  //ShiftConfirmScreen({Test test}) : _test = test;
  
  final Shift _shift;
  //ShiftConfirmScreen({Shift shift}) : _shift = shift;
  
  final Shift2 _shift2;
  ShiftConfirmScreen({Shift shift, Shift2 shift2}) : _shift = shift, _shift2 = shift2;
  
  @override
  State<StatefulWidget> createState() {
    return ShiftConfirmScreenState(_shift, _shift2);
  }
}

class ShiftConfirmScreenState extends State<ShiftConfirmScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSwitched = false;
  bool _switchValue = false;
  
  final Shift _shift;
  final Shift2 _shift2;

  ShiftConfirmScreenState(Shift shift, Shift2 shift2) : _shift = shift, _shift2 = shift2;
  
    // uniquely identifies a Form
    // observe that we're passing the FormState
    // and not MyFormState which is our widget
    final _formKey = GlobalKey<FormState>();
    
    // holds the form data for access
    final model = Shift();
    final model2 = Shift2();

    // email RegExp
    // we'll use this RegExp to check if the
    // form's emailAddress value entered is a valid
    // emailAddress or not and raise a validation error 
    // for the erroneous case
    final _emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  
  @override
  Widget build(BuildContext context) {
    
    void _postForm(model, testId){
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
  }
    
  return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
        title: Text("Confirm Swing Availability"),
    ),
    body:
      Consumer<Auth>(
        builder: (context, test, child) {
          return FutureBuilder(
            future: byShift(_shift.id),
            builder: (context, snapshot) {
              
              print("SNAP $snapshot");
              
              if(snapshot.hasError) {
                //return WebserviceFail();
                print("SS ERROR");
              }
              if(snapshot.hasData) {
                
                var testId = snapshot.data.id;
                print("DATA $testId");

                var testStatus = _shift.id;
                print("STATUS_______ $testStatus");

                return Container(
                  //decoration: BoxDecoration(color: Colors.blue),
                  //scrollDirection: Axis.vertical,
                  //shrinkWrap: true,
                  padding: EdgeInsets.all(0.0),
                  width: double.infinity,
                  child: Container(

                  )
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