import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/webservice/Resource.dart';
import '../dio.dart';

class Test extends ChangeNotifier {
  
  String id;
  String emailAddress;
  String password;
  
  Test({this.id, this.emailAddress, this.password});

  @override
  //String toString() {
    //return 'Test: {email: ${emailAddress}, password: ${password}}';
  //}

  factory Test.fromJson(json){
    return Test(
      id: json['test_id'],
      emailAddress: json['test_email'],
      password: json['test_password'],
    );
  }

  static Resource getTest (String testId) {
            
    return Resource(
      url: 'test/$testId',
          
      parse: (response) {     
        
        print("RESPONDING");
        
        print(json.decode(response.body));

        final test = json.decode(response.body)['data'];
           
           //print("TEST $test:");

           return Test.fromJson(test);
      }
    );
  }
  
  static Resource postXForm (String messageTo) {
            
    return Resource(
      url: 'messages/$messageTo',
      parse: (response) {

      } 
    );
  }

  Future postForm ({Map<String, dynamic> data, Function success, Function error}) async {
  
    try {
      
      print("UPDATE DATA");
      print(data);
      
      Dio.Response response = await dio().post(
        'test/1',
        data: json.encode(data)
      );

      var name = response.data.toString();

      print("NAME: $name");

      //String token = json.decode(response.toString())['token'];

      //print(token);

      //this._setStoredToken(token);
      //this.attempt(token: token);
            
      success();
      
    } catch (e) {
      error();
      print(e);
    }
  }
}