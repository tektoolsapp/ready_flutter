import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/auth/Auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:provider/provider.dart';

//const PrimaryColor = const Color(0xFF151026);

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _token = "";
  
  var onTapRecognizer;

  void _submit (_token){
    
    print('SUBMIT WITH TOKEN: $_token');
    
    print(textEditingController.text);

    //print(emailController.text);
    //print(passwordController.text);
    
    Provider.of<Auth>(context, listen:false).signin(
      data: {
        'emp_pin': textEditingController.text,
        'fcm_token' : _token
      },
      success: (){
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          '/logged_in',              
        );
        
        //Navigator.pop(context);

        //Scaffold.of(context).showSnackBar(
          //SnackBar(content: Text('You are logged in'))
        //);
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

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  //final bool autoFocus = true;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final Color inactiveColor = const Color(0xFF151026);

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    
    errorController = StreamController<ErrorAnimationType>();

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
      });
      print(_token);
    });
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height / 8,
                child: FlareActor(
                  "assets/otp.flr",
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Enter Your PIN to Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              /*
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              */
              SizedBox(
                height: 1,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      //autoFocus: true,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      
                      validator: (v) {
                        if (v.length < 6 && hasError) {
                          return "Enter 6 Digits";
                        } else {
                          return null;
                        }
                      },
                      
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        //borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        //inactiveColor: Color(0xFFFFAB91),
                        //inactiveFillColor: Color(0xFFFFAB91),
                        activeFillColor:
                            hasError ? Colors.white : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      //backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        //print('completed');
                        //_submit (_token);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "Please enter 6 Digits" : "",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 1,
              ),
              /*
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              */
              SizedBox(
                height: 1,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    color: Color(0xFF27447E),
                    onPressed: () {
                      formKey.currentState.validate();
                      // conditions for validating
                      print("Current Text: $currentText");
                      var myLength = currentText.length;
                      print("Current Text Length: $myLength");
                      print("Error State:  $hasError");
                      
                      if (currentText.length < 6 ) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {
                        
                        _submit (_token);
                        
                        setState(() {
                          hasError = false;
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Logging In, Please Wait"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    },
                    
                    child: Center(
                        child: Text(
                      //"VERIFY".toUpperCase(),
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    /*
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]
                    */
                    ),
                    
              ),
              SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                      //hasError = false;
                      //setState(() {
                        //  hasError = false;
                        //});
                    },
                  ),
                  /* FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  ), */
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
