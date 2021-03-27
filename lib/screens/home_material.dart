import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:flutter_ready_prod/components/FormSubmitButton.dart';
import 'package:flutter_ready_prod/components/Loading.dart';
import 'package:flutter_ready_prod/components/MyFormTextField.dart';
import 'package:flutter_ready_prod/components/WebserviceFail.dart';
import 'package:flutter_ready_prod/models/Test.dart';
import 'package:flutter_ready_prod/webservice/Webservice.dart';
import 'package:provider/provider.dart';

class MyForm extends StatefulWidget {
  
  final Test _test;

  MyForm({Test test}) : _test = test;
  
  @override
  State<StatefulWidget> createState() {
    return MyFormState(_test);
  }
}

class MyFormState extends State<MyForm> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  final Test _test;

  MyFormState(Test test) : _test = test;
  
    // uniquely identifies a Form
    // observe that we're passing the FormState
    // and not MyFormState which is our widget
    final _formKey = GlobalKey<FormState>();
    
    // holds the form data for access
    final model = Test();

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
        'test_email' : model.emailAddress,
        'test_password' :  model.password
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
        title: Text("My Form"),
    ),
    body:
      Consumer<Auth>(
        builder: (context, test, child) {
          return FutureBuilder(
            future: Webservice().load(Test.getTest("1")),
            builder: (context, snapshot) {
              
              if(snapshot.hasError) {
                return WebserviceFail();
              }
              if(snapshot.hasData) {
                
                var testId = snapshot.data.id;
                print("DATA $testId"); 
                
                return Container(
                  //decoration: BoxDecoration(color: Colors.blue),
                  padding: EdgeInsets.all(0.0),
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      children: <Widget>[
                      Text(
                        "Login Form",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0, 
                          fontWeight: FontWeight.w500),
                      ),
                      Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //EmailAddressWidget
                          //PasswordWidget
                          //SubmitButton
                          SizedBox(height: 25.0,),
                          MyFormTextField(
                            //initialValue: _message.shift,
                            initVal: snapshot.data.emailAddress,
                            isObscure: false,
                            // EmailAddress decoration
                            decoration: InputDecoration(
                                labelText: "EmailAddress",
                                hintText: "me@abc.com",
                            ),
                            // EmailAddress validation
                            // checks if the value is empty and
                            // shows an error message along side
                            // checks if the value is a valid emailAddress
                            // and shows an error message if not valid
                            validator: (value) {
                                if (value.isEmpty) {
                                    return 'Please enter an email address';
                                } else if (!_emailRegExp.hasMatch(value)) {
                                    return 'Invalid email address!';
                                }
                                return null;
                            },
                            // onSaved callback
                            // assign the entered value
                            // to the emailAddress field of the 
                            // FormModel object we created
                            onSaved: (value) {
                                model.emailAddress = value;
                            },
                          ), 
                          SizedBox(height: 25.0,),
                          MyFormTextField(
                            // masks the input text
                            // typical password box style
                            initVal: snapshot.data.password,
                            isObscure: false,
                            // Password box decoration
                            decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter a Password",
                            ),
                            // Password validation
                            // checks if the value is empty and
                            // shows an error message along side
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                              // onSaved callback
                              // assign the entered value
                              // to the password field of the 
                              // FormModel object we created
                              onSaved: (value) {
                                  model.password = value;
                              },
                            ),
                            SizedBox(height: 25.0,),
                            FormSubmitButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  
                                  // the model object at this point can be POSTed
                                  // to an API or persisted for further use

                                  //var formData = model.toString();
                                  //print("MODEL $formData");

                                  _postForm(model, testId);

                                  Scaffold.of(_formKey.currentContext).showSnackBar(
                                      SnackBar(content: Text('Processing Data')));
                                }
                              },
                            ), 
                          ],
                        ),
                      )
                    ],
                  ),
                )

                );


              //
              }
              return Loading();
            }
          ); 
        }
      )
    );   
      
  }

}