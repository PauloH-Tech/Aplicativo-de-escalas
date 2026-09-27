import 'dart:convert';
import 'dart:developer' as dev;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_escalas_front/models/usuario.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

class AuthService {
  static const _key = 'usuario';

  static Usuario? usuarioAtual;

  static Future<Usuario> login(String email, String senha) async {
    //TODO: refatorar para comunicacao com o backend
    // await Future.delayed(const Duration(milliseconds: 600));

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

  static Future<void> _salvar(Usuario u) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(u.toJson()));
    // DEPOIS: com token real, prefira flutter_secure_storage
  }
}
