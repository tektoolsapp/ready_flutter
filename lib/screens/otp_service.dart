import 'dart:io';
import 'dart:math';
import 'package:flutter_ready_prod/screens/otp_response.dart';
import 'package:flutter_ready_prod/screens/verification_exception.dart';

class MockHttpClient {
 var randomGenerator = new Random();

 Future<String> getResponseBody() async {
   await Future.delayed(Duration(milliseconds: 1000));
   //return _generateOneTimePassword();
   throw HttpException("500");
 }

 _generateOneTimePassword() {
   return '{ "verificationCode": "' +
       randomGenerator.nextInt(10).toString() +
       randomGenerator.nextInt(10).toString() +
       randomGenerator.nextInt(10).toString() +
       randomGenerator.nextInt(10).toString() +
       '"}';
 }
}

class OneTimePasswordService {
 final httpClient = MockHttpClient();
 
 Future<OneTimePasswordResponse> getOneTimePassword(String phoneNumber) async {
    //final responseBody = await httpClient.getResponseBody();
    //return OneTimePasswordResponse.fromJson(responseBody);
  
    try {
      final responseBody = await httpClient.getResponseBody();
      return OneTimePasswordResponse.fromJson(responseBody);
    }
    on SocketException {
      throw VerificationException('No Internet connection');
    } on HttpException {
      throw VerificationException("Service is unavailable");
    }

  }
 
 //Future<OneTimePasswordResponse> getOneTimePassword(String phoneNumber) async {
   /* final responseBody = await httpClient.getResponseBody();
   return OneTimePasswordResponse.fromJson(responseBody); */
   /* try {
      final responseBody = await httpClient.getResponseBody();
      return OneTimePasswordResponse.fromJson(responseBody);
    } catch (e) {
      print(e);
    }
 } */
}