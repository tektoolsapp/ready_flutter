import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Resource.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();
final apiUrl = env['API_URL'];

//final apiUrl = 'https://mob.readyresourcesapp.com.au/api/';

class Webservice {
  Future load (Resource resource) async {
    //print("RES: $resource");
    var token = await storage.read(key: 'token');

    //print("TOKEN: $token");
    
    final getUrl = apiUrl + resource.url;
    
    print("GET $getUrl");
    
    final response = await http.get(apiUrl + resource.url, headers: {
    
    //final response = await http.get('https://mob.readyresourcesapp.com.au/api/${resource.url}', headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    
    //print("RES: $response");
    
    return resource.parse(response);
  }
}