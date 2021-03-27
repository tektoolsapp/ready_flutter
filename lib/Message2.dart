import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
//import 'package:flutter_ready_prod/screens/DetailsPage.dart';
import 'package:flutter_ready_prod/webservice/Resource.dart';
import 'dio.dart';

class Message2 extends ChangeNotifier {
  
  String id;
  String to;
  String title;
  String body;
  String shift;
  String sent;
  String status;
  //bool isSelected;
  //bool isDeleted;
  //bool reload;
  
  Message2({ 
    this.id, 
    this.to, 
    this.title, 
    this.body,
    this.shift,
    this.sent,
    this.status,
    //this.isSelected,
    //this.isDeleted,
  });

  factory Message2.fromJson(json){
    return Message2(
      id: json['message_id'],
      to: json['message_to'],
      title: json['message_title'],
      body: json['message_body'],
      shift: json['message_shift'],
      sent: json['message_sent'],
      status: json['message_status'],
      //isSelected: false,
      //isDeleted: false
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
           return Message2.fromJson(model);
        })
        .toList();
      }
    );
  }

  Future deleteMessage ({Map<String, dynamic> data, Function success, Function error}) async {
  
    try {
      
      print("DELETE MESSAGE:");
      //print(data);
      
      Dio.Response response = await dio().post(
        'fcm/remove',
        data: json.encode(data)
      );

      var delResp = response.data.toString();

      print("DELETED RESPONSE: $delResp");

      notifyListeners();
            
      success();
      
    } catch (e) {
      error();
      print(e);
    }
  }

}