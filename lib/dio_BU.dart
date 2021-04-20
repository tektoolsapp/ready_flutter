import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

final apiUrl = env['API_URL'];

//final apiUrl = 'https://mob.readyresourcesapp.com.au/api/';
//final apiUrl = 'http://rr.ttsite.com.au/api/';

Dio dio (){
  Dio dio = new Dio();

  //dio.options.baseUrl = 'http://rr.ttsite.com.au/api/';
  //dio.options.baseUrl = 'https://mob.readyresourcesapp.com.au/api/';
  dio.options.baseUrl = apiUrl;

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        options.headers['Accept'] = 'application/json';

        var token = await storage.read(key: 'token');

        //print("DIO TOKEN: $token");
        //print("URL: $apiUrl");

        if(token.toString().isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

      }
    )
  );

  return dio;
}