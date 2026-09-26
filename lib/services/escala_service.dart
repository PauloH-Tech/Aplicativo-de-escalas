import 'package:sistema_escalas_front/models/escala_extra_request.dart';
import 'package:sistema_escalas_front/services/api_service.dart';

import '../models/militar_fila.dart';

class EscalaService {
  static Future<List<MilitarFila>> listaOrdenada({
    required DateTime date,
  }) async {
    var dataFormatada = date.toIso8601String().split('T').first;
    // print(dataFormatada);
    var data = await ApiService.get('/escala/$dataFormatada');
    // print(data);
    return (data as List).map((j) => MilitarFila.fromJson(j)).toList();

    // return [
    //   MilitarFila(
    //     id: '1',
    //     nome: 'DOS SANTOS',
    //     graduacao: Graduacao.segundoSargento,
    //     dtUltimaEscala: DateTime(20),
    //     qtEscalas: 3,
    //     tpAfastamento: TipoAfastamento.atestado,
    //   ),
    //   MilitarFila(
    //     id: '2',
    //     nome: 'teste',
    //     graduacao: Graduacao.segundoSargento,
    //     dtUltimaEscala: DateTime(20),
    //     qtEscalas: 3,
    //     tpAfastamento: null,
    //   ),
    //   MilitarFila(
    //     id: '3',
    //     nome: 'testets',
    //     graduacao: Graduacao.segundoSargento,
    //     dtUltimaEscala: DateTime(20),
    //     qtEscalas: 3,
    //     tpAfastamento: null,
    //   ),
    // ];
  }

  static Future<void> escalarMilitares({
    required EscalaExtraRequest escalados,
  }) async {
    var body = escalados.toJson();
    // print(body);
    await ApiService.post('/escala', body);
  }

  static Future<void> deletarEscalado({required String id}) async {
    await ApiService.delete('/escala/$id');
  }
}
