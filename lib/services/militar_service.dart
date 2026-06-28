import 'package:sistema_escalas_front/models/militar.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

class MilitarService {
  static Future<List<Militar>> listarTodos() async {
    final data = await ApiService.get('/militar');
    return (data as List).map((j) => Militar.fromJson(j)).toList();
  }

  static Future<void> criar({
    required String nome,
    required Graduacao graduacao,
    required bool ativo,
  }) async {}

  static Future<void> editar({
    required String id,
    required String nome,
    required Graduacao graduacao,
    required bool ativo,
  }) async {}
}
