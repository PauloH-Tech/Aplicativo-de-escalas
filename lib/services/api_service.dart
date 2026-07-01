import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'Erro $statusCode: $message';
}

class ApiService {
  static final String _baseUrl = 'http://127.0.0.1:8082';
  // static final String _baseUrl = 'http://192.168.1.6:8082';

  static Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(response);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body, String? id) async {
    final http.Response res;
    print(body);
    if (id == null){
      res = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } else {
       res = await http.post(
        Uri.parse('$_baseUrl$path/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }
    return _handle(res);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$path'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(res);
  }

  static Future<dynamic> delete(String path) async {}

  static dynamic _handle(http.Response res) {
    // print(res.statusCode);
    // print(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    throw ApiException(res.statusCode, res.body);
  }
}
