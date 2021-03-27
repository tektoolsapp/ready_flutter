import 'dart:convert';

import 'package:flutter_ready_prod/webservice/Resource.dart';

class MessageNew {
  String id;
  String to;
  String title;
  String body;
  String shift;
  String sent;
  String status;
  bool isSelected;

  MessageNew({
    this.id, 
    this.to, 
    this.title, 
    this.body,
    this.shift,
    this.sent,
    this.status,
    this.isSelected,
  });

  factory MessageNew.fromJson(json){
    return MessageNew(
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

  static Resource getMessages (String messageTo) {
            
    return Resource(
      url: 'messages/$messageTo',
      parse: (response) {
                
        //print("MESSAGES RESPONSE:");
        //print(json.decode(response.body)['data']);

        //var messages = json.decode(response.body)['data'];

        //return messages;
        
        Iterable list = json.decode(response.body)['data'];

        print("LIST: $list");

        return list.map((model){
           return MessageNew.fromJson(model);
        })
        .toList();
      }
    );
  }

}