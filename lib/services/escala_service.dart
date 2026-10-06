import 'package:escalas_extras/models/escala_extra.dart';
import 'package:escalas_extras/models/escala_extra_request.dart';
import 'package:escalas_extras/services/api_service.dart';

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

  static Future<List<EscalaExtra>> escalarMilitares({
    required EscalaExtraRequest escalados,
  }) async {
    // print(body);
    final data = await ApiService.post('/escala', escalados.toJson());
    return (data as List).map((j) => EscalaExtra.fromJson(j)).toList();
  }

  static Future<void> deletarEscalado({required String id}) async {
    await ApiService.delete('/escala/$id');
  }
}
