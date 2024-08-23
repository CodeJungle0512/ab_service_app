import 'dart:convert';

import 'package:http/http.dart' as http;
import './preferences.dart';

class ApiHttp {
  String rootUri = 'https://abserviceapp.srvit.de';
  String type = 'application/json';

  Future<dynamic> get(String uri) async {
    try {
      final Uri url = Uri.parse(rootUri + uri);
      String? token = await getToken();
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': type,
      };
      final response = await http.get(url, headers: headers);
      return json.decode(response.body);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> post(String uri, var data) async {
    try {
      final Uri url = Uri.parse(rootUri + uri);
      String? token = await getToken();
      final Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': type,
      };
      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      Map<String, dynamic> result = {
        'status': response.statusCode,
        'data': json.decode(response.body)
      };
      return result;
    } catch (e) {
      print('Error:$e');
    }
  }
}
