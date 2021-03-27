import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/dio.dart';
import 'package:flutter_ready_prod/webservice/Resource.dart';

class Message extends ChangeNotifier {
  
  String id;
  String to;
  String title;
  String body;
  String shift;
  String sent;
  String status;
  bool isSelected;
  
  Message({ 
    this.id, 
    this.to, 
    this.title, 
    this.body,
    this.shift,
    this.sent,
    this.status,
    this.isSelected,
  });

  factory Message.fromJson(json){
    return Message(
      id: json['message_id'],
      to: json['message_to'],
      title: json['message_title'],
      body: json['message_body'],
      shift: json['message_shift'],
      sent: json['message_sent'],
      status: json['message_status'],
      isSelected: false
    );
  }

  static Resource get all {
            
    return Resource(
      url: 'messages',
      parse: (response) {
                
        Iterable list = json.decode(response.body)['data'];

        return list.map((model){
           return Message.fromJson(model);
        })
        .toList();
      }
    );
  }
  
  static Resource getMessages (String messageTo) {

    return Resource(
      url: 'messages/$messageTo',
      parse: (response) {
                
        print("GET MESSAGES:");
        //print(json.decode(response.body)['data']);

        Iterable list = json.decode(response.body)['data'];

        return list.map((model){
           return Message.fromJson(model);
        })
        .toList();
      }
    );
  }
  
  static Resource fromMessages (String messageTo) {
            
    return Resource(
      url: 'messages/$messageTo',
      parse: (response) {
                
        print("MESSAGES RESPONSE:");
        print(json.decode(response.body)['data']);
        
        Iterable list = json.decode(response.body)['data'];

        return list.map((model){
           return Message.fromJson(model);
        })
        .toList();
      }
    );
  }

  static Resource byShift (String shiftId) {
            
    print("SHIFT: $shiftId");
    
    return Resource(
      url: 'shift/$shiftId',
          
      parse: (response) {     
        
        print(json.decode(response.body)['data']);

        final shift = json.decode(response.body)['data'][0];
           
           print("SHIFT $shift:");

           return Message.fromJson(shift);
      }
    );
  }

  Future deleteMessage ({Map<String, dynamic> data, Function success, Function error}) async {
  
    try {
      
      print("DELETE MESSAGE");
      print(data);
      
      Dio.Response response = await dio().post(
        'fcm/remove',
        data: json.encode(data)
      );

      var delResp = response.data.toString();

      print("DELETED: $delResp");

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