import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_ready_prod/dio.dart';
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
  String confirm;
  bool confirmStatus;
  
  Shift({ 
    this.id, 
    this.ref, 
    this.start, 
    this.type,
    this.time,
    this.end,
    this.endtime,
    this.site,
    this.status,
    this.confirm,
    this.confirmStatus
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
      status: json['shift_status'],
      confirm: json['shift_confirm']
    );
  }

  static Resource get all {
    return Resource(
      url: 'shifts',
      parse: (response) {
        print("GETTING SHIFTS");
        var respCode = json.decode(response.body)['status'];
        print("RESP $respCode");
        print(json.decode(response.body)['status']);

        if(respCode == 401){
          return respCode;
          //return
        } else {
          print(json.decode(response.body)['data']);
          Iterable list = json.decode(response.body)['data'];
          return list.map((model){
            return Shift.fromJson(model);
          })
          .toList();
        }
      }
    );
  }

  //static get allShifts async {
  //
  Future<List<Shift>> allShifts() async {
    try {
      
      Dio.Response response = await dio().get(
        'shifts'
      );

      print("RESP CODE: ${response.statusCode}");
      print("RESP: ${response.data['data']}");

      return (response.data['data'] as List)
          .map((x) => Shift.fromJson(x))
          .toList();
      
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Shift> byShift(String shiftId) async {
            
    print("SHIFTX: $shiftId");
    
    final url = 'shift/$shiftId';

    print("URL $url");
          
    try {
      
      Dio.Response response = await dio().get(
        url
      );

      print("RESP CODEX: ${response.statusCode}");
      print("RESPX: ${response.data['data'][0]}");

      final shift = response.data['data'][0];           
      print("SHIFT $shift:");

      return Shift.fromJson(shift);
      
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

}