import 'dart:convert';

import 'package:http/http.dart' as http;

class FlaskRestApi {
  static final String baseUrl = 'http://127.0.0.1:5000';
  static final Map<String, String> headers = {
    'Content-Type': 'application/json'
  };
  static String keyArg(String key) => '?key=' + key;

  //returns api key
  static Future<String> register(Map<String, dynamic> payload) async {
    http.Response response = await http.post(Uri.parse(baseUrl + '/register'),
        headers: headers, body: payload);
    return response.body;
  }

  static Future<Map<String, dynamic>> readUser(String key) async {
    http.Response response =
        await http.get(Uri.parse(baseUrl + '/user' + keyArg(key)));
    if (response.body.contains('error')) throw Exception(response.body);
    return jsonDecode(response.body);
  }

  static void updateUser(String key) {}
  static void deleteUser(String key) {}

  //returns password data id
  static Future<String> createPasswordData(String key, String json) async {
    http.Response response = await http.post(
        Uri.parse(baseUrl + '/pwdata' + keyArg(key)),
        headers: headers,
        body: json);
    if (response.body.contains('error')) throw Exception(response.body);
    return jsonDecode(response.body)['message'];
  }

  // returns all password data associated to key (user)
  static Future<Map<String, dynamic>> readPasswordData(String key) async {
    http.Response response = await http
        .get(Uri.parse(baseUrl + '/pwdata' + keyArg(key)), headers: headers);
    if (response.body.contains('error')) throw Exception(response.body);
    return jsonDecode(response.body);
  }

  static Future<void> updatePasswordData(
    String key,
    String id,
    String json,
  ) async {
    print(json);
    http.Response response = await http.put(
        Uri.parse(baseUrl + '/pwdata' + keyArg(key) + '&id=' + id),
        headers: headers,
        body: json);
    if (response.body.contains('error')) throw Exception(response.body);
  }

  static Future<void> deletePasswordData(String key, String id) async {
    http.Response response = await http.delete(
        Uri.parse(baseUrl + '/pwdata' + keyArg(key) + '&id=' + id),
        headers: headers);
    if (response.body.contains('error')) throw Exception(response.body);
  }
}
