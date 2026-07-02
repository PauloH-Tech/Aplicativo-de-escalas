import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_escalas_front/utils/erro_resposta.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiService {
  static final String _baseUrl = 'http://127.0.0.1:8082';

  // static final String _baseUrl = 'http://192.168.1.6:8082';

  static Future<dynamic> get(String path, dynamic pathVariable) async {
    // print(pathVariable);
    final http.Response res;
    if (pathVariable == null) {
      res = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      res = await http.get(
        Uri.parse('$_baseUrl$path/$pathVariable'),
        headers: {'Content-Type': 'application/json'},
      );
    }
    // print(res.statusCode);
    // print(res.body);

    return _handle(res);
  }

  static Future<dynamic> post(
    String path,
    Map<String, dynamic> body,
    dynamic pathVariable,
  ) async {
    final http.Response res;
    // print(body);
    if (pathVariable == null) {
      res = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } else {
      res = await http.post(
        Uri.parse('$_baseUrl$path/$pathVariable'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }
    return _handle(res);
  }

  static Future<dynamic> put(
    String path,
    Map<String, dynamic> body,
    dynamic pathVariable,
  ) async {
    final http.Response res;
    if (pathVariable == null) {
      res = await http.put(
        Uri.parse('$_baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } else {
      res = await http.put(
        Uri.parse('$_baseUrl$path/$pathVariable'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }
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
    ErroResposta erro;
    try {
      erro = ErroResposta.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } catch (_) {
      throw ApiException(res.statusCode, 'Erro desconhecido');
    }
    throw ApiException(erro.status, erro.mensagem);
  }
}
