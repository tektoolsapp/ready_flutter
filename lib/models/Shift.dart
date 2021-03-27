import 'dart:convert';
import 'package:flutter_ready_prod/webservice/Resource.dart';

class Shift {
  
  String id;
  String ref;
  String start;
  String type;
  String time;
  String end;
  String endtime;
  String site;
  String status;
  
  Shift({ 
    this.id, 
    this.ref, 
    this.start, 
    this.type,
    this.time,
    this.end,
    this.endtime,
    this.site,
    this.status
  });

  factory Shift.fromJson(json){
    return Shift(
      id: json['shift_id'],
      ref: json['shift_ref'],
      start: json['shift_start'],
      type: json['shift_type'],
      time: json['shift_time'],
      end: json['shift_end'],
      endtime: json['shift_end_time'],
      site: json['shift_site'],
      status: json['shift_status']
    );
  }

  static Resource get all {
    return Resource(
      url: 'shifts',
      parse: (response) {
        Iterable list = json.decode(response.body)['data'];
        return list.map((model){
           return Shift.fromJson(model);
        })
        .toList();
      }
    );
  }
  
}