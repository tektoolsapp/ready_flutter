import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dio.dart';

class Auth extends ChangeNotifier {
  
  final storage = new FlutterSecureStorage();

  String token;
  String loginUserId;
    
  bool authenticated = false;
  User authenticatedUser;

  get loggedIn {
    return authenticated;
  }

  get user {      
      return authenticatedUser;
  }

  Future signin ({Map<String, dynamic> data, Function success, Function error}) async {
  
    try {
      
      print("SIGN IN DATA");
      print(data);
      
      Dio.Response response = await dio().post(
        'signin',
        data: json.encode(data)
      );

      print(response.toString());

      String token = json.decode(response.toString())['token'];

      print(token);

      this._setStoredToken(token);
      this.attempt(token: token);

      success();
      
    } catch (e) {
      error();
      print(e);
    }
  }  

  void attempt ({ token = ''}) async {
          
    print("ATTEMPTING");
    
    if(token.toString().isNotEmpty){
      this.token = token;
    }

    if(this.token.toString().isEmpty){
      return;
    }
    
    //var queryParams = {
      //'jwt': token,
    //};

    //print("ATEMPTING");
          
    //String queryString = Uri(queryParameters: queryParams).query;
    //var requestUrl = '/employee' + '?' + queryString;

    //print(requestUrl);
    
    try {
      Dio.Response response = await dio().get(
        'employee',
        options: Dio.Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );
        
      this.authenticated = true;

      print(json.decode(response.toString())['data']);

      var empJson = json.decode(response.toString())['data'];
      //print(empJson['emp_id']);

      var userId = empJson['emp_id'];

      this._setStoredUser(userId);

      var numMessages = empJson['num_messages'];

      print("FETCHED MESSAGES STORED: $numMessages");

      this._setStoredMessages(numMessages);

      //var myUser = await storage.read(key: 'token');

      empJson['emp_id'] = int.tryParse(empJson['emp_id']);
      
      //empJson['num_messages'] = int.tryParse(empJson['num_messages']);
      //var initNumMessages = empJson['num_messages'];
      //this._setStoredMessages(initNumMessages);

      print(empJson['emp_id']);
      print("EMP JSON");
      print(empJson);

      this.loginUserId = empJson['emp_id'].toString();

      var empJson2 = {
        'emp_id': '1',
        'first_name': "Allan",
        'emp_email' : "allan.hyde@livepages.com.au"
      };

      print("EMP JSON2");
      print(empJson2);

      this.authenticatedUser = User.fromJson(
        empJson
      );

      notifyListeners();

    } catch(e) {
      //this.authenticated = false;
      this._setUnauthenticated();
      print("ERROR $e");
    } 

  }

  void signout ({ Function success }) async {
    try {
      //await dio().post('url');
      print("SIGNING OUT");
      this._setUnauthenticated();
      notifyListeners();
      success();
    
    } catch (e){
      print("SIGNOUT ERR: $e");
    }
  }

  void _setUnauthenticated () async {
    this.authenticated = false;
    this.authenticatedUser = null;
    await storage.delete(key: "token"); 
    await storage.delete(key: "user"); 
    await storage.delete(key: "numMessages");
  }
  
  void _setStoredToken (String token) async {
    await storage.write(key: "token", value: token); 
  }

  void _setStoredUser (String userId) async {
    await storage.write(key: "user", value: userId); 
  }

  void _setStoredMessages (String numMessages) async {
    await storage.write(key: "numMessages", value: numMessages);



  }
  
  Future updateStatus ({Map<String, dynamic> data, Function success, Function error}) async {
  
    print("PUTTING");
    
    if(token.toString().isNotEmpty){
      this.token = token;
    }

    if(this.token.toString().isEmpty){
      return;
    }
    
    try {
      
      print("UPDATE DATA: $data");
      
      Dio.Response response = await dio().post(
        'booking/update',
        data: json.encode(data)
      );

      print(response.toString());
    
      success();
      
    } catch (e) {
      error();
      print("ERROR: $e");
    }

  }

  //POST UPDATE

  Future postForm ({Map<String, dynamic> data, Function success, Function error}) async {
  
    try {
      
      print("UPDATE DATA");
      print(data);
      
      Dio.Response response = await dio().post(
        'test/1',
        data: json.encode(data)
      );

      print(response.toString());

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