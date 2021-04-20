import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_ready_prod/webservice/Resource.dart';
import '../dio.dart';

class Shift2 extends ChangeNotifier {
  
  String id;
  String ref;
  String start;
  String type;
  String time;
  String end;
  String endtime;
  String site;
  String status;
  String confirm;
  
  Shift2({ 
    this.id, 
    this.ref, 
    this.start, 
    this.type,
    this.time,
    this.end,
    this.endtime,
    this.site,
    this.status,
    this.confirm
  });

  factory Shift2.fromJson(json){
    return Shift2(
      id: json['shift_id'],
      ref: json['shift_ref'],
      start: json['shift_start'],
      type: json['shift_type'],
      time: json['shift_time'],
      end: json['shift_end'],
      endtime: json['shift_end_time'],
      site: json['shift_site'],
      status: json['shift_status'],
      confirm: json['shift_confirm']
    );
  }

  @override
  //String toString() {
    //return 'Test: {email: ${emailAddress}, password: ${password}}';
  //}

  static Resource getShifts (String shiftId) {
            
    return Resource(
      url: 'test/$shiftId',
          
      parse: (response) {     
        
        print("RESPONDING");
        
        print(json.decode(response.body));

        final test = json.decode(response.body)['data'];
           
           //print("TEST $test:");

           return Shift2.fromJson(test);
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

           return Shift2.fromJson(shift);
      }
    );
  }

  

}