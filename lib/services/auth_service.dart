import 'dart:convert';
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:escalas_extras/models/usuario.dart';
import 'package:escalas_extras/services/api_service.dart';

class AuthService {
  static const _key = 'usuario';

  static Usuario? usuarioAtual;

  static Future<Usuario> login(String email, String senha) async {
    var body = {'email': email, 'senha': senha};
    final data = await ApiService.post('/auth/login', body);

    final logado = Usuario.fromJson(data);

    usuarioAtual = logado;
    await _salvar(logado);
    // dev.log(usuarioAtual!.nome);
    // dev.log(usuarioAtual!.token);
    // dev.log(usuarioAtual!.role.name);
    // dev.log(usuarioAtual!.militarId.toString());
    return logado;
  }

  static Future<void> logout() async {
    usuarioAtual = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<Usuario?> carregarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;

    try {
      usuarioAtual = Usuario.fromJson(jsonDecode(json));
      // DEPOIS: verificar se o token expirou (ex.: pacote jwt_decoder)
      // if (JwtDecoder.isExpired(usuarioAtual!.token!)) { await logout(); return null; }
      return usuarioAtual;
    } catch (_) {
      await logout();
      return null;
    }
  }

  static Future<void> esqueciSenha(String email) async {
    final body = {'email': email};
    await ApiService.post('/auth/forgot-password', body);
  }

  static Future<void> redefinirSenha(String token, String senha) async {
    final body = {'token': token, 'novaSenha': senha};
    await ApiService.post('/auth/reset-password', body);
  }

  static Future<void> _salvar(Usuario u) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(u.toJson()));
    // DEPOIS: com token real, prefira flutter_secure_storage
  }

  static Future<void> primeiroAcesso(String email) async {
    final body = {'email': email};
    await ApiService.post('/auth/primeiro-acesso', body);
  }

  static Future<void> confirmarPrimeiroAcesso(
    String token,
    String nome,
    String senha,
  ) async {
    final body = {'token': token, 'nome': nome, 'senha': senha};
    await ApiService.post('/auth/primeiro-acesso/confirmar', body);
  }
}
