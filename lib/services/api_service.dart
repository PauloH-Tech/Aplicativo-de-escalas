import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_escalas_front/config/app_config.dart';
import 'package:sistema_escalas_front/utils/erro_resposta.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class ApiService {
  //url localhost
  // static final String _baseUrl = 'http://127.0.0.1:8082';

  //url localhost devices
  // static final String _baseUrl = 'http://192.168.1.6:8082';

  //url produção
  // static final String _baseUrl = 'http://54.207.44.155:8080';

  static Future<dynamic> get(String path) async {
    final http.Response res;
    res = await http.get(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(res);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final http.Response res;
    // print(body);
    res = await http.post(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handle(res);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final http.Response res;
    res = await http.put(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return _handle(res);
  }

  static Future<dynamic> delete(String path) async {
    final http.Response res;
    res = await http.delete(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: {'Content-Type': 'application/json'},
    );
    return _handle(res);
  }

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
