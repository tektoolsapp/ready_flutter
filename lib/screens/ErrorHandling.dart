import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ready_prod/screens/otp_response.dart';
import 'package:flutter_ready_prod/screens/otp_service.dart';
import 'package:flutter_ready_prod/screens/verification_change_notifier.dart';
import 'package:provider/provider.dart';

class ErrorHandling extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return ErrorHandlingState();
  }  
}

class ErrorHandlingState extends State<ErrorHandling> {
 String _phoneNumber;
 /* String _oneTimePassword;
 final otpService = OneTimePasswordService();
 void getOneTimePassword() async {
   var oneTimePasswordResponse = await otpService.getOneTimePassword(_phoneNumber);
   setState(() {
     _oneTimePassword = oneTimePasswordResponse.toString();
   });
 } */

 Future<OneTimePasswordResponse> otpResponseFuture;
 final otpService = OneTimePasswordService();

 /* void getOneTimePassword() async {
   setState(() {
     otpResponseFuture = otpService.getOneTimePassword(_phoneNumber);
   });
 } */

 //void getOneTimePassword(){}

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Error Handling"),
     ),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Container(
             child: TextField(
                 onChanged: (phoneNumber) {
                   setState(() {
                     _phoneNumber = phoneNumber;
                   });
                 },
                 decoration: InputDecoration(hintText: 'Enter a code'),
                 inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                 keyboardType: TextInputType.number),
             width: MediaQuery.of(context).size.width * 0.5,
           ),
           
           Consumer<VerificationChangeNotifier>(
            builder: (_, notifier, __) {
              if (notifier.state == NotifierState.initial) {
                return Text('After entering the code number, press the button below');
              } else if (notifier.state == NotifierState.loading) {
                return CircularProgressIndicator();
              } else {
                if (notifier.exception != null) {
                  return Text(notifier.exception.toString());
                } else {
                  return Text(notifier.otpResponse.toString());
                }
              }
            },
           ),
           
           //if(_oneTimePassword != null) Text(_oneTimePassword),
           /* FutureBuilder<OneTimePasswordResponse>(
            future: otpResponseFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                return Text(error.toString());
              } else if (snapshot.hasData) {
                final response = snapshot.data;
                return Text(response.toString());
              } else {
                return Text('After entering the code number, press the button below');
              }
            },
           ), */
           RaisedButton(
             onPressed: () {getOneTimePassword();},
             child: Text('Get Code'),
           ),
         ],
       ),
     ),
   );
 }

 void getOneTimePassword() async {
  Provider.of<VerificationChangeNotifier>(context).getOneTimePassword(_phoneNumber);
  }
}