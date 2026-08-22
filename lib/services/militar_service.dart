import 'package:sistema_escalas_front/models/militar.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

class MilitarService {
  static Future<List<Militar>> listarTodos() async {
    final data = await ApiService.get('/militar');
    return (data as List).map((j) => Militar.fromJson(j)).toList();

    return [
      Militar(
        id: '1',
        nome: 'DOS SANTOS',
        stAtivo: true,
        graduacao: Graduacao.segundoSargento,
      ),
      Militar(
        id: '2',
        nome: 'TEIXEIRA',
        stAtivo: true,
        graduacao: Graduacao.cabo,
      ),
      Militar(
        id: '3',
        nome: 'JULIANA',
        stAtivo: true,
        graduacao: Graduacao.cabo,
      ),
    ];
  }

  static Future<void> criar({
    required String nome,
    required Graduacao graduacao,
    required bool ativo,
  }) async {
    var body = {'nome': nome, 'stAtivo': ativo, 'graduacao': graduacao.value};
    await ApiService.post('/militar', body);
  }

  static Future<void> editar({
    required String id,
    required String nome,
    required Graduacao graduacao,
    required bool ativo,
  }) async {
    var body = {'nome': nome, 'stAtivo': ativo, 'graduacao': graduacao.value};
    await ApiService.put('/militar/$id', body);
  }

  static Future<void> inativar({required String id}) async {
    await ApiService.patch('/militar/$id/inativar', null);
    // print('militar deletado id: $id');
  }
}
