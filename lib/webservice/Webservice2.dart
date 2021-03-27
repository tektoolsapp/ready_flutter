import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ready_prod/webservice/Resource2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();
final apiUrl = env['API_URL'];

class Webservice2 {

  Future<T> load<T>(Resource2<T> resource) async {

      final response = await http.get(resource.url);
      if(response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to load data!');
      }
  }

}