import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ready_prod/screens/route_navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:get_it/get_it.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
//final locator = GetIt.instance;

final storage = new FlutterSecureStorage();

final apiUrl = env['API_URL'];

//final apiUrl = 'https://mob.readyresourcesapp.com.au/api/';
//final apiUrl = 'http://rr.ttsite.com.au/api/';

Dio dio (){
  Dio dio = new Dio();

  dio.options.baseUrl = apiUrl;

  dynamic requestInterceptor(RequestOptions options) async {

    options.headers['Accept'] = 'application/json';

      var token = await storage.read(key: 'token');

      //print("DIO TOKEN: $token");
      //print("URL: $apiUrl");

      if(token.toString().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    return options;
    
  }

  /* void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  } */

  dynamic errorInterceptor(DioError dioError) {
    //if (dioError.message.contains("ERROR_001")) {
    if (dioError.response?.statusCode == 401) {
      // this will push a new route and remove all the routes that were present
      print("ERR______");
      
      final navigatorKey = NavKey.navKey;

      print("NAV_____ ${navigatorKey.currentState}");

      navigatorKey.currentState.pushNamedAndRemoveUntil(
          "/logged_out", (Route<dynamic> route) => false);
         //locator<NavigationService>().navigateTo('loggedout');
    }
    
    return dioError;
}

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) => requestInterceptor(options),  
    onError: (DioError dioError) => errorInterceptor(dioError)
  ));

  return dio;

}