import 'dart:convert';
import 'dart:developer' as dev show log;

import 'package:http/http.dart' as http;
import 'package:sistema_escalas_front/config/app_config.dart';
import 'package:sistema_escalas_front/services/auth_service.dart';
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

  static Map<String, String> _headers() {
    final usuario = AuthService.usuarioAtual;
    return {
      'Content-Type': 'application/json',
      if (usuario?.token != null && usuario?.tipo != null)
        'Authorization': '${usuario!.tipo} ${usuario!.token}',
    };
  }

  static Future<dynamic> get(String path) async {
    final http.Response res;
    res = await http.get(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _headers(),
    ).timeout(const Duration(seconds: 12));
    return _handle(res);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final http.Response res;
    // print(body);
    res = await http.post(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 12));

    return _handle(res);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final http.Response res;
    res = await http.put(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 12));

    return _handle(res);
  }

  static Future<dynamic> delete(String path) async {
    final http.Response res;
    res = await http.delete(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _headers(),
    ).timeout(const Duration(seconds: 12));
    return _handle(res);
  }

  static Future<dynamic> patch(String path, Map<String, dynamic>? body) async {
    final http.Response res;
    res = await http.patch(
      Uri.parse('${AppConfig.apiUrl}$path'),
      headers: _headers(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 12));
    return _handle(res);
  }

  static dynamic _handle(http.Response res) {
    dev.log('${res.statusCode}');
    dev.log(res.body);
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
    throw ApiException(erro.status, erro.message);
  }
}
