import 'package:sistema_escalas_front/models/acesso_usuario.dart';
import 'package:sistema_escalas_front/models/usuario.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

class UsuarioService {
  static Future<List<AcessoUsuario>> listar() async {
    final data = await ApiService.get('/usuarios');
    return (data as List).map((j) => AcessoUsuario.fromJson(j)).toList();
  }

  /// Cria o acesso sem senha; o militar conclui pelo "primeiro acesso" no app.
  static Future<AcessoUsuario> concederAcesso({
    required String militarId,
    required String email,
    required Role role,
  }) async {
    final body = {'militarId': militarId, 'email': email, 'role': role.name.toUpperCase()};
    return AcessoUsuario.fromJson(await ApiService.post('/usuarios/acesso', body));
  }

  static Future<AcessoUsuario> atualizarAcesso({
    required String id,
    required String email,
    required Role role,
  }) async {
    final body = {'email': email, 'role': role.name.toUpperCase()};
    return AcessoUsuario.fromJson(await ApiService.put('/usuarios/$id', body));
  }

  static Future<void> alterarStatus({required String id, required bool ativo}) async {
    await ApiService.patch('/usuarios/$id/status?ativo=$ativo', null);
  }
}
