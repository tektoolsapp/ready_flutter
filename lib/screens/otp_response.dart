import 'dart:convert';

import 'package:flutter/material.dart';

class OneTimePasswordResponse {
 final String verificationCode;
 OneTimePasswordResponse({
   @required this.verificationCode,
 });

 static OneTimePasswordResponse fromMap(Map<String, dynamic> map) {
   if (map == null) return null;

   return OneTimePasswordResponse(
     verificationCode: map['verificationCode'],
   );
 }

 static OneTimePasswordResponse fromJson(String source) => fromMap(json.decode(source));

 @override
 String toString() {
   return 'verificationCode: $verificationCode';
 }
}