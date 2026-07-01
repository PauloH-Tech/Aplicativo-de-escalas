import 'package:sistema_escalas_front/models/escala_extra.dart';
import 'package:sistema_escalas_front/models/escala_extra_request.dart';
import 'package:sistema_escalas_front/models/militar.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

class EscalaService {
  static Future<List<Militar>> listaOrdenada(DateTime data) async {
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
        graduacao: Graduacao.terceiroSargento,
      ),
    ];
  }

  static Future<void> escalarMilitares({
    required EscalaExtraRequest escalados
  }) async {
    var body = escalados.toJson();
    await ApiService.post('/escala', body, null);
  }
}
