import 'package:http/http.dart';

class Resource {
    
  final String url;
  
  Function(Response response) parse;

  Resource({this.url, this.parse});

}