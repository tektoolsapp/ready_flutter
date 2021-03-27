import 'package:http/http.dart';

class Resource2<T> {
  final String url; 
  T Function(Response response) parse;

  Resource2({this.url,this.parse});
}